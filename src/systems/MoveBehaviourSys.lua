

local MoveBehaviourSys = Cyan.System("behaviour", "vel", "pos", "speed")


--[[
There are a set of possible movement behaviours that can be
defined for entities.
Each type has an 

:init()
    Should always select a valid target, or set to nil.

:update()
:s_update()    (sparse update)
:h_update()    (heavy update)



All the move types are listed here ::

HALT -->
    Stays still

LOCKON -->  DONE
    Chooses closest target ent from group ::
        target = entity
    Moves directly towards closest target entity
    in the group specified

ORBIT -->   DONE
    Chooses closest target ent from group ::
        target = entity
    Moves towards target entity + 20*sin(tick)x + 20*cos(tick)y
    in the group specified. (orbits around ent)

HIVE -->   DONE
    Moves towards center of mass of target group
        target = vec3

SOLO -->
    Moves away from ent in target group
        target = vec3

RAND -->
    Chooses a random walkable location and goes towards it
        target = vec3

ROOK -->
    Moves in a (chess) rook-like pattern randomly
        target = vec3

TAUNT -->
    Chooses a target entity from group ::
        target = entity
    Moves towards the target entity, but keeps distance from ent



]]



-- Planning ::::

-- Behaviour (complex component)
local _ = { -- (planning)
    move = {
        type = "LOCKON",
        id = 1, -- targets group 1 ents



        -- Fields that are added by system ::::

        -- In the case of LOCKON, target will equal an entity
        target = nil
    }
}
_ = nil





local MAX_VEL = require("src.misc.partition").MAX_VEL



local rawget = _G.rawget
local dist = Tools.dist
local Cyan = Cyan
local orbit_tick = 0 -- For ORBIT movement behaviour
local sin = math.sin
local cos = math.cos
local set = Tools.set


-- Array of spacial partitions for each target group
local Partitions = require("src.misc.unique.partition_targets") 


local Targetted = setmetatable({ },
--[[
    2d array of sets, keyed with entities that have been targetted.
    On entity deletion, all entities in the targetted set must be removed
]]
{__index = function(t,k)
    t[k] = set() return t[k]
end})




local function update_goto_target(ent, pos_x, pos_y)
    local sp = ent.pos

    local d = dist(pos_x - sp.x, pos_y - sp.y)

    local vx = ((pos_x - sp.x)/d)*ent.speed.speed
    local vy = ((pos_y - sp.y)/d)*ent.speed.speed

    Cyan.call("addVel", ent, vx, vy)
end



local MoveTypes


do
    local rand = love.math.random

    local function psh(stk, item) --Stack push
        stk.len = stk.len + 1
        stk[stk.len] = item
    end
    local function pop(stk, item) -- Stack pop
        stk[stk.len] = nil
        stk.len = stk.len - 1
    end

    local tmp_stack = {len=0}

    local function set_targ_ent(ent, target_ent)
        -- Bit costly but oh well, no better way
        -- Calling with `nil` as the target_ent will simply remove the target ent
        -- appropriately

        -- This function is important as it ensures no memory leaks.
    
        local move = ent.behaviour.move

        if move.target then
            local targ = move.target
            if rawget(Targetted, targ) then
                Targetted[targ]:remove(ent)
                if Targetted[targ].size == 0 then
                    rawset(Targetted, targ, nil)
                end
            end
        end

        if target_ent then
            Targetted[target_ent]:add(ent)
            move.target = target_ent
        end
    end

    local rand_choice = Tools.rand_choice

    local LOCKON = {}

    function LOCKON:update()
        -- self is ent

        --[[
            This function is bad as well. Is costly.
                I dont think there is way around tho
        ]]
        local move = self.behaviour.move
        local target = move.target

        if not target then
            return nil -- No target given, fine by me
        end

        local tp = target.pos

        update_goto_target(self, tp.x, tp.y)
    end
    function LOCKON:init()
        local move = self.behaviour.move

        local id = move.id

        local targ_ent = nil

        for ent in Partitions[id]:foreach(self.pos.x, self.pos.y) do
            psh(tmp_stack, ent)
        end
        local stack_len = #tmp_stack 
        local i = rand(stack_len)
        if stack_len ~= 0 then
            targ_ent = tmp_stack[i]
        end
        for _ = 1, stack_len do
            pop(tmp_stack)
        end

        set_targ_ent(self, targ_ent)
    end



    local ORBIT = {}

    function ORBIT:update()
        -- self is ent

        --[[
            This function is bad as well. Is costly.
                I dont think there is way around tho
        ]]
        local move = self.behaviour.move
        local target = move.target

        if not target then
            return nil -- No target given, fine by me
        end

        local tp = target.pos

        update_goto_target(self, tp.x + 60*sin(orbit_tick), tp.y + 60*cos(orbit_tick))
    end
    function ORBIT:init()
        local move = self.behaviour.move

        local id = move.id

        local targ_ent = nil

        for ent in Partitions[id]:foreach(self.pos.x, self.pos.y) do
            psh(tmp_stack, ent)
        end

        local stack_len = #tmp_stack 
        local i = rand(stack_len)
        if stack_len ~= 0 then
            targ_ent = tmp_stack[i]
        end
        for ii = 1, stack_len do
            pop(tmp_stack)
        end

        set_targ_ent(self, targ_ent)
    end

    local HIVE={}

    function HIVE:init()
        local move = self.behaviour.move

        local sum_x = 0
        local sum_y = 0
        local tot = 0

        for ent in Partitions[move.id]:foreach(self.pos.x, self.pos.y) do
            sum_x = sum_x + ent.pos.x
            sum_y = sum_y + ent.pos.y
            tot = tot + 1
        end

        if tot ~= 0 then
            move.target = math.vec3(sum_x/tot, sum_y/tot, 0)
        else
            move.target = math.vec3()
        end
    end
    function HIVE:update()
        local target = self.behaviour.move.target
        update_goto_target(self, target.x, target.y)
    end
    function HIVE:h_update()
        local move = self.behaviour.move

        local sum_x = 0
        local sum_y = 0
        local tot = 0

        for ent in Partitions[move.id]:foreach(self.pos.x, self.pos.y) do
            sum_x = sum_x + ent.pos.x
            sum_y = sum_y + ent.pos.y
            tot = tot + 1
        end

        if tot ~= 0 then
            move.target = math.vec3(sum_x/tot, sum_y/tot, 0)
        else
            move.target = math.vec3()
        end
    end


    local IDLE = {}
    function IDLE:init()
    end
    function IDLE:update(dt)
    end


    MoveTypes = {
        ORBIT=ORBIT,
        HIVE=HIVE,
        LOCKON=LOCKON,
        IDLE=IDLE
    }
end




function MoveBehaviourSys:added( ent )
    if not ent.behaviour.move then -- hopefully -deadbeef will never be a target group
        ent.behaviour.move = { type="IDLE", id=-0xDEADBEEF }
    elseif not ent.behaviour.move.type then
        ent.behaviour.move.type = "IDLE"
        ent.behaviour.move.id = -0xDEADBEEF
    end
    MoveTypes[ent.behaviour.move.type].init(ent)
end





function MoveBehaviourSys:update(dt)
    orbit_tick = orbit_tick + dt
    for _,e in ipairs(self.group) do
        MoveTypes[e.behaviour.move.type].update(e)
    end
end





local function h_update(ent,dt)
    local move = ent.behaviour.move
    if MoveTypes[move.type].h_update then
        MoveTypes[move.type].h_update(ent)
    end
end


function MoveBehaviourSys:heavyupdate(dt)
    for _, ent in ipairs(self.group )do
        h_update(ent,dt)
    end
end































local TargetSys = Cyan.System("targetID", "pos")

local set = Tools.set
local TargetGroups = setmetatable({ },
--[[
    2d array of sets representing all the entities in each group.    
]]
{__index = function(t,k)
    t[k] = set() return t[k]
end})




local er1 = "Target component was not a number"
function TargetSys:added(ent)
    assert(type(ent.targetID) == "number", er1)

    Partitions[ent.targetID]:add(ent) -- Adds to the correct spacial partition

    TargetGroups[ent.targetID]:add(ent)

end



function TargetSys:update(dt)
    for _, partition in ipairs(Partitions) do
        partition:update(dt)
    end
end





function TargetSys:removed(ent)
    TargetGroups[ent.targetID]:remove(ent)

    if rawget(Targetted, ent) then
        -- This means we still got entities targetting this ent,
        -- So we must re-initialize all the entities that were targetting
        -- this ent.
        for _,ent in ipairs(Targetted[ent].objects) do
            local move = ent.behaviour.move
            MoveTypes[move.type].init(ent)
        end
    end

    Partitions[ent.targetID]:remove(ent)

end







