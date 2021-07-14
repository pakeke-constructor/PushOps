--[[
    
Mushroom chunk
    When the player takes damage below 40% health,
    a mushroom block spawns near the player

]]


local rand = love.math.random

local function spawnmush(player)
    local pos = player.pos
    local e = EH.Ents.mushroomblock(pos.x + rand(-15,15),
                                    pos.y + rand(-15,15))
end



return {

    damage = function(player, ent, amount)
        if ent == player then
            if player.hp then
                local hp = player.hp
                if (hp.hp * 2.5) < hp.max_hp then
                    ccall("await", spawnmush, 0, player)
                end
            end
        end
    end

}



