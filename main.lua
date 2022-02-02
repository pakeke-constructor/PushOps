
--[[


How to push to github:


git add .
git commit -m"Message here"
git push origin master


]]


_G.love.graphics.setDefaultFilter("nearest", "nearest")

-- Globals here:
setmetatable(_G, {})


do
    -- main ECS
    _G.Cyan = require "libs.Cyan.Cyan"

    _G.ccall = _G.Cyan.call -- quality of life

    _G.Tools = require"libs.tools.tools" -- Tools

    _G.CONSTANTS = require"src.misc._CONSTANTS"
end


-- End globals, (Except EH, few lines down.)
setmetatable(_G, {
    __newindex = function(_,k) error("DONT MAKE GLOBALS :: " .. tostring(k)) end,
    __index = function(_,k)
        error("UNDEFINED VAR :: " .. tostring(k))
    end,
    __metatable = "defensive"
})


-- These aren't globals, but they are mutating the standard library
-- So im gonna put em here.

-- Mutate table library:
table.copy = require "libs.tools.copy"
table.shuffle = require "libs.NM_fisher_yates_shuffle.shuffle"
require("libs.NM_stable_sort.sort"):export() -- exports to `_G.table`

-- Mutate math library:
math.vec3  = require "libs.math.NM_vec3"
math.dot   = require "libs.math.dot"
math.roman = require "libs.math.NM_roman" -- roman numeral converter



-- load steam module
local success, luasteam = pcall(require, "luasteam")
if success then
    rawset(_G, "luasteam", luasteam)
    luasteam.init()
else
    rawset(_G, "luasteam", false)
end



-- Entity construction helper functions / util
rawset(_G, "EH", require 'src.entities._EH')


require("src.systems._SYSTEMS")

require("src.entities")

require("src.misc._MISC")

--print(("We got %d bits left in compbitbase"):format(Cyan.getFreeBits()))

Tools.assertNoDuplicateRequires()


