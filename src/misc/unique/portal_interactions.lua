

local PortalInteracts = { }




local partition = require("src.misc.partition")
local ccall = Cyan.call
local rand = love.math.random

local BUF_TIME = 0.4 -- wait BUF_TIME seconds then spawn new world






local nLL = function(e)
    ccall("purge")
    ccall("newWorld",{
        x = rand(30,40);
        y = rand(30,40);
        type = "basic";
        tier = 1
    })
end

local function regularShockwave(x,y, col)
    ccall("shockwave", x, y, 25, 240, 9, 0.4, col)
end


function PortalInteracts.newLushLevel(e)
    --[[
        creates new level with feedback
    ]]
    local R = 3
    for i=0, R do
        ccall("await", regularShockwave, i*(BUF_TIME/(R+1)), e.pos.x, e.pos.y - e.pos.z/2, {0.05,0.3,0.3})
    end
    ccall("await", nLL, BUF_TIME+0.05, e) -- wait  seconds
end



return PortalInteracts