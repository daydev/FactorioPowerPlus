UPDATE_INTERVAL_SETTING = "power-meter-tick-update-interval"
METER_ENTITY = "power-meter-usage-combinator"
METER_REGISTRY = "meter_registry"
INTERFACE_CONFIG = {
    primary = "power-meter-interface-p1",
    secondary = "power-meter-interface-p2",
    tertiary = "power-meter-interface-p3"
}

function create_meter(meter_entity)
    local new_meter_block = {}
    new_meter_block["meter"] = meter_entity
    prepare_or_repair_meter(new_meter_block, meter_entity)
    global[METER_REGISTRY][meter_entity.unit_number] = new_meter_block
end

function prepare_or_repair_meter(meter_block, meter)
    local interfaces = meter_block["interfaces"] or {}
    for priority, interface in pairs(INTERFACE_CONFIG) do
        if (not interfaces[priority]) or (not interfaces[priority].valid) then
            interfaces[priority] = meter.surface.create_entity({
                name = interface,
                position = meter.position,
                force = meter.force
            })
        end
    end
    meter_block["interfaces"] = interfaces
end

function remove_meter(meter_id)
    if global[METER_REGISTRY][meter_id] then
        for _, interface in pairs(global[METER_REGISTRY][meter_id]["interfaces"]) do
            interface.destroy()
        end
        global[METER_REGISTRY][meter_id] = nil
    end
end

function update_meter(meter_block)
    local power_parameters = {}
    for priority, interface in pairs(meter_block["interfaces"]) do
        if interface.valid then
            insert_signals(power_parameters, interface, priority)
            interface.fluidbox[1] = { name = "void-energy", amount = 100, temperature = 0 }
        else
            local meter = meter_block["meter"]
            log("Error: A power meter on surface [" .. meter.surface.name ..
                    "]  at " .. serpent.line(meter.position) ..
                    " has an invalid interface for [" .. priority ..
                    "]. Attempting to repair.")
            return prepare_or_repair_meter(meter_block, meter)
        end
    end
    meter_block["meter"].get_or_create_control_behavior().parameters = { parameters = power_parameters }
end

function insert_signals(parameters, interface, priority)
    local utilization = math.ceil(interface.energy_generated_last_tick * 10)
    -- Solar hack, if "primary" is on, it means we're past solar
    if priority == "primary" then
        table.insert(parameters, {
            index = 1,
            signal = { name = ("power-meter-solar"), type = "virtual" },
            count = utilization > 0 and 100 or 0
        })
    end
    table.insert(parameters, {
        index = (#parameters + 1),
        signal = { name = ("power-meter-" .. priority), type = "virtual" },
        count = utilization
    })

    table.insert(parameters, {
        index = (#parameters + 1),
        signal = { name = ("power-meter-" .. priority .. "-capacity"), type = "virtual" },
        count = 100 - utilization
    })

end

function handle_init()
    if not global[METER_REGISTRY] then
        global[METER_REGISTRY] = {}
    end
end

function handle_build(event)
    local entity = event.created_entity or event.entity
    if entity and entity.valid and entity.name == METER_ENTITY then
        return create_meter(entity)
    end
end

function handle_destroy(event)
    local entity = event.entity
    if entity and entity.valid and entity.name == METER_ENTITY then
        return remove_meter(entity.unit_number)
    end
end

function handle_destroy_surface(event)
    local surface = game.surfaces[event.surface_index]
    if surface and surface.valid then
        local meters = surface.find_entities_filtered { name = METER_ENTITY }
        if meters then
            for _, m in pairs(meters) do
                if m.valid then
                    remove_meter(m.unit_number)
                end
            end
        end
    end
end

function handle_update_meters()
    for id, meter_block in pairs(global[METER_REGISTRY]) do
        if meter_block["meter"].valid then
            update_meter(meter_block)
        else
            log("Error: Invalid power meter encountered. Cleaning up.")
            remove_meter(id)
        end
    end
end

script.on_init(handle_init)
script.on_configuration_changed(handle_init)

script.on_event(
        { defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_revive, defines.events.script_raised_built },
        handle_build)
script.on_event(
        { defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died, defines.events.script_raised_destroy },
        handle_destroy)
script.on_event(
        defines.events.on_pre_surface_deleted,
        handle_destroy_surface)

if settings.startup[UPDATE_INTERVAL_SETTING].value == 1 then
    script.on_event(defines.events.on_tick, handle_update_meters)
else
    script.on_nth_tick(settings.startup[UPDATE_INTERVAL_SETTING].value, handle_update_meters)
end