

local LOCKON = { }

local Partitions = require("src.misc.unique.partition_targets")



function LOCKON:update(e, dt)
    -- self is ent
    local move = e.behaviour.move
    local target = move.target

    if not target then
        return nil -- No target given, fine by me
    end

    local tp = target.pos -- BUG:: for some reason, `tp` is a vector in this case

    self.updateGotoTarget(e, tp.x, tp.y, dt)
end



function LOCKON:init(e)
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
end




function LOCKON:h_update(e)
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


return setmetatable(LOCKON, require(Tools.Path(...)..".base"))
