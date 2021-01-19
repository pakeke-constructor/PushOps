


local PATH = (...):gsub('%.[^%.]+$', '')

local Cyan = {

}




local Entity = require(PATH..".ent")
local System = require(PATH..".system")

local WorldControl = require(PATH..".world")






-- Cyan.Entity(); entity ctor
Cyan.Entity = Entity

--Cyan.System(...); system ctor
Cyan.System = System





--[[
 core cyan management

]]



-- Depth is the call depth of a Cyan.call function.
-- It tracks the `depth` of the call so automatic flushing can be done on every root call.
local ___depth = 0
local func_backrefs = System.func_backrefs

do
    function Cyan.call(func_name,   a,b,c,d,e,f,g,h,i__)

        if i__ then
            -- THIS IS ONLY FOR DEBUGGING!!!! remove upon release !!!!
            error("Maximum number of arguments exceeded.")
        end
        
        if ___depth == 0 then
            Cyan.flush()
        end
        ___depth = ___depth + 1
        --[[
            Calls all systems with the given function. Alias: Cyan.emit

            @arg func @(
                The function name to be called
            )

            @arg ... @(
                Any other arguments sent in after will be passed to system.
            )

            @return Cyan @
        ]]
        local sys
        local Sys_backrefs = func_backrefs[func_name]
        for i = 1, Sys_backrefs.len do
            sys = Sys_backrefs[i]
            if sys.active then
                sys[func_name](sys, a,b,c,d,e,f,g,h)
            end
        end

        ___depth = ___depth - 1 -- Depth will be zero if and ONLY IF this call was a root call. (ie called from love.update or love.draw)
    end

    Cyan.emit = Cyan.call



    local non_static_sys_list = System.non_static_systems

    -- set of all entities
    local ___all = Entity.___all


    -- Flushes all entities that need to be deleted
    function Cyan.flush()
        --[[
            Removes all entities marked for deletion.

            @return Cyan@
        ]]
        local sys
        local remove_set_objs = Entity.___remove_set.objects
        local remove_set_len = Entity.___remove_set.size

        for i = 1, remove_set_len do
            local ent = remove_set_objs[i]
            
            -- The set of ALL entities
            ___all:remove(ent)

            for index = 1, non_static_sys_list.len do
                sys = non_static_sys_list[index]
                sys:remove(ent)
            end
        end
    end

    function Cyan.exists( entity )
        -- checks whether an entity exists, or if it has been deleted.
        return ___all:has(entity)
    end
end





--[[
    World management
    NEEDS TESTING!!!
]]
do
    function Cyan.setWorld(name)
        assert(name, "Cyan.setWorld requires a world name as a string!")
        return WorldControl:setWorld(name, Cyan)
    end

    function Cyan.getWorld()
        return WorldControl:getWorld()
    end

    function Cyan.clearWorld(name)
        assert(name, "Cyan.clearWorld requires a world name as a string!")
        return WorldControl:clearWorld(name, Cyan)
    end

    function Cyan.newWorld(name)
        assert(name, "Cyan.newWorld requires a world name as a string!")
        return WorldControl:newWorld(name, Cyan)
    end
end
--[[
]]


-- Default world is `main`
Cyan.newWorld("main")
Cyan.setWorld("main")








return setmetatable(Cyan, {__metatable = "Defended metatable"})




