
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call



local RING_ROT_SPEED = 2
local RING_DISTANCE = 14
local PORTAL_DISTANCE = 70
local COLOUR = {0.8,1,0.8}

local OZ = -25


--[[

Base portal

]]


local ring_img_comp = {
    quad = Quads.portalring
}

local function portalRing(period_start)
    local e = Cyan.Entity()
    :add("pos", math.vec3(0,0,OZ))
    :add("vel",math.vec3())
    -- yeah we arent actually using velocity. We just need the spatial partition
    -- to be aware that this entity is moving
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
    for i, ring in ipairs(e.portalRings) do
        ring.colour = e.colour or ring.colour
        if reset then
            ring._cur_portal_period = (i-1) * pi2_3
        end
        ring._cur_portal_period = ring._cur_portal_period + dt * RING_ROT_SPEED
        local p = ring.pos
        local ox, oy = e.pos.x, e.pos.y - 40
        local new_x = ox + RING_DISTANCE * sin(ring._cur_portal_period)
        local new_y = oy + RING_DISTANCE * cos(ring._cur_portal_period)
        assert(new_x==new_x, "nan spotted")
        assert(new_y==new_y, "nan spotted")
        ring.pos.z = e.pos.z - 80
        ccall("setPos", ring, new_x, new_y)
    end
end



local function onDeath(portal)
    for _, chil in ipairs(portal.portalRings)do
        chil:delete()
    end
end





local portal_image = {
    quad = Quads.portal
}


local portalFunc = require("src.misc.unique.portal_function")


return function(x, y)
    local e = Cyan.Entity()
    e.colour = COLOUR
    e.portalRings = {}
    for i=1,3 do
        table.insert(e.portalRings, portalRing((i-1) * (math.pi*2)/3))
    end

    e.rot = 0
    e.avel = 0.007
    e:add("image",portal_image)
    e:add("pos", math.vec3(x,y,OZ))

    e.targetID = "interact"

    e.size = PORTAL_DISTANCE

    e.onUpdate = update
    e.hybrid = true -- switched to hybrid OOP for this

    e.onInteract = portalFunc

    -- portal destination
    -- this holds fields that give ccall("newWorld") info about how to gen itself
    -- (This is usually set )

    e.portalDestination = { -- this is just for example
        x = 5; -- x size
        y = 6; -- y size

        type = "NO PORTAL DESTINATION";
        tier = 1
    }
    e.portalDestination = nil -- give nil, so override is forced

    -- Spawn text entity tooltip:
    EH.Ents.goodtxt(x,y,50,"press > to use",{1,1,1},140)

    return e
end


