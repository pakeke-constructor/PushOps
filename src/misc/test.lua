


Cyan.call("newWorld",{
    x=80,y=40,
    tier = 1,
    type = 'menu'
}, require("src.misc.worldGen.menu"))


local Ent = require("src.entities")
local cam = require("src.misc.unique.camera")

local DEBUG_SYS = Cyan.System()

local lg = love.graphics


function DEBUG_SYS:keypressed(k)
    if k=="e" then

    end
    if k=='p' then        
        CONSTANTS.paused = not CONSTANTS.paused
    end
end


local ccall=Cyan.call
function DEBUG_SYS:mousepressed()
end



