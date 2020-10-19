
--[[
ControlSys:

Handles camera motion and player motion.

TODO: add joystick support, make more robust


]]
local ControlSys = Cyan.System("control")

local Camera = require("src.misc.unique.Camera")


local ROT_AMPLITUDE = 0.05
local ROT_FREQ = 0.07

local cur_sin_amount = 0
local cam_rot = 0


    -- THIS FUNCTION IS FOR DEBUG PURPOSES ONLY !!!!!!!!!!!
function ControlSys:wheelmoved(dx, dy)
    Camera.scale = Camera.scale + (dy/10)
end



function ControlSys:update(dt)

    cur_sin_amount = cur_sin_amount + (dt * ROT_FREQ)
    cam_rot = ROT_AMPLITUDE*math.sin(cur_sin_amount)

    Camera.rotation=(cam_rot)

    Camera:update(dt)

    for _,ent in ipairs(self.group) do
        local c = ent.control
        local speed = ent.speed.speed or 4

        local dx = 0
        local dy = 0

        if c.up then
            dy = -speed
        end
        if c.down then
            dy = dy + speed
        end
        if c.left then
            dx = -speed
        end
        if c.right then
            dx = speed
        end
        Cyan.call("addVel", ent, dx, dy)
    end
end



function ControlSys:keytap(key)
    for _, ent in ipairs(self.group) do
    
        local c = ent.control
        if c[key] == 'push' then
            Cyan.call("boom", ent.pos.x, ent.pos.y, ent.strength, 50)
            Camera:shake(8, 1, 60)
        elseif c[key] == 'pull' then
            Cyan.call("moob", ent.pos.x, ent.pos.y, ent.strength/3, 140)
        end

    end
end



function ControlSys:keydown(key)
    for _, ent in ipairs(self.group) do
        local control = ent.control

        local purpose = control[key]

        if purpose then
            control[purpose] = true
            if purpose == "push" then
                Cyan.call("startPush", ent)
            end
        end
    end
end





function ControlSys:keyup(key)
    for _, ent in ipairs(self.group) do
        local control = ent.control

        local purpose = control[key]

        if purpose then
            control[purpose] = false
            if purpose == "push" then
                Cyan.call("endPush", ent)
            end
        end
    end
end





function ControlSys:newWorld(world)
    --local w,h = love.graphics.getDimensions( )
end




function ControlSys:transform()
    
    Camera:attach()

    local x = 0
    local y = 0
    local follow_count = 0
    
    if #self.group > 0 then
        for _, ent in ipairs(self.group) do
            follow_count = follow_count + 1
            x = x + ent.pos.x
            y = y + ent.pos.y
        end

        x = x / follow_count
        y = y / follow_count
    end
    
    Camera:follow(x,y)
end


function ControlSys:untransform()
    Camera:detach()
end

