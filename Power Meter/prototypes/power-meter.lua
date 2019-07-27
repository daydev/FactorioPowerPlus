local offset_xy = util.by_pixel(17, -12)
local sprite_width = 162
local sprite_height = 129

local combinator_sprite = {
    layers = {
        {
            filename = "__PowerPlusPowerMeter__/graphics/hr-power-meter.png",
            priority = "high",
            width = sprite_width,
            height = sprite_height,
            shift = offset_xy,
            scale = 0.5,
            hr_version = {
                filename = "__PowerPlusPowerMeter__/graphics/hr-power-meter.png",
                priority = "high",
                width = sprite_width,
                height = sprite_height,
                shift = offset_xy,
                scale = 0.5
            }
        },
        {
            filename = "__PowerPlusPowerMeter__/graphics/hr-power-meter-shadow.png",
            priority = "high",
            width = sprite_width,
            height = sprite_height,
            shift = offset_xy,
            draw_as_shadow = true,
            scale = 0.5,
            hr_version = {
                filename = "__PowerPlusPowerMeter__/graphics/hr-power-meter-shadow.png",
                priority = "high",
                width = sprite_width,
                height = sprite_height,
                shift = offset_xy,
                draw_as_shadow = true,
                scale = 0.5
            }
        }
    }
}

local activity_led_sprite = {
    scale = 0.5,
    filename = "__PowerPlusPowerMeter__/graphics/power-meter-LED.png",
    width = sprite_width,
    height = sprite_height,
    shift = offset_xy
}

local wire_location = {
    shadow = {
        red = util.by_pixel(32, 14.5),
        green = util.by_pixel(30, 17.5)
    },
    wire = {
        red = util.by_pixel(22, 1.5),
        green = util.by_pixel(11.25, 8.875)
    }
}

data:extend({
    {
        type = "item",
        name = "power-meter-usage-combinator",
        icon = "__PowerPlusPowerMeter__/graphics/icons/power-meter.png",
        icon_size = 64,
        flags = {},
        subgroup = "circuit-network",
        order = "c[other]-c[power-meter-usage-combinator]",
        place_result = "power-meter-usage-combinator",
        stack_size = 50,
    },

    {
        type = "recipe",
        name = "power-meter-usage-combinator",
        energy_required = 1,
        enabled = false,
        ingredients = {
            { 'constant-combinator', 1 },
            { 'copper-cable', 10 },
            { 'electronic-circuit', 2 }
        },
        result = "power-meter-usage-combinator"
    },

    {
        type = "constant-combinator",
        name = "power-meter-usage-combinator",
        icon = "__PowerPlusPowerMeter__/graphics/icons/power-meter.png",
        icon_size = 64,
        flags = { "placeable-neutral", "player-creation", "not-rotatable" },
        minable = { mining_time = 0.1, result = "power-meter-usage-combinator" },
        max_health = 200,

        corpse = "small-remnants",
        collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
        selection_box = { { -0.5, -0.5 }, { 0.6, 0.6 } },

        item_slot_count = 3,
        activity_led_light = { intensity = 0.8, size = 1, color = { r = 1.0, g = 1.0, b = 1.0 } },
        activity_led_light_offsets = {
            offset_xy,
            offset_xy,
            offset_xy,
            offset_xy
        },
        circuit_wire_max_distance = 9,

        energy_source = {
            type = "electric",
            usage_priority = "secondary-input"
        },
        energy_usage_per_tick = "10KW",

        vehicle_impact_sound = { filename = '__base__/sound/car-metal-impact.ogg', volume = 0.65 },

        sprites = {
            north = combinator_sprite,
            south = combinator_sprite,
            east = combinator_sprite,
            west = combinator_sprite
        },

        activity_led_sprites = {
            north = activity_led_sprite,
            south = activity_led_sprite,
            east = activity_led_sprite,
            west = activity_led_sprite
        },

        circuit_wire_connection_points = {
            wire_location,
            wire_location,
            wire_location,
            wire_location
        }
    }

})