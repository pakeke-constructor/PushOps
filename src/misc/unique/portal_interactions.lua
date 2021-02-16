

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

function PortalInteracts.newLushLevel(e)
    ccall("await", nLL, BUF_TIME, e) -- wait  seconds    
end



return PortalInteracts