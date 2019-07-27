data:extend({
    {
        type = "fluid",
        name = "void-energy",
        hidden = "true",
        default_temperature = 0,
        max_temperature = 0,
        fuel_value = "1kJ",
        auto_barrel = false,
        heat_capacity = "1kJ",
        base_color = {r = 0, g = 0, b = 128},
        flow_color = {r = 0.5, g = 0.5, b = 1},
        icon = "__PowerPlusPowerMeter__/graphics/icons/void-energy.png",
        icon_size = 32,
        order = "a[fluid]-v[void-energy]",
        pressure_to_speed_ratio = 0.4,
        flow_to_energy_ratio = 0.59
    }
})