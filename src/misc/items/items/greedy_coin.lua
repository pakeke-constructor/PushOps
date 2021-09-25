
--[[


greedy coin
    +1 token per enemy dead,
    but every time an entity dies, it shoots 2 fast bullets
        out in at a random angle


]]

local rand, sin, cos = love.math.random, math.sin, math.cos

local SPEED = 320


return {

    kill = function(player, ent)
        if ent.targetID == "enemy" then
            if ent.pos then
                EH.Ents.tok(ent.pos.x, ent.pos.y)

                local r = rand() * 6.282
                local dx, dy = sin(r), cos(r)
                ccall("shoot", ent.pos.x + 30*dx, ent.pos.y + 30*dy, 
                            dx*SPEED, SPEED*dy)
                ccall("shoot", ent.pos.x - 30*dx, ent.pos.y - 30*dy,
                            -dx*SPEED, dy*(-SPEED))
            end
        end
    end;

    description = "Extra coins and danger on kill"
}

