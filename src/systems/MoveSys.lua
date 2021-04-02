

local MoveSys = Cyan.System("vel", "pos")
--[[

Handles velocities and max velocities.

]]


local partition = require("src.misc.partition")

local MAX_VEL = CONSTANTS.MAX_VEL
local PHYSICS_LINEAR_DAMPING = CONSTANTS.PHYSICS_LINEAR_DAMPING

local DAMP_AMOUNT = 1-PHYSICS_LINEAR_DAMPING

local min=math.min
local dist = Tools.dist






local vec3 = math.vec3
local dist = Tools.dist

local function updateVelo(ent, dt)
    local max_vel = MAX_VEL
    if ent.speed then
        max_vel = ent.speed.max_speed or MAX_VEL
        max_vel = min(MAX_VEL, max_vel)
    end

    if ent.physics then
        local body = ent.physics.body
        local vx, vy = body:getLinearVelocity()

        if dist(vx, vy) > max_vel then
            -- Set vector velocity to vx, vy
            local vec = vec3(vx,vy, 0):normalize() * max_vel
            
            vx, vy = vec.x, vec.y
            body:setLinearVelocity(vx, vy)
        end

        ent.vel.x = vx
        ent.vel.y = vy

        ent.pos.x = body:getX()
        ent.pos.y = body:getY()
    else
        local len = ent.vel:len()

        if ent.acc then
            ent.vel = ent.vel + ent.acc
        end

        if len > max_vel then
            ent.vel = ent.vel:normalize() * max_vel
        end

        local p = ent.pos
        p.x = p.x + ent.vel.x * dt
        p.y = p.y + ent.vel.y * dt
    end
end





function MoveSys:update(dt)
    for _, ent in ipairs(self.group) do
        updateVelo(ent,dt)
    end
end




local er_missing_pos = "cannot set position of ent that has no position"

local ccall = Cyan.call


function MoveSys:setPos(e, x, y, z)
    assert(e.pos, er_missing_pos)
    ccall("_setPos", e,x,y) -- This is BADD!! I hate this. I dont see a cleaner way tho.
                            -- order must be respected, else the partitions will goof up
    e.pos.x = x
    e.pos.y = y
    e.pos.z = z or e.pos.z
end




local st = "Target entity requires a velocity component!"

function MoveSys:addVel(ent, dx, dy)
    assert(ent.vel, st)

    if ent.physics then
        local vx, vy = ent.physics.body:getLinearVelocity( )
                -- Ratio to constrict fast moving entities fairly:::
        --[[
            0.1 :::: slow object - do not constrict (much)
            0.9 :::: fast object - probably should constrict
        ]]
                -- OLD:
                --         local ratio = min(dist(vx+dx, vy+dy) / MAX_VEL, 1)
        
        local max_vel = MAX_VEL
        if ent.speed then
            max_vel = min(ent.speed.max_speed or MAX_VEL, MAX_VEL)
        end

        local ratio = min(dist(vx, vy) / max_vel, 1)
        
        -- Cube the ratio to be more easy on slow moving objs:
        ratio = ratio * ratio * ratio

        local modifier = 1 - ratio
        
        ent.physics.body:applyLinearImpulse(dx * modifier, dy * modifier)
        ent.vel.x = vx
        ent.vel.y = vy
    else
        local vx, vy = ent.vel.x, ent.vel.y
        ent.vel.x = vx + dx
        ent.vel.y = vy + dy
    end
end


function MoveSys:setVel(ent, dx, dy)
    assert(ent.vel, st)

    if ent.physics then
        local max_vel
        if ent.speed then
            max_vel = min(ent.speed.max_speed or MAX_VEL, MAX_VEL)
        else
            max_vel = MAX_VEL
        end
        
        local dist_ = dist(dx,dy)
        if dist_ ~= 0 then
            if dist_ > max_vel then
                dx = (dx / dist_) * max_vel
                dy = (dy / dist_) * max_vel
            end

            ent.physics.body:setLinearVelocity(dx, dy)
        end
        --else
            --ent.physics.body:applyLinearImpulse(dx /3 , dy /3)
    else
        ent.vel.x = dx
        ent.vel.y = dy
    end
end





--[===[

local function updateVelo(ent,dt)

    local max_vel = MAX_VEL
    if ent.speed then
        max_vel = ent.speed.max_speed or MAX_VEL
        max_vel = min(MAX_VEL, max_vel)
    end

    if ent.acc then
        ent.vel = ent.vel + ent.acc
    end

    local len = ent.vel:len()

    if len > max_vel then
        ent.vel = ent.vel:normalize() * max_vel
    end


    if not ent.physics then
        local reduction = 0
        if len > 0 then
            -- The reduction this entity will recieve in velocity
            --reduction = min(len/max_vel, 1)
            reduction = 0.02

            -- Now, actually make it a reduction:
            reduction = 1 - reduction

            -- be harsher on slow moving entities
            reduction = reduction
        end

        ent.pos = ent.pos + ent.vel
        
        ent.vel = ent.vel * reduction

    else
        local v = ent.vel

        local body = ent.physics.body
        body:setLinearVelocity(v.x, v.y)

        ent.vel = ent.vel

        ent.pos.x = body:getX()
        ent.pos.y = body:getY()
    end
end


]===]