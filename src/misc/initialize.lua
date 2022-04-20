

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
        -- DEBUG ONLY
        -- EH.Ents.multiblock(cam.x,cam.y)
        EH.Ents.worm(cam.x, cam.y)

        --Ents.crafter(cam.x, cam.y)
    end

end

function DEBUG_SYS:_draw()
end





--[[ TEMP DEBUG STUFF
-- TODO: remove all of this later.
local _temp_canv = love.graphics.newCanvas(1200,1000)
love.graphics.setCanvas(_temp_canv)
love.graphics.push()

local str = "bosses"
love.graphics.scale(2)
love.graphics.setColor(0.9,0.9,0.9)
for i=1,#str do
    local c = str:sub(i,i)
    local r = math.floor(love.math.random(-3,3))
    Atlas:draw(Atlas.quads["letter_" .. c], 28 * i, r + 10)
end
love.graphics.pop()
love.graphics.setCanvas()


local _temp_canv_2 = love.graphics.newCanvas(1200,1000)
love.graphics.setCanvas(_temp_canv_2)
love.graphics.push()

local str = "and minibosses"
love.graphics.scale(2)
love.graphics.setColor(0.9,0.9,0.9)
for i=1,#str do
    local c = str:sub(i,i)
    local r = math.floor(love.math.random(-3,3))
    Atlas:draw(Atlas.quads["letter_" .. c], 28 * i, r + 10)
end
love.graphics.pop()
love.graphics.setCanvas()


function DEBUG_SYS:drawUI()
    love.graphics.push()
    love.graphics.scale(1.2)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(_temp_canv, 120, -10, 0.05)
    love.graphics.scale(0.6)
    love.graphics.draw(_temp_canv_2, -100, 100, 0.05)
    love.graphics.pop()
end
]]

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



