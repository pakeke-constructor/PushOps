

--[[

System for dynamic emission of particles

this does NOT refer to love2d particleSystem,
but rather a system to handle dynamic creation and
emission of particles from love2d particlesystems

]]


local PSys = Cyan.System()

local DEFAULT_PARTICLES = 40


local ParticleTypes = require("src.misc.particles.types")

--[[

Remember `ParticleTypes` holds keyworded references to
"emitter objects", not love2d particleSystem objects!!!

]]


-- just quick checking ::::
for type, emitter in pairs(ParticleTypes) do
    assert(type == emitter.type, "Emitter.type confliction with filename for emitter.\nMake sure the emitter .type field has same name as the file!\n( See src.misc.particles.types )")
end




local available_emitters = setmetatable(
    {}, {__index = function(t,k) t[k] = {} return t[k] end}
    -- Arrays of available emitters, keyworded by type
)


local sset = Tools.set
local indexed_emitters = setmetatable(
    {}, {__index = function(t,k) t[k] = sset() return t[k] end}
)


local in_use = Tools.set()


local floor = math.floor


local function get_z_index(y,z)
    return floor((y+z)/2)
end



local function get_emitter(type)
    --[[
        gets emitter of certain type from the queue of that type.
        (also removes from queue)
    ]]
    local emitter

    local availables = available_emitters[type]
    if #availables > 0 then
        -- there is an available system to use!
        emitter = availables[#availables]
        availables[#availables] = nil
    else
        -- Else we gotta clone.
        emitter = ParticleTypes[type]:clone()
    end

    return emitter
end



local t_insert = table.insert

function PSys:emit(type, x,y,z , n_particles)
    n_particles = n_particles or DEFAULT_PARTICLES
    
    if not ParticleTypes[type] then
        error("PSys:emit(type, x,y, num) ==> Unrecognised emitter type ==> "..tostring(type))
    end

    local emitter = get_emitter(type)

    emitter:emit(x,y, n_particles)
    in_use:add(emitter)
    
    local z_dep = get_z_index(y,z)

    emitter.z_dep = z_dep
    emitter.y = y
    emitter.z = z
    emitter.x = x

    indexed_emitters[z_dep]:add(emitter)
end



function PSys:drawIndex( z_dep )
    for _, emtr in ipairs(indexed_emitters[z_dep].objects) do
        emtr:draw(emtr.x, emtr.y, emtr.z)
    end
end



function PSys:update(dt)
    for i, emitr in ipairs(in_use.objects) do
        emitr:update(dt)
        if emitr:isFinished() then
            in_use:remove(emitr)
            indexed_emitters[emitr.z_dep]:remove(emitr)
            emitr.runtime = 0

            t_insert(available_emitters[emitr.type], emitr)
        end
    end
end



function PSys:purge()
    --
    -- Releases all memory
    --
    
    
    for i,v in ipairs(in_use.objects)do
        in_use.objects[i]:release()
    end
    in_use:clear()

    --[[   Your using `pairs`???
    With this we don't care about JIT breaking. 
    This will only be called once when mass deletions need to happen
    ]]
    for k,v in pairs(indexed_emitters)do
        local ar = indexed_emitters[k].objects
        for i=1,#ar do
            ar[i]:release( )
        end
        indexed_emitters[k]:clear()
    end

    for k,v in pairs(available_emitters)do
        local ar = available_emitters[k]
        for i=1,#ar do
            ar[i]:release()
            ar[i] = nil
        end
    end
end



