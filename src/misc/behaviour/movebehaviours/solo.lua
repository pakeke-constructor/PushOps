

--[[
MoveBehaviour :: SOLO

Runs away from a random target entity in target group


required fields:

.move = {
    id = <target id>
}

]]

local SOLO = { }

local Partitions = require("src.misc.unique.partition_targets")



function SOLO:update(e, dt)
    -- self is ent
    local move = e.behaviour.move
    
    if not move.initialized then
        self:init(e)
    end

    local target_ent = move.target_ent

    if not target_ent then
        return nil -- No target given, fine by me
    end

    local tp = target_ent.pos -- BUG:: for some reason, `tp` is a vector in this case
    self.updateGotoTarget(e, tp.x, tp.y, dt)
end



function SOLO:init(e)
    local move = e.behaviour.move
    local id = move.id
    local targ_ent = nil
    
    local tmp_stack = self.tmp_stack -- temporary stack

    for ent in Partitions[id]:foreach(e.pos.x, e.pos.y) do
        self.psh(tmp_stack, ent)
    end

    local stack_len = #tmp_stack 
    local i = self.rand(stack_len)
    if stack_len ~= 0 then
        targ_ent = tmp_stack[i]
    end
    for _ = 1, stack_len do
        self.pop(tmp_stack)
    end

    assert(#tmp_stack == 0,"BUG!")
    self.setTargEnt(e, targ_ent)
    move.initialized = true
end




function SOLO:h_update(e)
    local move = e.behaviour.move
    local id = move.id
    local targ_ent = nil

    local tmp_stack = self.tmp_stack

    for ent in Partitions[id]:foreach(e.pos.x, e.pos.y) do
        self.psh(tmp_stack, ent)
    end

    local stack_len = #tmp_stack 
    local i = self.rand(stack_len)
    if stack_len ~= 0 then
        targ_ent = tmp_stack[i]
    end
    for _ = 1, stack_len do
        self.pop(tmp_stack)
    end
    
    assert(#tmp_stack==0,"BUG")
    self.setTargEnt(e, targ_ent)
end


return setmetatable(SOLO, require(Tools.Path(...)..".base"))
