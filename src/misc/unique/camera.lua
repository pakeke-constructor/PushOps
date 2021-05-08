


local Camera = require("libs.NM_STALKER_X.Camera")



local cam =  Camera(0,0, nil,nil, 1.6, -- scale 
                    0)  -- rotation

cam:setFollowLerp(0.05)
cam:setFollowLead(10)


return cam
