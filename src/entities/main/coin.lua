
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call


local quad_arr = {
    "coin1","coin2","coin3","coin2"
}
for i,q in ipairs(quad_arr) do
    quad_arr[i] = Quads[q]
end


return function(x, y)
    local e = Cyan.Entity() 
    e:add("animation", {
        frames = quad_arr;
        interval = 0.3;
        current=0
    })
    e.targetID = "coin"
    EH.PV(e,x,y)
    EH.PHYS(e, 6)
    e.friction={
        required_vel=2
        ;amount=1.3
    }
    e.pushable=true
end


