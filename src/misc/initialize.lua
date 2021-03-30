


Cyan.call("newWorld",{
    x=100,y=100,
    tier = 1,
    type = 'menu'
}, require("src.misc.worldGen.menu"))

local rand = love.math.random

local Ents = require("src.entities")
local cam = require("src.misc.unique.camera")

local Atlas = require("assets.atlas")

local DEBUG_SYS = Cyan.System()

local lg = love.graphics



function DEBUG_SYS:keypressed(k)
    if k=='p' then
        CONSTANTS.paused = not CONSTANTS.paused
    end
    if k=="b"then
        local x,y = Tools.getCameraPos(cam)
        ccall("shootbolt", x+20,y+20, -200,200)
    end
    if k=='u' then
        ccall("animate", "tp_down", -10,-20, 40, 0.015, 1)
    end
end


local should_draw=true
function DEBUG_SYS:drawEntity()
    if should_draw then
        love.graphics.draw(Atlas.image,-300,-10)
        should_draw=false
    end
end


function DEBUG_SYS:draw()
    should_draw=true
    lg.setColor(1,1,1)
    lg.push()
    lg.reset()
    lg.setColor(0,0,0)
    love.graphics.print("FPS: ".. tostring(love.timer.getFPS()), 10,60)
    lg.pop()
end


--[[

local tick = 0

local sin = function(x)
    return math.abs(math.sin(x))
end

function DEBUG_SYS:update(dt)
    tick = (tick + dt*3) % (2*math.pi)
    CONSTANTS.GRASS_COLOUR = {sin(tick + 1), sin(tick + 2), sin(tick +3)}
end

]]


local ccall=Cyan.call
function DEBUG_SYS:mousepressed()
end



