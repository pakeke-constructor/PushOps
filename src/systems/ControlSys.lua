
--[[
ControlSys:

Handles camera transformations and player motion.

Also handles `pushing` and `pulling` by player,
and HealthBars etc.

TODO: add joystick support, make more robust

]]


local ControlSys = Cyan.System("control")

local Camera = require("src.misc.unique.camera")
local Partition = require 'src.misc.partition'
local TargetPartitions = require("src.misc.unique.partition_targets")



local max, min = math.max, math.min

local ROT_AMPLITUDE = 0.03
local ROT_FREQ = 0.07

local cur_sin_amount = 0
local cam_rot = 0



local dist = Tools.dist
local ccall = Cyan.call
local dot = math.dot



    -- THIS FUNCTION IS FOR DEBUG PURPOSES ONLY !!!!!!!!!!!
function ControlSys:wheelmoved(dx, dy)
    Camera.scale = Camera.scale + (dy/30)
end



function ControlSys:added(e)
    -- just some sanity checks
    e.control.canPush = true
    e.control.canPull = true
end



local function findEntToPush(ent)
    --[[
        returns the closest ent that is able to be pushed by `ent`.
    ]]
    local min_dist

    if ent.size then
        min_dist = ent.size * 10
    else
        min_dist = 50
    end

    local best_ent = nil
    local epos = ent.pos
    local vx, vy = ent.vel.x, ent.vel.y

    for candidate in Partition:longiter(ent) do
        -- if its not moving, it wont be pushed
        if candidate.vel then
            local ppos = candidate.pos
            local dx, dy

            dx = ppos.x - epos.x
            dy = ppos.y - epos.y
            
            if candidate.pushable then
                local distance = dist(dx, dy)
                if distance < min_dist then
                    -- Is a valid candidate ::
                    if dot(dx, dy, vx,vy) > 0 then
                        best_ent = candidate
                        min_dist = distance
                    end
                end
            end
        end
    end

    return best_ent
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
        ccall("addVel", ent, dx, dy)

        if c.zoomIn then
            Camera.scale = max(Camera.scale * (1-dt), 1.5)
        end
        if c.zoomOut then
            Camera.scale = min(Camera.scale * (1+dt), 3)
        end
    end
end



local r = love.math.random 

local function afterPush(player)
    if Cyan.exists(player) then
        ccall("sound", "reload", 0.2)
        ccall("emit", "shell", player.pos.x, player.pos.y, 1, r(2,3))
        player.control.canPush = true
    end
end



local function push(ent)
    assert(ent.control,"??????????")
    
    if ent.control.canPush then
        local x = ent.pos.x
        local y = ent.pos.y
        local z = ent.pos.z

        -- boom will be biased towards enemies with 1.2 radians
        ccall("boom", x, y, ent.strength, 100, 0,0, "enemy", 1.2)
        ccall("animate", "push", x,y+25,z, 0.03) 
        ccall("shockwave", x, y, 4, 130, 7, 0.3)
        ccall("sound", "boom")
        Camera:shake(8, 1, 60) -- this doesnt work, RIP

        ent.control.canPush = false
        ccall("await", afterPush, CONSTANTS.PUSH_COOLDOWN + r()/5, ent)

        for e in (TargetPartitions.interact):iter(ent.pos.x, ent.pos.y) do
            if e ~= ent then
            -- ents cannot interact with themself
                if e.onInteract and Tools.edist(ent, e) < e.size then
                    e:onInteract(ent, "push")
                end
            end
        end
    else
        --TODO ::: add feedback here!
        -- the player just tried to push on cooldown
    end
end




local function afterPull(player)
    if Cyan.exists(player) then
        player.control.canPull = true
    end
end

local function pull(ent)
    assert(ent.control, "?????")

    if ent.control.canPull then
        local x,y = ent.pos.x, ent.pos.y

        ent.control.canPull = false
        ccall("sound", "moob")
        ccall("shockwave", x, y, 130, 4, 7, 0.3)
        ccall("moob", x, y, ent.strength/1.3, 300)
        ccall("await", afterPull, CONSTANTS.PULL_COOLDOWN + r()/5, ent)

        for e in (TargetPartitions.interact):iter(x, y) do
            if e ~= ent then
                -- ents cannot interact with themself
                if e.onInteract and Tools.edist(ent, e) < e.size then
                    e:onInteract(ent, "pull")
                end
            end
        end
    else
        --TODO ::: add feedback here!
        -- the player just tried to pull on cooldown
    end
end





function ControlSys:keytap(key)
    for _, ent in ipairs(self.group) do
        local c = ent.control
        if key == "t" then
            local e=ent
            ccall("emit", "rocks", e.pos.x, e.pos.y, e.pos.z, 2)
        end
        if c[key] == 'push' then
            push(ent)
        elseif c[key] == 'pull' then
            pull(ent)
        end
    end
end





function ControlSys:keydown(key)
    for _, ent in ipairs(self.group) do
        local control = ent.control

        local purpose = control[key]

        if purpose then
            control[purpose] = true
        end
    end
end



function ControlSys:keyheld(key, time)
    for _, ent in ipairs(self.group) do
        local control=ent.control
        local purpose = control[key]
        if purpose == "push" then
            if not ent.pushing then
                local push_ent = findEntToPush(ent)
                if push_ent then
                    ent:add("pushing", push_ent)
                end
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
                if ent:has("pushing") then
                    ent:remove("pushing")
                end
            end
        end
    end
end





function ControlSys:newWorld(world)
    --local w,h = love.graphics.getDimensions( )
end



function ControlSys:purge()
    Cyan.clear( ) -- Deletes all entities.
    -- big operation
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
    -- check that a player exists
    if self.group[1] then
        -- At the moment, we only support 1 health bar.
        local hp = self.group[1].hp
        tick = tick + 0.01
        setColor( 0.7 + 0.1*sin(tick) ,0,0)
        rect("fill", HP_X+2, HP_Y+2, 26 * (hp.hp / (hp.max_hp)), 10)
        setColor(1,1,1)
        atlas:draw(Quads.hp_bar, HP_X, HP_Y)
    end
end







local function getAveragePosition(group) -- => (x, y)
    if #group > 0 then
        local x = 0
        local y = 0
        local follow_count = 0
        
        for _, ent in ipairs(group) do
            follow_count = follow_count + 1
            x = x + ent.pos.x
            y = y + ent.pos.y
        end
    
        x = x / follow_count
        y = y / follow_count
        return x,y
    else -- not enough entities to get an average position
        return 0,0
    end
end




function ControlSys:transform()    
    Camera:attach()

    local x,y = getAveragePosition(self.group)
    
    Camera:follow(x,y)
end


function ControlSys:untransform()
    Camera:detach()
end



