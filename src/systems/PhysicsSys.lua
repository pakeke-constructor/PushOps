

local PhysicsSys = Cyan.System("physics", "pos")
--[[

Handles all entities that require physics in the game.

If an object is in this system, the `vel` component and `pos`
component is read-only.


]]


local World


local vec3 = math.vec3
local ccall = Cyan.call


-- keeps ref
local fixture_to_ent = setmetatable({}, {__mode = "kv"})

-- function to init new ents
local initNewEntities

local init_set = Tools.set()



local function beginContact(fixture_A, fixture_B, contact_obj)
    local ent_A = fixture_to_ent[fixture_A]
    local ent_B = fixture_to_ent[fixture_B]

    -- Magnitude of collision
    local speed = ((ent_A.vel or vec3()) + (ent_B.vel or vec3())):len()

    if ent_A.collisions then
        ccall("collide", ent_A, ent_B, speed)
    end

    if ent_B.collisions then
        -- Note that two calls are made here...
        ccall("collide", ent_B, ent_A, speed)
    end

    if ent_A.toughness then
        if ent_A.toughness < speed then
            ccall("hit", ent_A, ent_B, ent_A.toughness - speed)
        end
    end

    if ent_B.toughness then
        if ent_B.toughness < speed then
            ccall("hit", ent_B, ent_A, ent_B.toughness - speed)
        end
    end
end



function PhysicsSys:boxquery(x, y, callback)
    --[[
        Calls `callback` for each fixture in relative `x` `y` range.
    ]]
    World:queryBoundingBox(x, y, x+0.01, y+0.01, callback)
end

function PhysicsSys:rayquery(x,y,x1,y1,callback)
    World:rayCast(x,y,x1,y1,callback)
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
        --ent.physics.fixture:setGroupIndex(0)
    end
end


-- TODO :: setGroupIndex is not working as it should, I don't think
    -- I am using it properly.
function PhysicsSys:airborne(ent)
    if self:has(ent) then
        --ent.physics.fixture:setGroupIndex(1)
    end
end





function PhysicsSys:update(dt)
    World:update(dt)
end


function PhysicsSys:setPos(ent, x, y)
    if self:has(ent) then
        local body = ent.physics.body
        body:setX(x)
        body:setY(y)
    end
end





local Camera = require("src.misc.unique.camera")
local isOnScreen = Tools.isOnScreen


function PhysicsSys:heavyupdate(dt)
    for _,e in ipairs(self.group) do
        local body = e.physics.body
        local isAwake = body:isAwake()
        local within = isOnScreen(e, Camera)
        if within then
            local body = e.physics.body
            body:setActive(true) -- Is in range so wake up
        else
            body:setActive(false)
        end
    end
end





local function initialize(ent)
    local body_str = ent.physics.body

    ent.physics.body = love.physics.newBody(
        World, ent.pos.x, ent.pos.y, body_str
    )

    if body_str == "static" and ent.vel then
        error("Entity physics body assigned static, but has velocity component")
    end

    if body_str == "dynamic" or body_str == "kinematic" then
        ent.physics.body:setLinearVelocity(ent.vel.x, ent.vel.y)
    end

    ent.physics.body:setLinearDamping(CONSTANTS.PHYSICS_LINEAR_DAMPING)

    ent.physics.fixture = love.physics.newFixture(
        ent.physics.body,
        ent.physics.shape
    )

    if ent.physics.friction then
        ent.physics.body:setLinearDamping(ent.physics.friction)
    end

    fixture_to_ent[ent.physics.fixture] = ent
end




local er1 = [[
Attempted to construct ent when physics world was locked.
This kinda sucks; there is no good solution.
The best thing to do is `ccall("await", 0, entCtor)` so the ent will be constructed the next frame.
Sorry, this really does suck :(
]]
function PhysicsSys:added(ent)
    --[[
        will be in form:
        ent.physics = {
            shape = love.physics.newShape( )
            body = "kinetic"
        }
    ]]
    if World:isLocked( ) then 
        error(er1)  
    end

    initialize(ent)
end





function PhysicsSys:removed(ent)
    print(ent)
    fixture_to_ent[ent.physics.fixture] = nil

    -- FUTURE OLI HERE:
    -- why are these if statements here???
    if not ent.physics.fixture:isDestroyed() then
        ent.physics.fixture:destroy()
    end

    if not ent.physics.body:isDestroyed() then
        ent.physics.body:destroy()
    end

    -- Dont need to destroy the shape, 
    -- as it is shared between all ent instances.
end






