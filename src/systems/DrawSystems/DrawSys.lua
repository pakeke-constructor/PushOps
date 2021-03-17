
local DrawSys = Cyan.System("pos", "draw")
--[[

Main drawing system.

Will emit draw calls based on position, and in correct order.


]]



local Tools = _G.Tools
local PATH = Tools.Path(...)
local Set = require ("libs.tools.sets")
local floor = math.floor
local Atlas = require("assets.atlas")

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


-- a Set for all shockwave objects that are being drawn
local ShockWaves = Tools.set()





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
        local gett = get(ent)
        Indexer[gett]:remove(ent)
        return gett
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
    ent.draw = nil
end




function DrawSys:update(dt)
    for _,sw in ipairs(ShockWaves.objects)do
        sw:update(dt)
        if sw.isFinished then
            ShockWaves:remove(sw)
            sw.colour = nil -- easier on GC
        end
    end
end




local ccall = Cyan.call
local lg = love.graphics

local getW = love.graphics.getWidth
local getH = love.graphics.getHeight

local rawget = rawget
local ipairs = ipairs

local camera = require("src.misc.unique.camera")
local drawShockWaves


local draw_master = function()
    local setColor = lg.setColor
    local isOnScreen = Tools.isOnScreen

    ccall("transform")
    
    setColor(CONSTANTS.GRASS_COLOUR)
    local w,h = getW(), getH()
    local camx, camy = camera.x, camera.y
    lg.rectangle("fill", 0,0, 9000,5000)

    setColor(1,1,1)

    local indx_set

    for z_dep = Indexer_min_depth, Indexer_max_depth do
        if rawget(Indexer, z_dep) then
            indx_set = Indexer[z_dep]
            for _, ent in ipairs(indx_set.objects) do
                if isOnScreen(ent, camera) then
                    setColor(1,1,1)
                    if not ent.hidden then
                        if ent.trivial then
                            ccall("drawTrivial", ent)
                        else
                            if ent.colour then
                                setColor(ent.colour)
                            end
                            ccall("drawEntity", ent)
                        end
                    end
                end
            end
        end
        ccall("drawIndex", z_dep)
    end

    Atlas:flush( )

    drawShockWaves()

    ccall("untransform")
end


function DrawSys:draw()
    draw_master()
    
    lg.push()
    lg.scale(camera.scale)
    ccall("drawUI")
    lg.pop()
end





local newShockWave = require("src.misc.unique.shockwave")

function DrawSys:shockwave(x, y, start_size, end_size, thickness, time, colour)
    local sw = newShockWave(x,y,start_size, end_size, thickness, time, colour or {1,1,1,1})
    ShockWaves:add(sw)
end

function drawShockWaves()
    for _,sw in ipairs(ShockWaves.objects) do
        sw:draw(  )
    end
end










local IndexSys = Cyan.System("pos", "draw", "vel")



local function fshift(ent)
    --[[
        shifts the entities around in the indexer structure
        in a fast manner
    ]]
    local z_index = floor((ent.pos.y + ent.pos.z)/2)
    if positions[ent] ~= z_index then
        remove(ent)
        set(ent)
        add(ent)
    end
end

function IndexSys:update()
    for _, ent in ipairs(self.group) do
        fshift(ent)
    end
end





