local interface_empty_sprite = {
    filename = "__PowerPlusPowerMeter__/graphics/empty.png",
    width = 32,
    height = 32,
    hr_version = {
        filename = "__PowerPlusPowerMeter__/graphics/empty.png",
        width = 32,
        height = 32
    }
}

local interface_primary = {
    type = "generator",
    name = "power-meter-interface-p1",
    icon = "__PowerPlusPowerMeter__/graphics/icons/power-primary.png",
    icon_size = 64,
    flags = { "not-on-map",
              "not-blueprintable",
              "not-deconstructable",
              "hidden",
              "hide-alt-info",
              "not-flammable",
              "not-repairable",
              "not-upgradable",
              "no-copy-paste" },
    minable = nil,
    max_health = 50,
    corpse = "small-remnants",
    effectivity = 1,
    fluid_usage_per_tick = 0.1,
    maximum_temperature = 0,
    burns_fluid = true,
    fluid_box = {
        base_area = 1,
        height = 2,
        base_level = -1,
        pipe_connections = {},
        production_type = "input-output",
        filter = "void-energy",
        minimum_temperature = 0.0
    },
    energy_source = {
        type = "electric",
        usage_priority = "primary-output"
    },
    horizontal_animation = interface_empty_sprite,
    vertical_animation = interface_empty_sprite
}

local interface_secondary = util.table.deepcopy(interface_primary)
interface_secondary.name = "power-meter-interface-p2"
interface_secondary.icon = "__PowerPlusPowerMeter__/graphics/icons/power-secondary.png"
interface_secondary.energy_source.usage_priority = "secondary-output"

local interface_tertiary = util.table.deepcopy(interface_primary)
interface_tertiary.name = "power-meter-interface-p3"
interface_tertiary.icon = "__PowerPlusPowerMeter__/graphics/icons/power-tertiary.png"
interface_tertiary.energy_source.usage_priority = "tertiary"


data:extend({ interface_primary, interface_secondary, interface_tertiary })