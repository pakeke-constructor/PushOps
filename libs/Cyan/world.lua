




local PATH = (...):gsub('%.[^%.]+$', '')

local set = require(PATH..'.sets')
local array = require(PATH..".array")



-- World control table.
local WorldControl = {

    current_world = "NONE"
    ;
    current_world_name = "NONE"
    ;
    worlds = {}
}




function WorldControl:setWorld(name, cyan)
    --[[
        Sets current world to the world with name `name`,
        if `name` does not exist, creates a new world as `name`.
    ]]
    self.current_world = name
    self.current_world_name = name
    self.worlds[name] = self.worlds[name] or WorldControl:newWorld(name, cyan)

    local world = self.worlds[name]

    -- world.systems data structure is weird, a bit spagetti like:
    --[[
        world.systems is a table holding all system objects as keys,
        and `sets` as values. The sets correspond to this world's ___groups
        for that particular system.
    ]]
    for sys, group in pairs(world.systems) do
        sys.___group = group
    end
end




function WorldControl:newWorld(name, cyan)
    --[[
        Makes new world with name `name`
    ]]

    -- Checking for no mem leak
    do
        local num_worlds = #self.worlds + 1
        if num_worlds > 30 then
            error'You have created over 30 worlds... Are you sure you need that many? Or is this a memory leak'
        end
    end

    local world = {
        systems = {};
        types = {}
    }
    self.worlds[name] = world

    local systems = cyan.System.systems

    -- Add all systems to world
    for _, sys in ipairs(systems) do
        -- Create new group for each system.
        world.systems[sys] = set()
        -- When changed world, set this system's group to this worlds' system's group.
    end

    return name
end




function WorldControl:getWorld()
    --[[
        returns string name of world in use.
    ]]
    return self.current_world_name
end




function WorldControl:clearWorld(name, cyan)
    --[[
        Clears all system groups for this world, and envokes a flush

        Heavy function, pretty high complexity I think
    ]]
    name = name or self:getWorld()
    local world = self.worlds[name]
    assert(world, "Attempted to clear a world that didn't exist!")

    for sys, group in pairs(world.systems) do
        group:clear()
    end

    local current_world = self:getWorld()

    -- Must envoke flush under the world that is going to be flushed
    self:setWorld(name)
    cyan.flush()
    self:setWorld(current_world)

end








return setmetatable(WorldControl,
    {__newindex = function()
        error("Hey this guy is read only")
    end;
    __metatable = "topolololology"
    }
)


