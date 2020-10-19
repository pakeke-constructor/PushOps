

local PhysicsSys = Cyan.System("physics", "pos")
--[[

Handles all entities that require physics in the game.

If an object is in this system, the `vel` component and `pos`
component is read-only.


]]

local World





function PhysicsSys:newWorld( world )
    World = love.physics.newWorld(0,0)
end


-- TODO :: setGroupIndex is not working as it should, I don't think
    -- I am using it properly.
function PhysicsSys:grounded(ent)
    if self:has(ent) then
        --ent.physics.body:setAwake(true)
        ent.physics.fixture:setGroupIndex(0)
    end
end


-- TODO :: setGroupIndex is not working as it should, I don't think
    -- I am using it properly.
function PhysicsSys:airborne(ent)
    if self:has(ent) then
        ent.physics.fixture:setGroupIndex(1)
    end
end



function PhysicsSys:update(dt)
    World:update(dt)
end



function PhysicsSys:added(ent)
    --[[
        will be in form:
        ent.physics = {
            shape = love.physics.newShape( )
            body = "kinetic"
        }
    ]]
    local body_str = ent.physics.body
    ent.physics.body = love.physics.newBody(
        World, ent.pos.x, ent.pos.y, body_str
    )

    ent.physics.body:setLinearDamping(CONSTANTS.PHYSICS_LINEAR_DAMPING)

    ent.physics.fixture = love.physics.newFixture(
        ent.physics.body,
        ent.physics.shape
    )
end




function PhysicsSys:removed(ent)
    ent.physics.fixture:release()
    ent.physics.body:release()
    ent.physics.shape:release()
end








