

local base = {}
local base_mt = {__index=base}

--[[

Base class for MoveBehaviours used in MoveBehaviourSys.
See MoveBehaviourSys for a better explanation.



Every method in this base class is actually a static method.
The MoveBehaviour itself is not affected.

]]


local dist = Tools.dist
base.dist = dist

-- The default distance ROOK and RAND will travel
base.DEFAULT_DIST = 400 

-- maximum velocity of moving obj
base.MAX_VEL = require("src.misc.partition").MAX_VEL

base.TargettedEntities = require("src.misc.behaviour.movebehaviours.targetted_entities")
local TargettedEntities = require("src.misc.behaviour.movebehaviours.targetted_entities")


local NAN_police = "NAN found!"

function base.updateGotoTarget(ent, pos_x, pos_y, dt)
    local sp = ent.pos

    local d = dist(pos_x - sp.x, pos_y - sp.y)

    if d < 0.1 then -- if d is low, don't bother
        return
    end

    local vx = ((pos_x - sp.x)/d) * ent.speed.speed * dt
    local vy = ((pos_y - sp.y)/d) * ent.speed.speed * dt

    assert(vx == vx, NAN_police)
    assert(vy == vy, NAN_police)

    --previously ccall("addVel") was used here. 
    Cyan.call("addVel", ent, vx, vy)
end


function base.controlledGotoTarget(ent, pos_x, pos_y, dt)
    local sp = ent.pos

    local d = dist(pos_x - sp.x, pos_y - sp.y)

    if d < 0.1 then -- if d is low, don't bother
        return
    end

    local vx = ((pos_x - sp.x)/d) * ent.speed.speed
    local vy = ((pos_y - sp.y)/d) * ent.speed.speed

    assert(vx == vx, NAN_police)
    assert(vy == vy, NAN_police)

    --previously ccall("addVel") was used here. 
    Cyan.call("setVel", ent, vx, vy)
end



function base.setTargEnt(ent, target_ent)
    -- Bit costly but oh well, no better way
    -- Calling with `nil` as the target_ent will simply remove the target ent
    -- appropriately

    -- This function is important as it ensures no memory leaks.
    local move = ent.behaviour.move

    if move.target_ent then
        local targ = move.target_ent
        if rawget(TargettedEntities, targ) then
            TargettedEntities[targ]:remove(ent)
            if TargettedEntities[targ].size == 0 then
                rawset(TargettedEntities, targ, nil)
            end
        end
    end

    move.target_ent = target_ent
    if target_ent then
        TargettedEntities[target_ent]:add(ent)
    end
end



local rand = love.math.random
base.rand = rand


base.rand_choice = Tools.rand_choice


function base.chooseRandPos(e,dist)
    local x,y = e.pos.x, e.pos.y
    local nx,ny
    repeat
        nx = x+(rand()-0.5)*dist*2
        ny = y+(rand()-0.5)*dist*2
    until (not Tools.isIntersect(x,y,nx,ny))
    return nx,ny
end




-- Temporary stack buffer for MoveBSystems to use
base.tmp_stack = {len=0}

function base.psh(stk, item) --Stack push
    stk.len = stk.len + 1
    stk[stk.len] = item
end


function base.pop(stk, item) -- Stack pop
    stk[stk.len] = nil
    stk.len = stk.len - 1
end




return base_mt



