

--@object Entity
--[[
    Entities in Cyan only hold data.  (commonly called "Components")
    The data that an entity holds will determine what systems it gets into.

    For example, an Entity with "pos", "blah", "image", and "health" components
    would get accepted into a system accepting Entities with ("pos", "health")
    components; because it has "pos" and "health".

    You do not need to worry about adding entities to systems; it is done
    automatically.
]]




local PATH = (...):gsub('%.[^%.]+$', '')
local set = require(PATH..".sets")
local array = require(PATH..".array")

local ffi, newmask
do
    if jit and jit.status() and false then -- We can't use this because luaJIT doesn't
        ffi = require "ffi"                -- support bitops in this version.
    end
    if ffi then
        basemask = bit.tobit(ffi.new("long", 0)) -- the bit mask that is assigned to each component.
    else
        -- unfortunetely no FFI
        basemask = bit.tobit(0)
    end
end


local System = require (PATH..".system")
local comp_backrefs = System.comp_backrefs


local Entity = {
    --[[
        ___component_check is a read only field that tells
        Cyan whether to do assertions of components;
        by default is set to false.

        To set it to true, call Cyan.setComponents, and pass
        in a table of keyed-components pointing to true.
    ]]
    ___remove_set = set()
    ;
    -- A list of user-defined types for fast entity construction.
    ___types = { }
    ;
    -- A set of ALL entities
    ___all = set()
}





local Entity_mt
local er_1
do
    er_1 = "Attempted to add uninitialized component to entity.\nPlease initialize components in Cyan.components before use."

    Entity_mt = {
        __index = Entity
        ;
        __newindex = function(t, k, v)
            t:add(k, v)
        end
        ;
        -- Defend metatable
        __metatable = "Defended Metatable!!"
    }
end


local Sys_comp_bits = System.component_bits
local bit_bnot = bit.bnot
local bit_bor = bit.bor
local bit_band = bit.band

local function modmask(ent, comp_name)
    -- modifies byte mask
    ent.___mask = bit_bor(ent.___mask, Sys_comp_bits[comp_name])
end

local function demodmask(ent, comp_name)
    ent.___mask = bit_band(
        ent.___mask, bit_bnot( Sys_comp_bits[comp_name] )
    )
end


-- CTOR
function Entity:new()
    --[[
        @return Entity entity@
    ]]
    local ent = {
        ___mask = basemask * 1 -- Multiply by 1 to create memory unique copy
    }
    Entity.___all:add( ent )
    return setmetatable(ent, Entity_mt)
end




function Entity:has( comp_name )
    --[[
        Gets whether the entity has a component or not.

        @arg string comp_name @(
            The component name, as a string
        )

        @return bool @ True if entity has component, else false
    ]]
    return ((rawget(self, comp_name) and true) or false)
end



local comp_bits = System.component_bits
-- Adds component to entity
function Entity:add( comp_name, comp_val )
    --[[
        Adds a component to an entity and adds to new respective systems

        @arg string comp_name @ The name of the component
        @arg comp_value @ Value of the component, can be anything.

        @return self
    ]]
    assert(comp_backrefs[comp_name], er_1)
    
    -- modify byte mask, but only if the component is required for systems.
    if comp_bits[comp_name] then
        modmask(self, comp_name)
    end

    -- need to check before it is added.
    local has = self:has(comp_name)

    rawset(self, comp_name, comp_val)

    -- Checks if component is new, and not an overide. If so, will send to systems;
    if not has then
        self:_send_to_systems( comp_name )
    end

    return self
end







-- adds component to entity without invoking any system search.
function Entity:rawadd( comp_name, comp_value )
    --[[
        Adds a component to an entity WITHOUT adding to any systems

        @arg string comp_name @ The name of the component
        @arg comp_value @ Value of the component, can be anything.

        @return self
    ]]
    assert(comps_backrefs[comp_name], er_1)
    rawset(self, comp_name, comp_value)

    return self
end







-- Immediately destroys entity component and removes from systems.
-- (Does not account for whether it's safe or not.)
function Entity:remove( comp_name )
    --[[
        Immediately destroys entity component and removes from relevant systems.
        Does not account for whether it is safe.

        @arg string comp_name @ The name of the component to be removed

        @return self
    ]]
    self[comp_name] = nil

    for i=1, comp_backrefs[comp_name].len do
        local sys = comp_backrefs[comp_name][i]
        sys:remove(self)
    end

    demodmask(self, comp_name)

    return self
end




-- Deletes component without removing from systems
function Entity:rawremove( comp_name )
    --[[
        Immediately destroys entity component WITHOUT removing from systems.

        @arg string comp_name @ The name of the component to be removed

        @return self
    ]]
    self[comp_name] = nil

    demodmask(ent, comp_name)

    return self
end





function Entity:delete()
    --[[
        Marks the entity for deletion
        Entity will be deleted the next time Cyan.flush() is called

        @return self
    ]]
    Entity.___remove_set:add(self)

    return self
end

Entity.destroy = Entity.delete -- alias





--
-- SENDING ENT TO SYSTEMS
--
-- GETTING ENT SYSTEMS
--
do
    -- Gets all the systems the entity needs to be added to
    -- upon recieving given component
    function Entity:_get_systems( comp )

        local getted_systems = { }

        -- TODO: change this to bitops.
        for i=1, comp_backrefs[comp].len do
            local sys = comp_backrefs[comp][i]
            if sys:worthy(self) then
                table.insert(getted_systems, sys)
            end
        end

        return getted_systems
    end

    
    function Entity:_send_to_systems(comp)

        for i=1, comp_backrefs[comp].len do
            local sys = comp_backrefs[comp][i]
            if sys:worthy( self ) then
                -- Adds entity to system (passed all requirements)
                sys:add(self)
            end
        end
    end


    -- Gets all systems of Entity:
    -- VERY SLOW OPERATION! O(n^2)
    -- Also high space complexity; O(n) garbage-sets created.
    function Entity:_get_all_systems()

        -- TODO: change to bitops
        local systems = set()
        local comps = array()

        for comp, _ in pairs(self) do
            comps:add(comp)
        end

        for _, comp in ipairs(comps) do
            local sys_tabl = self:_get_systems(comp)
            for _, sys in ipairs(sys_tabl) do
                systems:add(sys)
            end
        end

        return systems.objects
    end

    Entity.getSystems = Entity._get_all_systems
end





return setmetatable(Entity,
    {__call = Entity.new,
    __newindex = function()
        error("main table `Entity` is read-only")
    end,
    __metatable = "Defended metatable"}
)





