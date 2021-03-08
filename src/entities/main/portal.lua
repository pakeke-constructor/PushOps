
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call



local RING_ROT_SPEED = 2
local RING_DISTANCE = 14
local PORTAL_DISTANCE = 70
local COLOUR = {0.8,1,0.8}

local OZ = -30


--[[

Base portal



]]


local ring_img_comp = {
    quad = Quads.portalring
}

local function portalRing(period_start)
    local e = Cyan.Entity()
    :add("pos", math.vec3(0,0,OZ))
    :add("image", ring_img_comp)
    e._cur_portal_period = period_start
    return e
end




local function update(e, dt)
    local sin = math.sin
    local cos = math.cos
    local reset=false
    if e.portalRings[1]._cur_portal_period > math.pi*2 then
        -- reset so floating point err dont screw over and have
        -- overlap of periods
        reset=true
    end
    local pi2_3 = 2*math.pi/3
    for i, t_e in ipairs(e.portalRings) do
        t_e.colour = e.colour or t_e.colour
        if reset then
            t_e._cur_portal_period = (i-1) * pi2_3
        end
        t_e._cur_portal_period = t_e._cur_portal_period + dt * RING_ROT_SPEED
        local p = t_e.pos
        local ox, oy = e.pos.x, e.pos.y
        p.x = ox + RING_DISTANCE * sin(t_e._cur_portal_period)
        p.y = oy + RING_DISTANCE * cos(t_e._cur_portal_period)
    end
end




local portal_image = {
    quad = Quads.portal
}



return function(x, y)
    local e = Cyan.Entity()
    e.colour = COLOUR
    e.portalRings = {}
    for i=1,3 do
        table.insert(e.portalRings, portalRing((i-1) * (math.pi*2)/3))
    end

    e:add("image",portal_image)
    EH.PV(e,x,y,OZ)
    e.targetID = "interact"

    e.size = PORTAL_DISTANCE
    
    e.hybrid = true -- switched to hybrid OOP for this
    e.onUpdate = update

    e.portalFunc = nil -- override this in WorldGen.
    return e
end


