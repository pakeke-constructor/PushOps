


local Camera = require("libs.NM_STALKER_X.Camera")


local SCREEN_DIAG_LAPTOP = 1762 -- My laptop screen diagonal size
local SF = 2.1 -- A reasonable scale factor

local SCREEN_DIAG = (love.graphics.getWidth()^2 + love.graphics.getHeight()^2)^0.5

local SCALE = (SCREEN_DIAG / SCREEN_DIAG_LAPTOP) * SF

local cam =  Camera(0,0, nil,nil, SCALE,
                    0)  -- rotation

cam:setFollowLerp(0.05)
cam:setFollowLead(10)


return cam

