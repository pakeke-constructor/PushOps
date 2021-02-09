


local ORBIT = {
--[[
MoveBehaviour :: ORBIT

required fields:

.move = {
    orbit_tick = 0;
    orbit_speed = 0.2;   -- how many orbits is done per second
}


]]
}


local Partitions = require("src.misc.unique.partition_targets")
local sin, cos = math.sin, math.cos


function ORBIT:update(e, dt)
    --[[
        This function is bad as well. Is costly.
            I dont think there is way around tho
    ]]
    local move = e.behaviour.move

    move.orbit_tick = (move.orbit_tick + move.orbit_speed * dt) % (math.pi*2)
    local target = move.target

    if not target then
        return nil -- No target given, fine by me
    end

    local tp = target.pos
    self.updateGotoTarget(e, tp.x + 60*sin(move.orbit_tick), tp.y + 60*cos(move.orbit_tick),dt)
end



function ORBIT:init(e)
    -- field assertion
    local move = e.behaviour.move
    assert(move.orbit_tick)
    assert(move.orbit_speed)

    -- now, proper func
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
    for ii = 1, stack_len do
        self.pop(tmp_stack)
    end

    assert(#tmp_stack == 0, "caught bug!")
    self.setTargEnt(e, targ_ent)
end



function ORBIT:h_update(e)
    local move = e.behaviour.move
    local id = move.id
    local targ_ent = nil
    local tmp_stack = self.tmp_stack

    for ent in Partitions[id]:foreach(e.pos.x, e.pos.y) do
        self.psh(tmp_stack, ent)
    end

    local stack_len = #tmp_stack 
    local i =  self.rand(stack_len)
    if stack_len ~= 0 then
        targ_ent = tmp_stack[i]
    end
    for ii = 1, stack_len do
        self.pop(tmp_stack)
    end

    assert(#tmp_stack == 0, "bug!")
    self.setTargEnt(e, targ_ent)
end



return setmetatable(ORBIT, require(Tools.Path(...)..".base"))

