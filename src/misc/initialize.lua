


Cyan.call("newWorld",{
    x=100,y=100,
    tier = 1,
    type = 'menu'
}, require("src.misc.worldGen.menu"))

local rand = love.math.random

local Ents = require("src.entities")
local cam = require("src.misc.unique.camera")

local DEBUG_SYS = Cyan.System()

local lg = love.graphics



function DEBUG_SYS:keypressed(k)
    if k=='p' then
        CONSTANTS.paused = not CONSTANTS.paused
    end
end


function DEBUG_SYS:draw()
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



