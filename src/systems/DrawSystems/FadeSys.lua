

--[[

ents will fade from view the further they get
from the camera position

IMPORTANT:
Colour tables assigned to entities must be memory unique, else the alpha channel
of one entity will affect all others that share the ref of the table

]]
local FadeSys = Cyan.System("fade")



local cam = require("src.misc.unique.camera")


function FadeSys:added(ent)
    if not ent.colour then
        ent.colour = {1,1,1,1} -- They may be given a colour in future,
            -- but who cares. GC already hates me ahhaha
    end
end


local max = math.max
local min = math.min


function FadeSys:update(dt)
    for _, ent in ipairs(self.group)do -- fades the further away from player
        local minfade = ent.minfade or 0
        local dist = Tools.distToPlayer(ent,cam)
        ent.colour[4] = min(max((ent.fade / dist)-1, minfade), 1)
    end
end






