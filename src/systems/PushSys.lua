


local PushSys = Cyan.System("pushing")
--[[

A system that handles the pushing of entities.
    (Note: This system holds entities that are *doing* the pushing.)

(Also, this system has static callbacks)

]]

local partition = require "src.misc.partition"



local dist = Tools.dist
local MAX_VEL = partition.MAX_VEL


local ccall = Cyan.call
local dot = math.dot






local er1 = "Attempted to push an unpushable entity. Silly idea brother"


function PushSys:added(ent)
    --[[
        Starts Pushing the closest entity to the pushing entity.
    ]]
    if not ent.pushing.pushable then
        error(er1)
    end

    assert(ent.vel, "Unmoving ent attempted to push moving ent")

    -- FUTURE OLI HERE: THANKKKK YOU FOR DOING THIS ASSERTION. DO MORE OF THESE
    assert(ent.pushing.vel, "Unmoving ent attempted to be pushed")

    ccall("startPush", ent, ent.pushing)
end



function PushSys:removed(ent)
end



function PushSys:update(dt)
    for _, e in ipairs(self.group) do
        local push_ent = e.pushing
        if Cyan.exists(push_ent) then
            local range
            if e.size then
                range = e.size*5
            else
                range = 25 -- default range
            end

            local epos = e.pos
            local ppos = push_ent.pos
            local dx, dy
            dx = ppos.x - epos.x
            dy = ppos.y - epos.y

            local vx,vy
            vx = e.vel.x
            vy = e.vel.y

            local norm_offset = math.vec3(vx,vy,0):normalize()

            local ox = range * norm_offset.x
            local oy = range * norm_offset.y

            ccall("setVel", push_ent, vx, vy)
            ccall("setPos", push_ent, epos.x + ox, epos.y + oy)
        else
            -- The ent being pushed has been deleted mid-push! AH!!
            -- quick, lets kill it before any shenanigans come about.
            e:remove("pushing")
        end
    end
end



--[[
====
====

All events after this point are static

====
====
]]


local AVERAGE_DT = CONSTANTS.AVERAGE_DT
local partition_targets = require("src.misc.unique.partition_targets")

local function getNormalizedBias(bX, bY, eX, eY, bias_group, bias_angle)
    --[[
        With :boom callbacks, entities can be biased to hit other ents
        of other target groups.
        This function gives a normalized corrected vector in the event
        that a :boom callback has a bias. (according to bias_group and 
        bias_angle)
    ]]
    local dot_value = math.cos(bias_angle or 0.5)
    local potentials = { } -- a list of potential entities this
                           -- obj could bias towards.
                           -- (It will bias towards the closest though.)
    local boom_to_obj = math.vec3(eX - bX, eY - bY, 0):normalize( )

    for e in partition_targets[bias_group]:iter(eX, eY) do
        local x,y = e.pos.x, e.pos.y
        if x ~= eX and y ~= eY then
            -- checking that we aren't comparing an ent to itself!!
            local obj_to_target = math.vec3(x - eX, y - eY, 0):normalize( )
            if obj_to_target:dot(boom_to_obj) > dot_value then
                table.insert(potentials, e)
            end
        end
    end
    -- Now select closest entity from all candidates
    local min_dist = math.huge
    local closest_ent
    for _, e in ipairs(potentials)do
        local distance = Tools.dist(e.pos.x - eX, e.pos.y - eY)
        if distance < min_dist then
            closest_ent = e
            min_dist = distance
        end
    end

    local ret
    if not closest_ent then
        -- darn, no ent found.
        ret = math.vec3(eX-bX, eY-bY, 0):normalize( )
    else
        local closest_pos = closest_ent.pos
        ret = math.vec3(closest_pos.x - eX, closest_pos.y - eY, 0):normalize( )
    end
    return ret
end


local max = math.max
local rand = love.math.random

function PushSys:boom(x, y, strength, distance, 
                        vx, vy, bias_group, bias_angle) -- optional arguments.
    --[[
        Pushes all entities from a point away.

        bias_group :: entities hit will bias 30 degrees towards ents
            in this bias group.
        bias_angle :: the maximum angle that the ents will bias towards.
    ]]
    local this_strength
    for ent in partition:longiter(x, y) do
 
        if ent.onBoom then
            ent:onBoom(x,y,strength)
        end

        local eX, eY = ent.pos.x, ent.pos.y
                                         -- ugh! I hate this.
        if ent.vel and ent.pushable and (not (eX == x and eY == y)) then
            -- If x and y position of ent is same as boom position:
                -- Dont apply the force. This entity is (probably)
                -- the entity that enacted the force.
            local e_dis = dist(x-eX, y-eY)

            e_dis = max(e_dis, 1) -- minimum of 1 distance (no Nans)
            this_strength = (strength*AVERAGE_DT*100) / e_dis;

            -- will only push entities a certain distance away
            if (e_dis < distance) then
                local X = eX-x
                local Y = eY-y
                if bias_group then
                    -- bias_vector will point towards the corrected position
                    -- (i.e. will target the targetgroup properly)
                    local bias_vector = getNormalizedBias(
                        x, y,
                        eX, eY,
                        bias_group, bias_angle
                    )
                    X = bias_vector.x * e_dis -- bias_vector is normalized, remember.
                    Y = bias_vector.y * e_dis
                end

                ccall("addVel", ent, X * this_strength + (vx or 0),
                                     Y * this_strength + (vy or 0))

                ccall("animate", "shock", 0, 0, 50, 0.02, nil, nil, ent)
                -- Push the entities away according to `strength` and distance.
                
                -- Add Z velocity to bounce em up.
                ent.vel.z = rand(100,200)
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
    

    for ent in partition:longiter(x, y) do
        local eX, eY = ent.pos.x, ent.pos.y

        if ent.onMoob then
            ent:onMoob(x,y,strength)
        end

        if ent.vel and ent.pushable and (eX ~= x and eY ~= y) then
            -- If x and y position of ent is same as boom position:
                -- Dont apply the force. This entity is (probably)
                -- the entity that enacted the force.
            local e_dis = dist(x-eX, y-eY)

            this_strength = (AVERAGE_DT*strength*90) / e_dis;

            -- Will only push entities a certain distance away
            
            if e_dis < distance then
                Cyan.call("addVel", ent,
                ((x-eX)*this_strength),
                (y-eY)*this_strength)
                -- Push the entities away according to `strength` and distance.

                -- Add Z velocity to bounce em up.
                ent.vel.z = rand(150,350)
            end
        end
    end
end








