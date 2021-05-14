
--[[

had to do it, oh well!

Still got ~ 9 component bits left, and we are nearing polish stage
of development.


This system provides an interface to bridge the gap between OOP and ECS;
effectively, it allows entities to be hybrids between ents/standard objects.

]]

local HybridSys = Cyan.System("hybrid")


function HybridSys:added(ent)
    if ent.onLose then
        -- Add this entity to the onLose callback group
    end
    if ent.onRatioWin then
        -- Add this entity to the onRatioWin callback group
    end
end


function HybridSys:update(dt)
    for _,e in ipairs(self.group)do
        if e.onUpdate then
            e:onUpdate(dt)
        end
    end
end


function HybridSys:heavyupdate(dt)
    for _,e in ipairs(self.group) do
        if e.onHeavyUpdate then
            e:onHeavyUpdate(dt)
        end
    end
end


function HybridSys:drawEntity(e)
    if e.onDraw and e.hybrid then
        e:onDraw()
    end
end

