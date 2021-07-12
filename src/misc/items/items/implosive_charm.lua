
--[[

Enemies implode on death

]]

return {
    dead = function(player, ent)
        if ent.targetID == "enemy" then
            if ent.pos then
                local pos = ent.pos
                local x,y,z = pos.x, pos.y, pos.z
                ccall("moob", x, y, 30, 150)
                ccall("shockwave", x, y, 90, 3, 5, 0.3)
                ccall("sound", "moob", 0.3, 1, 0, 0.2)
            end
        end
    end
}   

