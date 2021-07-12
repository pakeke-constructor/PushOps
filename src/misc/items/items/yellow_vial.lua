
--[[

Whenever a splat occurs, there is a 20% chance
to spawn an immune mushroom block

]]


local rand = love.math.random


local function spawnmush(x,y)
    local e = EH.Ents.mushroomblock(x,y)
    e.colour = CONSTANTS.SPLAT_COLOUR
    e.physicsImmune = true
end


return {
    splat = function(player, x, y, range)
        if rand() <= 0.2 then
            ccall("await", spawnmush, 0, x,y)
        end
    end
}


