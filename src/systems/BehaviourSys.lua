

local BehaviourSys = Cyan.System("behaviour")

--[[

Runs and update behaviour trees

]]



local cexists = Cyan.exists



local function update(e,dt )
    if cexists(e) then
        if e.behaviour.tree then
            e.behaviour.tree:update(e, dt)
        end
    end
end



function BehaviourSys:update(dt)
    for _,e in ipairs(self.group)do
        update(e,dt)
    end
end



function BehaviourSys:damage(ent, amount)
    if self:has(ent) then
        if ent.behaviour.tree then
            ent.behaviour.tree:call('damage', ent, amount)
        end
    end
end



