local unlocked_by = "circuit-network"

if data.raw.technology[unlocked_by] and data.raw.technology[unlocked_by].effects then
    table.insert(
            data.raw.technology[unlocked_by].effects,
            { type = 'unlock-recipe', recipe = "power-meter-usage-combinator" })
end