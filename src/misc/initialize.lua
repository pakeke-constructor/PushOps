

local Atlas = require("assets.atlas")


local Ents = require("src.entities")
local cam = require("src.misc.unique.camera")


local rand = love.math.random


local DEBUG_SYS = Cyan.System()

local lg = love.graphics




local itemlist = require("src.misc.items.itemlist")

function DEBUG_SYS:keypressed(k)
    -- MAKE SURE STUFF ISNT PUT HERE ON RELEASE!
    if k == "e" then
        EH.Ents.multiblock(cam.x,cam.y)

        --Ents.crafter(cam.x, cam.y)
    end
end

function DEBUG_SYS:_draw()
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



