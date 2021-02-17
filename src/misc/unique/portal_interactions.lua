

local PortalInteracts = { }




local partition = require("src.misc.partition")
local ccall = Cyan.call
local rand = love.math.random

local BUF_TIME = 1.8 -- wait 1.8 seconds then spawn new world






local nLL = function(e)
    ccall("purge")
    ccall("newWorld",{
        x = rand(60,80)-40;
        y = rand(60,80)-40;
        type = "basic";
        tier = 1
    })
end

local function feedBack(e)
    ccall("shockwave", e.pos.x, e.pos.y, 16, 260, 5, BUF_TIME/2, {0.4,0.1,0.4})
end


function PortalInteracts.newLushLevel(e)
    ccall("shockwave", e.pos.x, e.pos.y, 16, 260, 5, BUF_TIME/2, {0.4,0.1,0.4})
    ccall("await", nLL, BUF_TIME, e) -- wait  seconds
    ccall("await", feedBack, BUF_TIME/2, e)  
end



return PortalInteracts