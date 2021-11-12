

local Tools = {}




Tools.set = require "libs.tools.sets"


local rand = love.math.random
local floor = math.floor
local sqrt = math.sqrt

Tools.dist = function(x, y)
    return sqrt(x*x + y*y)
end

Tools.edist = function(e1, e2)
    return (e1.pos - e2.pos):len()
end

Tools.rand_choice = function(tab)
    return tab[floor(rand(1, #tab))]
end
Tools.random_choice = Tools.rand_choice -- alias

Tools.dot = function(x1,y1,x2,y2)
    return (x1*x2) + (y1*y2)
end

Tools.Path = function(str)
    return str:gsub('%.[^%.]+$', '')
end


local MAX_TIME = 0xfffffffffe

function Tools.totime(seconds)
    if seconds > MAX_TIME or seconds == 0 then
        return "None"
    end
    -- converts seconds to a readable minute: second format.
    return tostring(math.floor(seconds / 60)) .. ":" .. tostring(math.floor(seconds % 60))
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



local lg = love.graphics
local WHITE = {1,1,1,1}
local font = require("src.misc.unique.font")

function Tools.drawText(txt, center_x, center_y, colour, background)
    --[[
        background is a colour
    ]]
    colour = colour or WHITE

    local ox = font:getWidth(txt) / 2
    local oy = font:getHeight() / 2

    if background then
        lg.setColor(background)
        lg.rectangle("fill", center_x - 2 - ox, center_y - 2 - oy, ox*2 + 4,oy*2 + 4)
    end

    lg.setColor(colour)
    lg.print(txt, center_x - ox, center_y - oy)
end



local getWidth, getHeight = love.graphics.getWidth, love.graphics.getHeight
local RANGE_LEIGHWAY = 700 -- had to do higher, on Matt's computer it was weird.

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
    local p = e.pos
    local x,y
    x,y = cam:toCameraCoords(p.x, p.y)
    return (-RANGE_LEIGHWAY < x) and (x < w+RANGE_LEIGHWAY)
    and (-RANGE_LEIGHWAY < y) and (y < h + RANGE_LEIGHWAY)
end


function Tools.isInvincible(ent)
    if not ent.hp then
        return true
    elseif ent.hp.iframe_count and ent.hp.iframe_count > 0 then
        return true
    end
    return false
end


function Tools.distToPlayer(e, cam)
    assert(cam, "Not given camera object! Tools.distToPlayer( ent, camera ) ")
    return Tools.dist(e.pos.x - cam.x, e.pos.y - cam.y)
end


function Tools.getCameraPos(cam)
    return cam.x, cam.y
end



function Tools.assertNoDuplicateRequires()
    local cache = {}
    for k,v in pairs(package.loaded) do
        if cache[k:lower():gsub("%/",".")] then
            error("DUPLICATE LUA FILE IN PACKAGE.LOADED:  "..k)
        end
        cache[k:lower():gsub("%/",".")]=k
    end
end



local inspect = require("libs.NM_inspect.inspect")

-- clear dump file
local tdump = love.filesystem.newFile("T_DUMP.txt", "w")
tdump:write("")
tdump:flush()
tdump:close()

function Tools.dump(e, str)
    f = love.filesystem.newFile("T_DUMP.txt", "w")

    if str then
        f:write(str)
    end
    f:write("\nlua tostring::" .. tostring(e) .. "\n")
    f:write(inspect(e))

    f:flush()
    f:close()
end

return Tools


