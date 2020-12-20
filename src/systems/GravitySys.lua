

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









function GravitySys:update(dt)
    local dt = math.min(0.1, dt)

    for _, ent in ipairs(self.group)do
        local vel = ent.vel
        local pos = ent.pos

        if ent.grounded then
            pos.z = pos.z + (vel.z * dt)
            if pos.z > 0.1 then
                ent.grounded = false
                Cyan.call("airborne", ent)
            end
        else
            vel.z = vel.z + GRAVITY*dt
            pos.z = pos.z + (vel.z * dt)
            if pos.z <= 0.1 then
                ent.grounded = true
                pos.z = 0
                vel.z = 0
                Cyan.call("grounded", ent)
            end
        end
    end
end












