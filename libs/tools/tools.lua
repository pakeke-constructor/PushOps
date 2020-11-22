

local T = {}




T.set = require "libs.tools.sets"


local rand = love.math.random
local floor = math.floor


T.dist = function(x, y)
    return (x^2 + y^2)^0.5
end

T.edist = function(e1, e2)
    return (e1.pos - e2.pos):len()
end

T.rand_choice = function(t)
    return t[floor(rand(1, #t))]
end

T.dot = function(x1,y1,x2,y2)
    return (x1*x2) + (y1*y2)
end

T.Path = function(str)
    return str:gsub('%.[^%.]+$', '')
end

local this_pth = T.Path(...)

T.req_TREE = require(this_pth .. ".req_TREE")

T.weighted_selection = require("libs.tools.weighted_selection")


T.deepcopy = function( tabl, shove )
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




return T