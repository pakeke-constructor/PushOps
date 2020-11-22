
local DrawSys = Cyan.System("pos", "draw")
--[[

Main drawing system.

Will emit draw calls based on position, and in correct order.


]]



local Tools = _G.Tools
local PATH = Tools.Path(...)
local Set = require ("libs.tools.sets")
local floor = math.floor

local effect = require("src.misc.unique.shader_effect")

local push = require("libs.NM_push.push")

--[[push:setupScreen(
    love.graphics.getWidth()/3, 
    love.graphics.getHeight()/3,

    love.graphics.getWidth(),
    love.graphics.getHeight(), 
    {fullscreen = false, pixelperfect=false}
)]]




-- Ordered drawing data structure
local Indexer = setmetatable({},
    --[[
        each pixel is represented by a set in Indexer.
        So, doing Indexer[floor(ent.pos.y + ent.pos.z)] will get the set that holds ent.
    ]]
    {__index = function(t, k)
        t[k] = Set()
        return t[k]
    end}
)

-- This table holds Entities that point to `y+z` values that ensure that
-- Entities in Indexer can always be found.  (y+z positions are updated only when system is ready.)
local positions = {}



local Indexer_max_depth = 0
local Indexer_min_depth = 0

local min = math.min
local max = math.max



local set, add, get, remove
do
    function add(ent)
        --[[
            Adds entity to Indexer
        ]]
        local zindx = floor((ent.pos.y + ent.pos.z)/2)
        Indexer[zindx]:add(ent)
        Indexer_max_depth = max(Indexer_max_depth, zindx)
        Indexer_min_depth = min(Indexer_min_depth, zindx)
    end
    function get(ent)
        --[[
            Returns position in Indexer of ent.
        ]]
        return positions[ent]
    end
    function remove(ent)
        --[[
            Removes entity from previous Indexer location.
        ]]
        Indexer[get(ent)]:remove(ent)
    end
    function set(ent)
        --[[
            Sets current position of entity in Indexer, to give system awareness
            of what location ent is currently in in Indexer sets.
        ]]
        positions[ent] = floor((ent.pos.y + ent.pos.z)/2)
    end
end



function DrawSys:added( ent )
    -- Callback for entity addition
    set(ent)
    add(ent)

end



function DrawSys:removed( ent )
    -- Callback for entity removal
    remove(ent)
    positions[ent] = nil
end







local C_call = Cyan.call
local lg = love.graphics

local getW = love.graphics.getWidth
local getH = love.graphics.getHeight

local rawget = rawget
local ipairs = ipairs

local draw_master = function()

    --push:start()
    lg.setColor(0.4,1,0.4) -- green grass
    lg.rectangle("fill", 0, 0, getW(), getH())
    lg.setColor(1,1,1)

    C_call("transform")
        
    local indx_set

    for z_dep = Indexer_min_depth, Indexer_max_depth do
        if rawget(Indexer, z_dep) then
            indx_set = Indexer[z_dep]
            for _, ent in ipairs(indx_set.objects) do
                if not ent.hidden then
                    C_call("drawEntity", ent)
                end
            end
        end
        C_call("drawIndex", z_dep)
    end

    C_call("untransform")
    -- push:finish()
end


function DrawSys:draw()
    effect.draw(
        draw_master
    )
end











local IndexSys = Cyan.System("pos", "draw", "vel")


function IndexSys:update()
    for _, ent in ipairs(self.group) do
        remove(ent)
        set(ent)
        add(ent)
    end
end





