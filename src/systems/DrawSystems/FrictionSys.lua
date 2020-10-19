

local FrictionSys = Cyan.System("friction", "pos", "vel")
--[[

In charge of providing friction, (slowing velocity)
and drawing dust particles at base of object.

]]
local THRESHOLD = 20



function FrictionSys:added(ent)

    -- Add friction to body of object.
    
    ent.friction.amount = ent.friction.amount or 0.1 -- default value
    ent.friction.on = true

    if ent.physics then
        if type(ent.physics.body) == "userdata" then
            ent.physics.body:setLinearDamping(ent.friction.amount)
        end
    end
    
end


local rawget = rawget

function FrictionSys:grounded(ent)
    if rawget(ent, "friction") then
        ent.friction.on = true
    end
end


function FrictionSys:airborne(ent)
    if rawget(ent, "friction") then
        ent.friction.on = false
    end
end


function FrictionSys:update( dt )
    for _, ent in ipairs(self.group) do
        local friction = ent.friction
        local emitter = friction.emitter
        emitter:update(dt)
        emitter:setPosition(ent.pos.x + ent.vel.x/50, ent.pos.y + ent.vel.y/50)

        if ent.vel:len() > THRESHOLD and friction.on then
            emitter:start()
        else
            emitter:stop()
        end

        if not ent:has("physics") then
            ent.vel = ent.vel - (ent.vel * (ent.friction.amount * dt))
        end
    end
end



function FrictionSys:drawEntity(ent)
    if self:has(ent) then
        love.graphics.draw(ent.friction.emitter, 0, 8) -- Draw at 0, 8. (at bottom of ent)
    end
end




function FrictionSys:removed(ent)
    ent.friction.emitter:release()
end



