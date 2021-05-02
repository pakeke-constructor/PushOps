




local partition = require("src.misc.partition")
local ccall = Cyan.call
local rand = love.math.random

local BUF_TIME = 0.4 -- wait BUF_TIME seconds then spawn new world




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
    ccall("shockwave", x, y, 35, 210, 9, 0.4, col)
end


return function(e)
    --[[
        creates new level with feedback
    ]]
    local R = 3
    for i=0, R do
        ccall("await", regularShockwave, (i-1)*(BUF_TIME/R), e.pos.x, e.pos.y - e.pos.z/2, {0.05,0.3,0.3})
    end
    ccall("await", genLevel, BUF_TIME+0.05, e) -- wait  seconds
end

