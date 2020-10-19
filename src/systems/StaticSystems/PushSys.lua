


local PushSys = Cyan.System()
--[[

A system that handles the pushing of entities.


]]

local partition = require("src.misc.partition")
local tools = require"libs.tools.tools"



local dist = tools.dist

local MAX_VEL = partition.MAX_VEL



local C_call = Cyan.call

local dot = math.dot



local function findPushedEnt(ent, range)
    --[[
        returns the closest ent that is able to be pushed by `ent`.
    ]]
    local min_dist = range
    local best_ent = nil
    local epos = ent.pos
    local vx, vy = ent.vel.x, ent.vel.y

    for push_ent in partition:longiter(ent) do
        local ppos = push_ent.pos
        local dx, dy

        dx = ppos.x - epos.x
        dy = ppos.y - epos.y
        
        if dist(dx, dy) < min_dist then
            -- Is a valid candidate ::
            if dot(dx, dy, vx,vy) > 0 then
                best_ent = push_ent
            end
        end
    end

    return best_ent
end





--[[
    An array of ents -> pushed ents
]]
local currently_pushing = {}
local currently_pushing_keys = Tools.set()


function PushSys:startPush(ent, range)
    --[[
        Starts Pushing the closest entity to the pushing entity.
    ]]

    range = range or 50 -- default range

    local pushed_ent = findPushedEnt(ent, range)


    if not pushed_ent then
        return -- nah! no good ones
    end


    assert(ent.vel, "Unmoving ent attempted to push moving ent")
    assert(pushed_ent.vel, "Unmoving ent attempted to be pushed")

    currently_pushing_keys:add(ent)
    currently_pushing[ent] = pushed_ent

    C_call("setVel", pushed_ent, ent.vel.x, ent.vel.y)
end



function PushSys:endPush(ent)
    currently_pushing_keys:remove(ent)
    currently_pushing[ent] = nil
end



function PushSys:update(dt)
    
    for _, e in ipairs(currently_pushing_keys.objects) do
        local push_ent = currently_pushing[e]
        
        local epos = e.pos
        local ppos = push_ent.pos
        local dx, dy
        dx = ppos.x - epos.x
        dy = ppos.y - epos.y

        local vx,vy
        vx = e.vel.x
        vy = e.vel.y

        if (dist(dx, dy) > 50) or (dot(dx, dy, vx,vy) < 0) then
            -- is invalid so end
            C_call("endPush", e)
        else
            C_call("setVel", push_ent, e.vel.x, e.vel.y)
        end
    end

end




local AVERAGE_DT = CONSTANTS.AVERAGE_DT



function PushSys:boom(x, y, strength, distance, 
                        vx, vy) -- optional arguments.
    --[[
        Pushes all entities from a point away.
    ]]
    local this_strength

    for ent in partition:foreach(x, y) do
        local eX, eY = ent.pos.x, ent.pos.y

        if not (eX == x and eY == y) then
            -- If x and y position of ent is same as boom position:
                -- Dont apply the force. This entity is (probably)
                -- the entity that enacted the force.
            local e_dis = dist(x-eX, y-eY)

            local should_be_pushed = true

            if vx then -- Do not push entities that the pushing entity is moving away from.
                if tools.dot(eX-x, eY-y, vx, vy) < 0 then
                    should_be_pushed = false
                end
            end
            -- Will only push entities a certain distance away
            if not(e_dis < distance) then
                should_be_pushed = false
            end

            if should_be_pushed then
                this_strength = (strength*AVERAGE_DT*100) / e_dis;
                C_call("addVel", ent, (eX-x)*this_strength, (eY-y)*this_strength)
                -- Push the entities away according to `strength` and distance.
            end
        end
    end
end




local rand = love.math.random


function PushSys:moob(x, y, strength, distance)
    --[[
        reverse of boom
        Pulls all entities from a point towards itself
    ]]
    local this_strength

    for ent in partition:foreach(x, y) do
        local eX, eY = ent.pos.x, ent.pos.y

        if not (eX == x and eY == y) then
            -- If x and y position of ent is same as boom position:
                -- Dont apply the force. This entity is (probably)
                -- the entity that enacted the force.
            local e_dis = dist(x-eX, y-eY)

            -- Will only push entities a certain distance away
            
            if e_dis < distance then
                this_strength = (AVERAGE_DT*strength*100) / e_dis;
                Cyan.call("addVel", ent,
                ((x-eX)*this_strength),
                (y-eY)*this_strength)
                -- Push the entities away according to `strength` and distance.

                -- Add Z velocity to bounce em up.
                ent.vel.z = rand(100,300)
            end
        end
    end
end



