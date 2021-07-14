


local MoveBehaviourSys = Cyan.System("behaviour", "vel", "pos", "speed")

--[[

Custom `move` params:
]]

local ent_behaviour = { 
    move = {
        type = "LOCKON",
        id = "player",
        
        radius = 40, -- for ORBIT and TAUNT
            -- how far away they will veer from their target

        wait_time = 3, -- how long the RAND and ROOK waits when switching

        distance = 200, -- how far RAND and ROOK travel (on average)


         -- Fields that are added by system ::::
        -- In the case of LOCKON, ORBIT, TAUNT, target will equal an entity
        target = nil,
        -- whether this ent is waiting to move again (used by ROOK, RAND)
        is_waiting = false,
        -- time spent waiting
        time = 5
    }
}

--[[


]]





--[[
There are a set of possible movement behaviours that can be
defined for entities.
Each type has an 

:init()   called upon initialization (or reset)
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





local DEFAULT_DIST = 400

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


-- a hasher { [ent] => set() } 
-- that lists all the entities that are targetting another entity
local TargettedEntities = require("src.misc.behaviour.movebehaviours.targetted_entities")




local NAN_police = "This is the NAN police"

local function updateGotoTarget(ent, pos_x, pos_y, dt)
    local sp = ent.pos

    local d = dist(pos_x - sp.x, pos_y - sp.y)

    if d < 0.1 then -- if d is low, don't bother
        return
    end

    local vx = ((pos_x - sp.x)/d) * ent.speed.speed * dt
    local vy = ((pos_y - sp.y)/d) * ent.speed.speed * dt

    assert(vx == vx, NAN_police)
    assert(vy == vy, NAN_police)

    Cyan.call("addVel", ent, vx, vy)
end



local MoveTypes
--[===[
    local ROOK = {}
    function ROOK:select(distance)
        -- Selects a random cardinal direction
        local mve = e.behaviour.move
        local pos = e.pos
        local r = rand()
        local target = math.vec3(0,0,0)

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
        local r = rand()
        target.x = pos.x + x * distance * r
        target.y = pos.y + x * distance * r
        return target 
    end

    function ROOK:init()
        local mve = e.behaviour.move;
        mve.time = 0
        mve.target = nil
        mve.is_waiting = false
    end

    function ROOK:update(dt)
        local move = e.behaviour.move
        if move.is_waiting then
            if move.time >= move.wait then
                move.is_waiting = false
                move.time = 0
            else
                move.time = move.time + dt
            end
        elseif rand() < 0.003 then
            -- Change dir!
            move.target = ROOK.select(e) -- remember, `self` is the entity here.
            move.is_waiting = true
            move.time = move.wait
        else
            -- Keep current dir.
            local pos = e.pos
            local dir = e.behaviour.move.dir
            local target = move.target

            updateGotoTarget(e, target.x, target.y, dt)
        end
    end

    MoveTypes = {
        ORBIT=ORBIT,
        HIVE=HIVE,
        LOCKON=LOCKON,
        IDLE=IDLE,
        ROOK=ROOK,
        RAND=RAND
    }
end
]===]

MoveTypes = {"RAND", "IDLE", "ORBIT", "HIVE", "LOCKON",
            "VECLOCKON","VECORBIT",
            "CLOCKON","CORBIT","SOLO"}

for i,v in ipairs(MoveTypes) do
    MoveTypes[v] = require("src.misc.behaviour.movebehaviours."..v:lower())
    MoveTypes[i] = nil
end



function MoveBehaviourSys:added( ent )
    if not ent.behaviour.move then 
        ent.behaviour.move = { type="IDLE" }
    elseif not ent.behaviour.move.type then
        ent.behaviour.move.type = "IDLE"
    end
end


function MoveBehaviourSys:setMoveBehaviour(ent, newState, newID)
    -- newID: optional argument. will stay same unless otherwise specified.
    if not MoveBehaviourSys:has(ent) then
        error("attempted to change move behaviour of entity not in MoveBehaviourSys")
    end

    local move = ent.behaviour.move
    local shouldInit = ((move.type ~= newState) or (newID ~= move.id))
    
    move.type = newState
    move.id = (newID or move.id)

    if shouldInit then
        local type = MoveTypes[move.type]
        assert(type, "? undefined moveBehaviour: " .. tostring(move.type))
        move.initialized = false
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



local isOnScreen = Tools.isOnScreen -- sig: ( e, cam )

local camera = require("src.misc.unique.camera")


function MoveBehaviourSys:update(dt)
    orbit_tick = orbit_tick + dt
    for _,e in ipairs(self.group) do
        if isOnScreen(e, camera) then
            local move = e.behaviour.move
            if move then
                local move_type = MoveTypes[e.behaviour.move.type]
                if move_type.update then
                    -- some moveBehaviours may not have :update
                    move_type:update(e,dt)
                end
            end
        end
    end
end







local function h_update(ent,dt)
    local move = ent.behaviour.move
    if MoveTypes[move.type].h_update then
        MoveTypes[move.type]:h_update(ent,dt)
    end
end



function MoveBehaviourSys:heavyupdate(dt)
    for _, ent in ipairs(self.group)do
        if isOnScreen(ent, camera) then
            h_update(ent,dt)
        end
    end
end




