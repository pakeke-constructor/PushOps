



local CORBIT = {
    --[[
    MoveBehaviour :: CORBIT (concentrated orbit)
    
    required fields:
    
    .move = {
        id = <target id>
        orbit_tick = 0;
        orbit_speed = 0.2;   -- how many orbits is done per second
        orbit_radius = 60; -- the radius of which the ent will orbit around
    }
    
    
    ]]
    }
    
    
    
    
    local Partitions = require("src.misc.unique.partition_targets")
    local sin, cos = math.sin, math.cos
    local DEFAULT_RADIUS = 60
    
    function CORBIT:update(e, dt)
        --[[
            This function is bad as well. Is costly.
                I dont think there is way around tho
        ]]
        local move = e.behaviour.move
    
        if not move.initialized then
            self:init(e)
        end
    
        move.orbit_tick = (move.orbit_tick + move.orbit_speed * dt) % (math.pi*2)
        local target_ent = move.target_ent
    
        if not target_ent then
            return nil -- No target given, fine by me
        end
    
        local rad = move.orbit_radius or DEFAULT_RADIUS
        local tp = target_ent.pos
        self.controlledGotoTarget(e, tp.x + rad*sin(move.orbit_tick),
                                tp.y + rad*cos(move.orbit_tick),dt)
    end
    
    
    
    function CORBIT:init(e)
        -- field assertion
        local move = e.behaviour.move
        assert(move.orbit_tick)
        assert(move.orbit_speed)
    
        -- now, proper func
        local id = move.id
        local targ_ent = nil
        local tmp_stack = self.tmp_stack
    
        assert(e.pos)
        assert(id)
        local partition = Partitions[id]
        assert(partition,id)
        for ent in partition:foreach(e.pos.x, e.pos.y) do
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
    
        move.initialized = true
    end
    
    
    
    function CORBIT:h_update(e)
        local move = e.behaviour.move
        local id = move.id
        local targ_ent = nil
        local tmp_stack = self.tmp_stack
        assert(#tmp_stack == 0, "bug!")
        assert(id,"ent had no id")
    
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
    
    
    
    return setmetatable(CORBIT, require(Tools.Path(...)..".base"))
    
    