
--[[
ControlSys:

Handles camera motion and player motion.

TODO: add joystick support, make more robust

]]


local ControlSys = Cyan.System("control")

local Camera = require("src.misc.unique.camera")

local max, min = math.max, math.min

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

        if c.zoomIn then
            Camera.scale = max(Camera.scale * 0.99, 1.5)
        end
        if c.zoomOut then
            Camera.scale = min(Camera.scale * 1.01, 3)
        end
    end
end





local r = love.math.random 

function ControlSys:keytap(key)
    for _, ent in ipairs(self.group) do
        local c = ent.control
        if c[key] == 'push' then
            local x = ent.pos.x
            local y = ent.pos.y
            local z = ent.pos.z
            Cyan.call("boom", x, y, ent.strength, 50)
            Cyan.call("animate", "push", x,y+25,z, 0.03) 
            Cyan.call("emit", "shell", x, y, 1, r(2,3))
            Cyan.call("sound", "boom")
            Camera:shake(8, 1, 60)
        elseif c[key] == 'pull' then
            Cyan.call("sound", "moob")
            Cyan.call("moob", ent.pos.x, ent.pos.y, ent.strength/1.5, 140)
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



--[[

Drawing health Bar

]]
local setColor = love.graphics.setColor
local rect = love.graphics.rectangle
local draw = love.graphics.draw
local atlas = require("assets.atlas")
local Quads = atlas.Quads
local lg=love.graphics
local HP_X = 10
local HP_Y = 8

local tick = 0
local sin = math.sin

function ControlSys:drawUI()
    -- At the moment, we only support 1 health bar.
    local hp = self.group[1].hp
    tick = tick + 0.01
    setColor( 0.7 + 0.1*sin(tick) ,0,0)
    rect("fill", HP_X+2, HP_Y+2, 26 * (hp.hp / (hp.max_hp)), 10)
    setColor(1,1,1)
    atlas:draw(Quads.hp_bar, HP_X, HP_Y)
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



