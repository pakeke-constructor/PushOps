

--[[ ]]
Cyan.call("newWorld",{
    x=100,y=100,
    tier = 1,
    type = 'menu'
}, require("src.misc.worldGen.maps.menu_map"))

--]]


--[[
local gladmap = require("gladiator_map")
ccall("newWorld",{
    x = #gladmap[1];
    y = #gladmap;
    tier=1;
    type="gladiator"
}, gladmap)
--]]
local rand = love.math.random

local Ents = require("src.entities")
local cam = require("src.misc.unique.camera")

local Atlas = require("assets.atlas")

local DEBUG_SYS = Cyan.System()

local lg = love.graphics



local e1s = {
    EH.Ents.devil;
    EH.Ents.mallow;
    EH.Ents.blob;
    EH.Ents.enemy
}

local e2s = {
    EH.Ents.boxbully;
}

local e3s = {
    EH.Ents.bigworm
}

local function challengeMe(sptab, spawns)
    for i=1,(spawns or 1) do
        local theta = love.math.random() * 6.25
        local X = cam.x + math.sin(theta)*420
        local Y = cam.y + math.cos(theta)*420
        Tools.rand_choice(sptab)(X,Y)
    end
end



function DEBUG_SYS:keypressed(k)
    if k=='p' then
        CONSTANTS.paused = not CONSTANTS.paused
    end
    if k=="escape" then
        love.event.quit(0)
    end
    if k=="e"then
        --EH.Ents.yellowpine(cam.x,cam.y)
    end
end



function DEBUG_SYS:_draw()
    lg.setColor(1,1,1)
    lg.push()
    lg.reset()
    love.graphics.rectangle("fill", 5, 95, 150, 40)
    lg.setColor(0,0,0)
    love.graphics.print("FPS: ".. tostring(love.timer.getFPS()), 10,100)
    love.graphics.print(("MEM USAGE: %d"):format(tostring(collectgarbage("count"))), 10, 120)
    lg.pop()
end


--[[

local tick = 0

local sin = function(x)
    return math.abs(math.sin(x))
end

function DEBUG_SYS:update(dt)
    tick = (tick + dt*3) % (2*math.pi)
    CONSTANTS.grass_colour = {sin(tick + 1), sin(tick + 2), sin(tick +3)}
end

]]


local ccall=Cyan.call
function DEBUG_SYS:mousepressed()
end



