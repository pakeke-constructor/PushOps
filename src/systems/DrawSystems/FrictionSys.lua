

local FrictionSys = Cyan.System("friction", "pos", "vel")
--[[

In charge of providing friction, (slowing velocity)
and drawing dust particles at base of object.

]]
local THRESHOLD = 20



function FrictionSys:added(ent)

    -- Add friction to body of object.
    
    ent.friction.amount = ent.friction.amount or 5 -- default value
    ent.friction.on = true

    if ent.physics then
        if type(ent.physics.body) == "userdata" then
            ent.physics.body:setLinearDamping(ent.friction.amount)
        end
    end
end




function FrictionSys:grounded(ent)
    if ent.friction then
        ent.friction.on = true
    end
end


function FrictionSys:airborne(ent)
    if ent.friction then
        ent.friction.on = false
    end
end



function FrictionSys:update( dt )
    for _, ent in ipairs(self.group) do
        local friction = ent.friction
        local emitter = friction.emitter
        if emitter then
            emitter:update(dt)
            emitter:setPosition(ent.pos.x + ent.vel.x/50, ent.pos.y + ent.vel.y/50)

            local isStopped = emitter:isStopped()

            if (ent.vel:len() > THRESHOLD) and friction.on then
                if isStopped then
                    emitter:start()
                end
            else
                if not isStopped then
                    emitter:stop()
                end
            end

            if not ent:has("physics") then
                ent.vel = ent.vel - (ent.vel * (ent.friction.amount * dt))
            end
        end
    end
end



local lgdraw = love.graphics.draw

function FrictionSys:drawEntity(ent)
    if self:has(ent) then
        if ent.friction.emitter and ent.grounded then
            if not(ent.friction.emitter:isStopped()) then
                lgdraw(ent.friction.emitter, 0, 8) -- Draw at 0, 8. (at bottom of ent)
            end
        end
    end
end




function FrictionSys:removed(ent)
    if ent.friction.emitter then
        ent.friction.emitter:release()
    end
end



