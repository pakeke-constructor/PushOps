
--[[

Enemies explode on death

]]

return {
    kill = function(player, ent)
        if ent.targetID == "enemy" then
            if ent.pos then
                local pos = ent.pos
                local x,y,z = pos.x, pos.y, pos.z
                ccall("boom", x, y, 60, 100, 0,0)
                ccall("animate", "push", x,y+25,z, 0.03) 
                ccall("shockwave", x, y, 20, 90, 4, 0.25)
                ccall("sound", "boom", .5)
            end
        end
    end
}   

