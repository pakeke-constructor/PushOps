

local Atlas = require("assets.atlas")


local Ents = require("src.entities")
local cam = require("src.misc.unique.camera")


local rand = love.math.random


local DEBUG_SYS = Cyan.System()

local lg = love.graphics




local itemlist = require("src.misc.items.itemlist")

function DEBUG_SYS:keypressed(k)
    if k=="e"then
        local x=EH.Ents.itempillar(cam.x + 20, cam.y)
        x.itemType = "iron_potion"
    end
end

function DEBUG_SYS:_draw()
    lg.setColor(1,1,1)
    lg.push()
    lg.reset()
    love.graphics.rectangle("fill", 5, 300, 150, 40)
    lg.setColor(0,0,0)
    love.graphics.print("FPS: ".. tostring(love.timer.getFPS()), 10,300)
    love.graphics.print("time: "..tostring(CONSTANTS.runtime), 10, 320)
    --love.graphics.print(("MEM USAGE: %d"):format(tostring(collectgarbage("count"))), 10, 320)
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



