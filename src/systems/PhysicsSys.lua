

local PhysicsSys = Cyan.System("physics", "pos")
--[[

Handles all entities that require physics in the game.

If an object is in this system, the `vel` component and `pos`
component is read-only.


]]

local World


-- keeps ref
local fixture_to_ent = setmetatable({}, {__mode = "kv"})

--[[
    getTangentSpeed
getChildren
setEnabled
getPositions
setRestitution
__index
isDestroyed
isTouching
setFriction
resetRestitution
getFixtures
setTangentSpeed
getFriction
resetFriction
getNormal
isEnabled
__tostring
__eq
type
release
typeOf
getRestitution
]]

local vec3 = math.vec3

local function beginContact(fixture_A, fixture_B, contact_obj)

    local ent_A = fixture_to_ent[fixture_A]
    local ent_B = fixture_to_ent[fixture_B]

    -- Magnitude of collision
    local speed = ((ent_A.vel or vec3()) + (ent_B.vel or vec3())):len()

    if ent_A.toughness then
        if ent_A.toughness < speed then
            Cyan.call("hit", ent_A, ent_A.toughness - speed)
        end
    end

    if ent_B.toughness then
        if ent_B.toughness < speed then
            Cyan.call("hit", ent_B, ent_B.toughness - speed)
        end
    end
end



function PhysicsSys:pquery(x, y, callback)
    World:queryBoundingBox(x-3, y-3, x+3, y+3, callback)
end




function PhysicsSys:newWorld( world )
    if World then
        World:destroy()
    end

    World = love.physics.newWorld(0,0)

    World:setCallbacks(beginContact, nil, nil, nil)
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

    fixture_to_ent[ent.physics.fixture] = ent
end




function PhysicsSys:removed(ent)
    ent.physics.fixture:release()
    ent.physics.body:release()
    ent.physics.shape:release()
end










