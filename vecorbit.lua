
--[[

Vector based version of `ORBIT`
MoveBehaviour.

MoveBehaviour :: VECORBIT


.move = {
    target = vec3(...)
    orbit_tick = 0;
    orbit_speed = 0.2;   -- how many orbits is done per second
    orbit_radius = 60; -- the radius of which the ent will orbit around
}

]]


local sin, cos = math.sin, math.cos
local DEFAULT_RADIUS = 60

function VECORBIT:update(e, dt)
    local move = e.behaviour.move

    if not move.initialized then
        self:init(e)
    end

    move.orbit_tick = (move.orbit_tick + move.orbit_speed * dt) % (math.pi*2)
    local target = move.target

    if not target then
        return nil -- No target given, fine by me. don't move the ent
    end

    local rad = move.orbit_radius or DEFAULT_RADIUS

    self.updateGotoTarget(e, target.x + rad*sin(move.orbit_tick),
                            target.y + rad*cos(move.orbit_tick), dt)
end



function VECORBIT:init(e)
    -- field assertion
    local move = e.behaviour.move
    assert(move.orbit_tick)
    assert(move.orbit_speed)

    move.initialized = true
end



return setmetatable(VECORBIT, require(Tools.Path(...)..".base"))

