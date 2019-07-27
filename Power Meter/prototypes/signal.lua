data:extend({
    {
        type = "item-subgroup",
        name = "power-meter-signal",
        group = "signals",
        order = "p[power-meter-signal]"
    },
    {
        type = "virtual-signal",
        name = "power-meter-primary",
        icon = "__PowerPlusPowerMeter__/graphics/icons/power-primary.png",
        icon_size = 64,
        subgroup = "power-meter-signal",
        order = "p[power-meter-signal]-1[primary]"
    },
    {
        type = "virtual-signal",
        name = "power-meter-secondary",
        icon = "__PowerPlusPowerMeter__/graphics/icons/power-secondary.png",
        icon_size = 64,
        subgroup = "power-meter-signal",
        order = "p[power-meter-signal]-2[secondary]"
    },
    {
        type = "virtual-signal",
        name = "power-meter-tertiary",
        icon = "__PowerPlusPowerMeter__/graphics/icons/power-tertiary.png",
        icon_size = 64,
        subgroup = "power-meter-signal",
        order = "p[power-meter-signal]-3[tertiary]"
    }
})