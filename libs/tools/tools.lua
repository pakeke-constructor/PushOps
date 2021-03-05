

local Tools = {}




Tools.set = require "libs.tools.sets"


local rand = love.math.random
local floor = math.floor


Tools.dist = function(x, y)
    return (x^2 + y^2)^0.5
end

Tools.edist = function(e1, e2)
    return (e1.pos - e2.pos):len()
end

Tools.rand_choice = function(Tools)
    return Tools[floor(rand(1, #Tools))]
end

Tools.dot = function(x1,y1,x2,y2)
    return (x1*x2) + (y1*y2)
end

Tools.Path = function(str)
    return str:gsub('%.[^%.]+$', '')
end

local this_pth = Tools.Path(...)

Tools.req_TREE = require(this_pth .. ".req_TREE")

Tools.weighted_selection = require("libs.tools.weighted_selection")


Tools.deepcopy = function( tabl, shove )
    local new = {}
    shove = shove or {[tabl] = tabl}

    for ke, val in pairs(tabl) do
        if type(val) == "table" then
            if shove[val] then
                new[ke] = val
            else
                shove[val] = val
                new[ke] = deepcopy(val, shove)
            end
        elseif type(val) == "userdata" then
            if val.clone then
                new[ke] = val:clone() -- love2d
            else
                error "userdata cannot be deepcopied; requires a :clone() method"
            end
        else
            new[ke] = val
        end
    end

    return setmetatable(new, tabl)
end

do
    local blocked=false
    local ccall = Cyan.call

    local function setClosureTrue()
        -- I don'Tools like this. But there is no other way :/
        blocked = true
        return 0
    end

    function Tools.isBlocked(x, y)
        -- returns whether the x,y position is blocked.
        ccall("boxquery",x,y, setClosureTrue)
        local ret = blocked
        blocked = false -- We start by assuming its not blocked.
        return ret        
    end

    function Tools.isIntersect(x1, y1, x2, y2)
        -- returns whether the line segment (x1,y1) -> (x2,y2)
        -- intersects with a solid fixture in the physics world.
        ccall("rayquery", x1,y1, x2,y2, setClosureTrue)
        local ret = blocked
        blocked = false
        return ret
    end
end

local getWidth, getHeight = love.graphics.getWidth, love.graphics.getHeight
local RANGE_LEIGHWAY = 300

function Tools.isOnScreen(e, cam)
    --[[
        Is the ent close to being on screen?
        
        -> Also- ensure you do this oli:
            Physics bodies are turned off with this function.
            its your job to ensure that behaviour trees and 
            ents applied thru MoveBehaviourSys are turned off as
            well, so we dont get idiots getting stuck in walls
    ]]
    local w,h = getWidth(), getHeight()
    local p=e.pos
    local x,y
    x,y = cam:toCameraCoords(p.x, p.y)
    return (-RANGE_LEIGHWAY < x) and (x < w+RANGE_LEIGHWAY)
    and (-RANGE_LEIGHWAY < y) and (y < h + RANGE_LEIGHWAY)
end


function Tools.distToPlayer(e, cam)
    assert(cam, "Not given camera object! Tools.distToPlayer( ent, camera ) ")
    return Tools.dist(e.pos.x - cam.x, e.pos.y - cam.y)
end




function Tools.assertNoDuplicateRequires()
    local cache = {}
    for k,v in pairs(package.loaded) do
        if cache[k:lower()] then
            error("DUPLICATE LUA FILE IN PACKAGE.LOADED:  "..k)
        end
        cache[k:lower()]=k
    end
end


return Tools


