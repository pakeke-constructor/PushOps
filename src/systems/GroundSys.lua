
local GroundSys = Cyan.System()
--[[

do some more planning for this plz


]]



function GroundSys:startDig(ent)
    if ent.diggable then
        ent.hidden = true
    end
end



function GroundSys:endDig(ent)
    ent.hidden = false
end




