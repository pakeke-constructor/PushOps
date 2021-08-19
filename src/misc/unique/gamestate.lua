

local cyan = _G.Cyan

local gamestate = { }


local n = 0
local n2 = 0


function gamestate.update(dt)
    -- paused is for DEBUG ONLY!!
    if CONSTANTS.paused then
        return
    end
    dt = math.min(dt, CONSTANTS.MAX_DT)

    cyan.call("update",dt)

    if n > 60 then
        n = 0
        cyan.call("heavyupdate", dt)
    end

    if n2 > 2 then
        cyan.call("sparseupdate", dt) -- Is called once every 4 frames
        n2 = 0
    end

    n2 = n2 + 1
    n = n + 1
end


function gamestate.draw( )
    cyan.call("draw")
end


function gamestate.keypressed(a,b,c)
    cyan.call("keypressed", a,b,c)
end


function gamestate.keyreleased(a,b)
    cyan.call("keyreleased", a,b)
end

function gamestate.wheelmoved(x,y)
    cyan.call("wheelmoved", x, y)
end


function gamestate.mousemoved(x,y,dx,dy)
    cyan.call("mousemoved", x,y,dx,dy)
end

function gamestate.mousepressed(x,y, button, istouch, presses)
    cyan.call("mousepressed", x,y, button, istouch, presses)
end


function gamestate.quit()
    cyan.call("quit")
    return false --Yes, we should indeed quit
end


function gamestate.load()
    cyan.call("load")
end


function gamestate.focus( boolean )
    cyan.call("focus", boolean)
end


for k,v in pairs(gamestate) do
    _G.love[k] = v
end






