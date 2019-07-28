UPDATE_INTERVAL_SETTING = "power-meter-tick-update-interval"
METER_ENTITY = "power-meter-usage-combinator"
INTERFACE_PRIMARY = "power-meter-interface-p1"
INTERFACE_SECONDARY = "power-meter-interface-p2"
INTERFACE_TERTIARY = "power-meter-interface-p3"
INTERFACE_SOLAR = "power-meter-interface-ps"
METER_REGISTRY = "meter_registry"

function create_meter(meter_entity)
    local new_meter_block = {}
    new_meter_block["meter"] = meter_entity
    new_meter_block["interfaces"] = {}
    new_meter_block["interfaces"]["primary"] = meter_entity.surface.create_entity({
        name = INTERFACE_PRIMARY,
        position = meter_entity.position,
        force = meter_entity.force
    })
    new_meter_block["interfaces"]["secondary"] = meter_entity.surface.create_entity({
        name = INTERFACE_SECONDARY,
        position = meter_entity.position,
        force = meter_entity.force
    })
    new_meter_block["interfaces"]["tertiary"] = meter_entity.surface.create_entity({
        name = INTERFACE_TERTIARY,
        position = meter_entity.position,
        force = meter_entity.force
    })
    global[METER_REGISTRY][meter_entity.unit_number] = new_meter_block
end

function remove_meter(meter_entity)
    if global[METER_REGISTRY][meter_entity.unit_number] then
        for _, interface in pairs(global[METER_REGISTRY][meter_entity.unit_number]["interfaces"]) do
            interface.destroy()
        end
        global[METER_REGISTRY][meter_entity.unit_number] = nil
    end
end

function update_meter(meter_block)
    local power_parameters = {}
    for priority, interface in pairs(meter_block["interfaces"]) do
        -- Solar hack, if "primary" is on, it means we're past solar
        if interface.name == INTERFACE_PRIMARY then
            local solar_utilization = 0
            if interface.energy_generated_last_tick > 0 then
                solar_utilization = 100
            end
            table.insert(power_parameters, {
                index = 1,
                signal = { name = ("power-meter-solar"), type = "virtual" },
                count = solar_utilization
            })
        end
        table.insert(power_parameters, {
            index = (#power_parameters + 1),
            signal = { name = ("power-meter-" .. priority), type = "virtual" },
            count = math.ceil(interface.energy_generated_last_tick)
        })
        interface.fluidbox[1] = { name = "void-energy", amount = 200, temperature = 0 }
    end
    meter_block["meter"].get_or_create_control_behavior().parameters = { parameters = power_parameters }
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
        return remove_meter(entity)
    end
end

function handle_destroy_surface(event)
    local surface = game.surfaces[event.surface_index]
    if surface then
        local meters = surface.find_entities_filtered { name = METER_ENTITY }
        for _, m in pairs(meters) do
            remove_meter(m)
        end
    end
end

function handle_update_meters()
    for _, meter_block in pairs(global[METER_REGISTRY]) do
        update_meter(meter_block)
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