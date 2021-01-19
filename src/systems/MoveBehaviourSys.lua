


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

IDLE -->  DONE
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

ROOK -->   DONE
    Moves in a (chess) rook-like pattern randomly
        target = vec3

TAUNT -->
    Chooses a target entity from group ::
        target = entity
    Moves towards the target entity, but keeps distance from ent


]]



-- Planning ::::

-- Behaviour (complex component)
local ent_behaviour = { -- (planning)
    move = {
        type = "LOCKON",
        id = 1, -- targets group 1 ents



        -- Fields that are added by system ::::

        -- In the case of LOCKON, target will equal an entity
        target = nil
    }
}
ent_behaviour = nil





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





local NAN_police = "This is the NAN police"

local function update_goto_target(ent, pos_x, pos_y)
    local sp = ent.pos

    local d = dist(pos_x - sp.x, pos_y - sp.y)

    if d < 0.1 then -- if d is low, don't bother
        return
    end

    local vx = ((pos_x - sp.x)/d)*ent.speed.speed
    local vy = ((pos_y - sp.y)/d)*ent.speed.speed

    assert(vx == vx, NAN_police)
    assert(vy == vy, NAN_police)

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
    function LOCKON:h_update()
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
    function ORBIT:h_update()
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
            move.target = nil
        end
    end
    function HIVE:update()
        local target = self.behaviour.move.target
        if target then
            update_goto_target(self, target.x, target.y)
        else
            -- If no goto target, stay still. (Behaviour tree should sort this shit out :/ )
            update_goto_target(self, self.pos.x, self.pos.y)
        end
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

        if tot > 0 then
            move.target = math.vec3(sum_x/tot, sum_y/tot, 0)
        else
            move.target = nil 
        end
    end

    local RAND={}
    local function chooseRandPos(e)
        local x,y = e.pos.x, e.pos.y
        local nx,ny
        repeat 
            nx = x+rand()*200
            ny = y+rand()*200            
        until (not Tools.isIntersect(x,y,nx,ny))
        return nx,ny
    end
    function RAND:init()
        local move=self.behaviour.move
        local x,y = chooseRandPos(e)
        move.target = math.vec3(x,y,0)
    end
    function RAND:update()
    end


    local IDLE = {}
    function IDLE:init()
    end
    function IDLE:update(dt)
    end

    local ROOK = {}
    function ROOK:select()
        -- Selects a random cardinal direction
        local mve = self.behaviour.move
        local r = rand()

        local x,y = 0,0
        if r<0.5 then
            x = 0; y = 1;
        else
            y = 0; x=1
        end

        if rand() < 0.5 then
            y = y * -1
            x = x * -1 
        end

        mve.dir.x = x
        mve.dir.y = y
    end

    function ROOK:init()
        local mve = self.behaviour.move;
        
        mve.target = nil
        mve.dir = math.vec3(0,0,0)
    end

    function ROOK:update(dt)
        if rand() < 0.003 then
            -- Change dir!
            ROOK.select(self) -- remember, `self` is the entity here.
        else
            -- Keep current dir.
            local pos = self.pos
            local dir = self.behaviour.move.dir

            update_goto_target(self, pos.x + dir.x*100, pos.y + dir.y*100)
        end
    end

    MoveTypes = {
        ORBIT=ORBIT,
        HIVE=HIVE,
        LOCKON=LOCKON,
        IDLE=IDLE,
        ROOK=ROOK
    }
end



function MoveBehaviourSys:added( ent )
    if not ent.behaviour.move then -- hopefully -0xdead will never be a target group
        ent.behaviour.move = { type="IDLE", id=-0xDEAD }
    elseif not ent.behaviour.move.type then
        ent.behaviour.move.type = "IDLE"
        ent.behaviour.move.id = -0xDEAD
    end
    MoveTypes[ent.behaviour.move.type].init(ent)
end


function MoveBehaviourSys:setMoveBehaviour(ent, newState, newID)
    -- newID: optional argument. will stay same unless otherwise specified.
    if not ent.behaviour then
        error("attempted to change move behaviour of entity without `behaviour` component")
    end
    assert(ent.behaviour.move, "?")

    local move = ent.behaviour.move
    local shouldInit
    if move.type ~= newState then
        shouldInit = true
    end
    move.type = newState
    move.id = (newID or move.id)

    if shouldInit then
        MoveTypes[move.type].init(ent)
    end
end



--[[

-- DEBUG ONLY!!!!

function MoveBehaviourSys:drawEntity(e)
    if self:has(e) then
        love.graphics.print(e.behaviour.move.type, e.pos.x, e.pos.y)
    end
end
]]


function MoveBehaviourSys:update(dt)
    orbit_tick = orbit_tick + dt
    for _,e in ipairs(self.group) do
        local move = e.behaviour.move
        if move then
            local func = MoveTypes[e.behaviour.move.type].update
            if func then
                func(e,dt)
            end
        end
    end
end







local function h_update(ent,dt)
    local move = ent.behaviour.move
    if MoveTypes[move.type].h_update then
        MoveTypes[move.type].h_update(ent,dt)
    end
end


function MoveBehaviourSys:heavyupdate(dt)
    for _, ent in ipairs(self.group)do
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



local valid_targetIDs = {
    player=true,
    enemy=true,
    physics=true,
}

local er1 = "Target component is not valid"
function TargetSys:added(ent)
    assert(valid_targetIDs[ent.targetID], er1)

    Partitions[ent.targetID]:add(ent) -- Adds to the correct spacial partition
    TargetGroups[ent.targetID]:add(ent)
end



local partition_keys = {}
for t_id, _ in pairs(Partitions) do
    table.insert(partition_keys, t_id)
end


function TargetSys:update(dt)
    local partition
    for _, p_key in ipairs(partition_keys) do
        partition = Partitions[p_key]
        partition:update(dt)
    end
end


function TargetSys:_setPos(ent,x,y)
    --[[
        Why the underscore?  See MoveSys:setPos(e, x, y).
            (This is a private callback)

        reasoning:
        direct ent position must be set AFTER all the setPosition calls go through,
        for every partition, or else the ent position will be too volatile PartitionSys
        to find.
    ]]
    if ent.targetID then
        Partitions[ent.targetID]:setPosition(ent,x,y)
    end
end


function TargetSys:removed(ent)
    TargetGroups[ent.targetID]:remove(ent)

    Partitions[ent.targetID]:remove(ent)

    if rawget(Targetted, ent) then
        -- This means we still got entities targetting this ent,
        -- So we must re-initialize all the entities that were targetting
        -- this ent.
        for _, e in ipairs(Targetted[ent].objects) do
            local move = e.behaviour.move
            MoveTypes[move.type].init(e)
        end
    end
end







