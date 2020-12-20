

--@object System
--[[
    "Systems" in Cyan are objects that automatically take entities
    and apply functions to them.
    A system will only take an entity if it has all of the required
    components.
    Systems can be created using  cyan.System(...)
    Where ... is the set of components that the system will check in
    an entity before accepting it.

    Access an array of Entities in a system with System.group;
    iterate over with:

    for _, entity in ipairs(mySystem.group) do
    end
]]


local PATH = (...):gsub('%.[^%.]+$', '')

local set = require(PATH..'.sets')
local array = require(PATH..".array")



-- Bitops
local ffi, compbitbase, compbitbase_shiftnum, max_shiftnum
do
    if jit and jit.status() and false then -- We can't use this because luaJIT doesn't
        ffi = require "ffi"                -- support bitops in this version.
                            -- This means that components are limited to 32 :/
    end

    if ffi then
        compbitbase = ffi.new("long", 1) -- the bit mask that is assigned to each component.
        max_shiftnum = 63 -- max is larger as we can access a higher int precision
                          -- (This number is also the maximum number of components available.)
    else
        -- unfortunetely no FFI
        compbitbase = 1
        max_shiftnum = 31 -- max is set to lua precision of 32 bit int. :/
    end

    compbitbase_shiftnum = 1 -- number of bit shifts currently
end




local System = {}

do
    -- 2d hasher that holds references to all systems (by component keyword.)
    System.comp_backrefs = setmetatable({},
        {__index = function(t,k) t[k] = array() return t[k] end}
    )

    -- 2d hasher that holds references to all systems that contain given function
    -- (same as System.backrefs, but for functions, not components)
    System.func_backrefs = setmetatable({},
        {__index = function(t,k) t[k] = array() return t[k] end}
    )

    -- A reference to all components that exist. (Or, at least components that affect what systems an entity will get into.)
    System.components = set()

    -- A reference to all the component bit objects by component kw
    System.component_bits = { }

    -- Array that holds all systems   (  arr[-1] = val to add stuff )
    System.systems = array()

    -- Arrays that holds all non-static systems.
    -- i.e. Systems that take entities.
    System.non_static_systems = array()
end


 
local function newComponent(comp_name)
    if compbitbase_shiftnum > max_shiftnum then
        
        -- TODO::  make this automatically turn off bitops instead of raising error.
        return error("Too many components. (over "..tostring(max_shiftnum)..") please reduce the number of components you are using.")
    
    end
    System.component_bits[comp_name] = bit.tobit(compbitbase)
    System.components:add(comp_name)
    -- Checking we haven't reached bit overflow.
    compbitbase_shiftnum = compbitbase_shiftnum + 1
        
    compbitbase = compbitbase * 2 -- Same as logical bit shift left by 1.
end


local function getMask(...)
    -- ... is a list of component names.
    local mask = bit.tobit(0)

    for _, comp in ipairs({...}) do
        assert(System.component_bits[comp], "This component shoulda been initialized. Fix nerd!")
        mask = bit.bor(mask, System.component_bits[comp])
    end
    return mask
end





local System_mt = {
    --[[
    __newindex will be called whenever user does:

    function mySys:draw( ent )
        <blah yada>
    end
    ]]
    __index = System
    ;
    __newindex = function(sys, name, func)
        if type(func) == "function" then
            rawset(sys, name, func)

            -- Add to func_backrefs so can be accessed fast under Cyan.call
            System.func_backrefs[name]:add(sys)
        else
            error("Systems can only have functions added to them.")
        end
    end
    ;
    -- safety first
    __metatable = "Defended metatable"
}


local backrefs = System.comp_backrefs



function System:new( ... )--@ALIAS@ System( ... )
    --[[
        Creates a new system
        ( Same as System(...)  )

        @param string ... @(
            A set of component-strings denoting which entities to accept into system's group
        )

        @ return System system @
    ]]
    local requirement_table = {...}

    for _, comp in ipairs(requirement_table) do
        if not System.components:has(comp) then -- Initialize any new components.
            newComponent(comp)
        end
    end

    local new_sys = {
        ___requirements = requirement_table
        ;
        -- Backend group for this system.
        -- front-end access is done through ___group.objects  (thru sys.group)
        ___group = set()
        ;
        ___mask = getMask(...)
        ;
        active = true
    }
    new_sys.group = new_sys.___group.objects

    -- Adds system to required component-sets in backrefs.
    -- (for easy future access)
    for _, v in pairs(requirement_table) do
        local backref_set = backrefs[v]
        backref_set:add(new_sys)
    end

    -- Adds to system list
    System.systems[-1] = new_sys

    -- Adds to non_static_systems, only if it takes entities.
    if (#requirement_table > 0) then
        -- System takes entities -> it is non-static.
        System.non_static_systems[-1] = new_sys
    end

    return setmetatable(new_sys, System_mt)
end





local band = bit.band


function System:worthy_YES_BITOP(ent)
    -- Returns true if the entity is worthy of being added to system
    -- If jit is on, (which it should be,) this will run like lightning.
    return (band(ent.___mask, self.___mask) == self.___mask)
end

function System:worthy_NO_BITOP(ent)
    -- without bitops.
    for _, requirement in ipairs(self.___requirements) do
        -- If the system has all requirements,
        -- Add it to `getted_systems`
        if not ent[requirement] then
            return false
        end
    end
    return true
end

System.worthy = System.worthy_YES_BITOP




function System:has( ent )
    --[[
        Returns whether the system has an entity, or not.

        @arg Entity ent @ The entity to check if it's in the system

        @return bool @ True if system has the entity, nil otherwise
    ]]
    return self.___group:has(ent)
end




function System:add( ent )
    --[[
        Adds an entity to a system

        @arg Entity ent @ The entity to be added

        @return self
    ]]
    if self:has(ent) then
        return self
    end
    self:added(ent)
    self.___group:add(ent)
    return self
end


function System:remove( ent )
    --[[
        Immediately removes an entity from a system

        @arg Entity ent @ The entity to be removed

        @return self
    ]]
    if self:has(ent) then
        self:removed(ent)
        self.___group:remove(ent)
    end
    return self
end


-- Activates system
function System:activate( )
    --[[
        Activates a system

        @return self
    ]]
    self.active = true
    return self
end



function System:deactivate( )
    --[[
        Deactivates a system

        @return self
    ]]
    self.active = false
    return self
end







-- Callback for entity added to system
function System.added()
end
-- Callback for entity removed from system
function System.removed()
end



return setmetatable(System,
    {__call = System.new,
    __newindex = function()
        error("main table `System` is read-only")
    end,
    __metatable = "Defended Metatable"}
)












