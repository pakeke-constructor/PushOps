




local partition = require("src.misc.partition")
local ccall = Cyan.call
local rand = love.math.random

local BUF_TIME = 0.7 -- wait BUF_TIME seconds then spawn new world




local genLevel = function(e)
    ccall("purge")
    local dest = e.portalDestination or error("No portal destination given")
    Cyan.flush()
    ccall("newWorld", {
        x = dest.x;
        y = dest.y;
        type = dest.type;
        tier = dest.tier
    })
end


local function regularShockwave(x,y, col)
    ccall("shockwave", x, y, 210, 40, 9, 0.4, col)
end


return function(portal, player)
    --[[
        creates new level with feedback
    ]]
    local R = 3
    player.hidden = true
    ccall("sound", "boom")
    ccall("sound", "teleport",0.4)
    ccall("animate", "tp_up", 0,0,0, BUF_TIME/10, 1, nil, player, true)
    -- TOOD: play a sound here
    for i=0, R-2 do
        ccall("await", regularShockwave, (i-1)*(BUF_TIME/R),
                portal.pos.x, portal.pos.y - portal.pos.z/2, {0.05,0.3,0.3})
    end
    ccall("await", genLevel, BUF_TIME+0.05, portal) -- wait  seconds
end


