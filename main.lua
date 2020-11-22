

_G.love.graphics.setDefaultFilter("nearest", "nearest")




-- MONKEY BUSINESS STARTS HERE !!!
setmetatable(_G, {})
do
    _G.Cyan = require "libs.Cyan.cyan"

    _G.Tools = require"libs.tools.tools"

    _G.math.vec3 = require "libs.math.vec3"
    _G.math.dot  = require "libs.math.dot"

    -- Entity construction helper functions. (NYI)
    _G.EH = {    }

    _G.CONSTANTS = require"src.misc._CONSTANTS"
end
-- NO MORE MONKEY BUSINESS PAST THIS POINT !!!




setmetatable(_G, {
    __newindex = function(_,k) error("DONT MAKE GLOBALS :: "..k) end,
    __index = function(_,k) error("UNDEFINED VAR :: "..k) end
})


require("src.systems._SYSTEMS")

require("src.entities._ENTITIES")

require("src.misc._MISC")


