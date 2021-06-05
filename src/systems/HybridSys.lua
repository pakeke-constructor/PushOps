
--[[

had to do it, oh well!

Still got ~ 9 component bits left, and we are nearing polish stage
of development.


This system provides an interface to bridge the gap between OOP and ECS;
effectively, it allows entities to be hybrids between ents/standard objects.

]]

local HybridSys = Cyan.System("hybrid")

local update_group = Tools.set()
local heavyupdate_group = Tools.set()
local lose_group = Tools.set()

local cb_groups = {
    update_group,
    heavyupdate_group,
    lose_group
}


function HybridSys:added(ent)
    --[[
        callback groups are specified directly, so
        its super duper efficient.
    ]]
    if ent.onLose then
        lose_group:add(ent)
    end
    if ent.onHeavyUpdate then
        heavyupdate_group:add(ent)
    end
    if ent.onUpdate then
        update_group:add(ent)
    end
end

function HybridSys:removed(ent)
    for _,group in ipairs(cb_groups) do
        if group:has(ent) then
            group:remove(ent)
        end
    end
end





function HybridSys:update(dt)
    for _,e in ipairs(update_group.objects)do
        if e.onUpdate then
            e:onUpdate(dt)
        end
    end
end


function HybridSys:heavyupdate(dt)
    for _,e in ipairs(heavyupdate_group.objects) do
        if e.onHeavyUpdate then
            e:onHeavyUpdate(dt)
        end
    end
end

function HybridSys:lose()
    for _,e in ipairs(lose_group.objects)do
        if e.onLose then
            e.onLose()
        end
    end
end


function HybridSys:drawEntity(e)
    if e.onDraw and e.hybrid then
        e:onDraw()
    end
end

