

--[[


Just like regular enemies, but with high HP.

Tests :: passed
]]


local player_shape = love.physics.newCircleShape(8)

local atlas = require "assets.atlas"
local Quads = atlas.Quads

local psys = love.graphics.newParticleSystem(atlas.image)
psys:setQuads(Quads.bat, Quads.bot, Quads.bit)
psys:setParticleLifetime(0.4, 0.6)
--psys:setLinearAcceleration(0,0,200,200)
psys:setDirection(180)
psys:setSpeed(5,15)
psys:setEmissionRate(90)
psys:setSpread(math.pi/2)
psys:setEmissionArea("uniform", 6,0)
psys:setColors({1,1,1}, {1,1,1,0})
psys:setSpin(-40,40)
psys:setRotation(0, 2*math.pi)
psys:setRelativeRotation(false)
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)



local motion_down = { Quads.player_down_1, Quads.player_down_2, Quads.player_down_3, Quads.player_down_4 }
local motion_up = { Quads.player_up_1, Quads.player_up_2, Quads.player_up_3, Quads.player_up_4 }
local motion_left = { Quads.player_left_1, Quads.player_left_2, Quads.player_left_3, Quads.player_left_4 }
local motion_right = { Quads.player_right_1, Quads.player_right_2, Quads.player_right_3, Quads.player_right_4 }



local col={
    0.68,1,0.57
}


local ccall = Cyan.call

local r = love.math.random



local pi=math.pi

local BULLET_SPEED = 250

local function spawnAfterDeath(x,y,z)
    ccall("emit", "dust", x, y, z, r(13,18))
    local offset = r()*2
    for l=0,2 do
        local dy,dx
        dy = math.cos(((l*pi*2)/3)   +  offset)
        dx = math.sin(((l*pi*2)/3)   +  offset)
        ccall("shoot",x+30*dx,y+30*dy, dx*250, dy*250)
    end
end


--# shockwave ( x, y, start_size, end_size, thickness, time, colour=WHITE )
local onDeath = function(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(2,4))
    ccall("shockwave", p.x,p.y, 160, 3, 9, .1, {0.68,1,0.57})
    ccall("await", spawnAfterDeath, 0, p.x,p.y,p.z )
    EH.TOK(e,r(1,2))
end



local ai_types = { "ORBIT", "LOCKON" }


local ENT_DMG_SPEED = CONSTANTS.ENT_DMG_SPEED

local physColFunc = function(e1, e2, speed)
    if EH.PC(e1,e2,speed) then
        local p =e1.pos
        ccall("emit","guts",p.x,p.y,p.z, r(8,12))
        ccall("sound", "thud")
    end
end


local RAND_or_IDLE = {"RAND", "IDLE"}



local Tree = EH.Node '_devil behaviour tree'

Tree.choose = function(node, e)
        local ret = "idle"
        if e.hp.hp < e.hp.max_hp then
            ret= "angry"
        end;
        if love.math.random() < 0.4 then
            ret = "angry" -- has a chance to be angry anyway
        end
        return ret
end


local rand_move_task = EH.Task("_devil move task")
rand_move_task.start = function(t,e)
    ccall("setMoveBehaviour", e, Tools.rand_choice(ai_types))
end
rand_move_task.update=function(t,e)
    return "n"
end


Tree.angry = {
    rand_move_task,
    "wait::10"
}


Tree.idle = {
    "move::IDLE",
    "wait::4"
}



Tree:on("damage", function(n,e)
    return "angry"
end)




return function(x,y)
    local enemy = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))

    :add("sigils",{"strength"})
    
    :add("hp", {hp = 900, max_hp = 900})

    :add("speed", {speed = 145, max_speed = math.random(200,240)})

    :add("strength", 40)

    :add("physics", {
        shape = player_shape;
        body  = "dynamic"
    })

    :add("colour", col)

    :add("bobbing", {magnitude = 0.25 , value = 0})
    
    :add("friction", {
        amount = 6; -- The amount of friction given to this entity
        emitter = psys:clone();
        required_vel = 10;
    })

    :add("targetID", "enemy") -- is an enemy

    enemy:add("behaviour",{
            move = {
                type = Tools.rand_choice(ai_types),
                id="player", -- targetting player.
                
                orbit_speed = 2;
                orbit_tick = 0
            };
            tree=Tree
    })

    :add("onDeath", onDeath)

    :add("collisions",{
        physics = physColFunc
    })

    :add('light',{
        colour = {0.76,1,0.85,1};
        distance = 20
    })

    enemy:add("motion",
    {
        up = motion_up;
        down = motion_down;
        left = motion_left;
        right = motion_right;

        current = 0;
        interval = 0.1;
        required_vel = 20;
    })

    :add("sigils",{"horns"})

    return enemy
end

