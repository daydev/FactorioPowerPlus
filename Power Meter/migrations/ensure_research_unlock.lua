for _, force in pairs(game.forces) do
    local technologies = force.technologies
    local recipes = force.recipes

    recipes["power-meter-usage-combinator"].enabled = technologies["circuit-network"].researched
end