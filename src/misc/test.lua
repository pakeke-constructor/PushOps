


Cyan.call("newWorld",{
    x=80,y=40,
    tier = 1,
    type = 'basic'
})

local Ent = require("src.entities")



local p = Ent.player(0,0)
local cam = require("src.misc.unique.camera")


local DEBUG_SYS = Cyan.System()

local lg = love.graphics


function DEBUG_SYS:keypressed(k)
    if k=='p' then        
        CONSTANTS.paused = not CONSTANTS.paused
    end
    if k=='e' then
        Ent.pine(p.pos.x, p.pos.y)
    end
end



function DEBUG_SYS:mousepressed()
end


function DEBUG_SYS:draw()
    lg.push()
    lg.scale(1)
    lg.setColor(0,0,0)
    lg.translate(0, 40)
    lg.print(("Memory used:: " .. (math.floor(collectgarbage("count")/10)/100) .. " MB"),20,50)
    lg.print(("Player speed:: %d"):format(math.floor(p.vel:len())), 20, 65)
    lg.print(("FPS :: %d"):format(love.timer.getFPS( )), 20, 80)
    lg.print(("Player x, y : %d, %d"):format(p.pos.x, p.pos.y), 20,100)
    lg.setColor(1,1,1)
    lg.pop()
end


