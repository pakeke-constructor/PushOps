
--[[

Multiblock will duplicate itself into 3
regular blocks if it hits an enemy


]]
local atlas = require "assets.atlas"
local Quads = atlas.Quads


local COL = CONSTANTS.MULTI_COLOUR
local COL2 = CONSTANTS.MULTI_COLOUR_FADED


local function spawn(x, y)
    for i=-1, 1 do
        local bl = EH.Ents.block(x - i * 20, y + i * 20)
        bl.colour = COL2
    end
end


local ccall = Cyan.call
local rand = love.math.random
local cam = require("src.misc.unique.camera")
local collisions = {
    physics = function(self, col, speed)
        if speed > CONSTANTS.ENT_DMG_SPEED and col.targetID=="enemy" then
            local x, y, z = self.pos.x, self.pos.y, self.pos.z
            ccall("shockwave", x, y, 14, 100, 10, 0.4, table.copy(COL))
            ccall("sound", "poof")
            ccall("sound", "pop")
            ccall("await", spawn, 0, self.pos.x, self.pos.y)
            ccall("kill", self)
        end
    end
}



local function onDeath(e)
    ccall("emit", "mushroom", e.pos.x, e.pos.y, e.pos.z, 3)
end


return function(x,y)
    if (not x) or (not y) then error("hey! stop it") end
    local multi = EH.Ents.block(x,y)
    
    multi.colour = table.copy(COL)
    multi.collisions = collisions
    return multi
end




