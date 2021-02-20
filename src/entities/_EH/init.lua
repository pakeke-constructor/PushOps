

local EH={ 
    --[[

Entity constructor helper functions.

Most of these have relatively small names,
in order to keep coding entities fast and easy and concise.

    ]]
}

local vec3=math.vec3
function EH.PV(e,x,y,z)
    -- position : velocity comp adding/
    return e:add("pos",vec3(x,y,z or 0))
        :add("vel",vec3(0,0,0))
end



local PATH = Tools.Path(...)
local basePsys = require(PATH.."._EH.basePsys")

function EH.FR(e)
    --[[
        Standard friction component
    ]]
    return e:add("friction", {
        amount = 6; -- The amount of friction given to this entity
        emitter = basePsys:clone();
        required_vel = 10;
    })
end


function EH.BOB(e)
    return e:add("bobbing",{
        magnitude = 0.1;
        value=0
    })
end


local circleShapes = {
    -- cache circle shape (love.physics) objects
    -- so we don't construct duplicates with same radius.
}


function EH.PHYS(e, rad, type)
    -- default type: dynamic (but could be "kinematic" or "static")
    if not circleShapes[rad] then
        circleShapes[rad] = love.physics.newCircleShape(rad)
    end
    e:add("physics",{
        shape = circleShapes[rad];
        body = (type or "dynamic") -- (dynamic, static, kinematic)
    })
    return e
end


function EH.PC(e1,e2,speed)
    --[[
        default physics collision function.
        Entity takes damage from a source and makes a `hit` noise
    ]]
    if speed > CONSTANTS.ENT_DMG_SPEED then
        ccall("sound", "thud")
        if e1.vel then
            ccall("damage", e1, (speed - e1.vel:len()))
        else
            ccall("damage",e1,speed)
        end
    end
end


Tools.req_TREE('src/misc/behaviour/tasks')


local PROXY = { }
EH.entities = setmetatable({___PROXY = PROXY}, {__newindex = function(t,k,v)
    if rawget(PROXY,k) then
        error("Entity file already had the name : "..k .. ". Duplicate names not allowed!")
    end
    rawset(PROXY,k,v)
end})




EH.BT   = require("libs.BehaviourTree")
EH.Node = require("libs.BehaviourTree").Node
EH.Task = require("libs.BehaviourTree").Task


EH.Quads = require("assets.atlas").Quads
EH.Atlas = require("assets.atlas")

return EH

