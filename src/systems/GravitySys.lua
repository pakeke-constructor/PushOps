

local GravitySys = Cyan.System("pos", "vel")
--[[

"Ground level" is level 0

]]


local GRAVITY = CONSTANTS.GRAVITY


function GravitySys:added(ent)
    local pos = ent.pos

    if pos.z > 0.1 then
        ent.grounded = false
    else
        ent.grounded = true
        ent.vel.z = 0
        pos.z = 0
    end
end




local ccall = Cyan.call



local function startDig(ent)
    local d = ent.dig
    ent.hidden = true
    d.digging = true
    if d.onGround then
        d.onGround(ent)
    end
end

local function endDig(ent)
    local d = ent.dig
    d.digging = false
    ent.hidden = false
    if d.onSurface then
        d.onSurface(ent)
    end
end

local max = math.max


local function doDigStuff(ent,dt)
    local vel = ent.vel
    local pos = ent.pos
    local dig = ent.dig

    vel.z = vel.z + GRAVITY*dt*(ent.gravitymod or 1)    
    pos.z = pos.z + vel.z*dt

    if pos.z < (dig.z_min or -1) then
        pos.z = (dig.z_min or -1)
        vel.z = 0 -- hit rock bottom
    end

    if pos.z >= 0 then
        if dig.digging then
            endDig(ent)
        end
        dig.digging = false -- above ground
    else -- pos.z < 0
        if not dig.digging then
            startDig(ent)
        end
        dig.digging = true -- yeah its now digging
    end
end





function GravitySys:update(dt)
    dt = math.min(0.1, dt)

    for _, ent in ipairs(self.group)do
        local vel = ent.vel
        local pos = ent.pos

        if ent.dig then
            doDigStuff(ent,dt)
            goto continue
            -- digging entities are special little beasts
            -- exclude them from main update loop
        end

        if ent.grounded then
            -- ent is on ground, lets ensure that
            pos.z = 0.1
            pos.z = pos.z + (vel.z * dt)
            if pos.z > 0.1 then
                ent.grounded = false
                ccall("airborne", ent)
            end
        else
            -- ent is in the air
            vel.z = vel.z + GRAVITY*dt*(ent.gravitymod or 1)
            pos.z = pos.z + (vel.z * dt)
            if pos.z <= 0 then
                ent.grounded = true
                pos.z = 0.1
                ccall("grounded", ent)
            end
        end

        ::continue::
    end
end









