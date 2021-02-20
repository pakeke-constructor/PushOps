
--[[


How to push to github:


git add .
git commit -m"Message here"
git push origin master


]]



_G.love.graphics.setDefaultFilter("nearest", "nearest")



-- MONKEY BUSINESS STARTS HERE !!!
setmetatable(_G, {})
do
    -- main ECS
    _G.Cyan = require "libs.Cyan.cyan"
    _G.ccall = _G.Cyan.call -- quality of life

    _G.Tools = require"libs.tools.tools"

    -- math lib additions
    _G.math.vec3 = require "libs.math.NM_vec3"
    _G.math.dot  = require "libs.math.dot"

    -- Entity construction helper functions / util
    _G.EH = require 'src.entities._EH'

    _G.CONSTANTS = require"src.misc._CONSTANTS"
end



-- NO MORE MONKEY BUSINESS PAST THIS POINT !!!

setmetatable(_G, {
    __newindex = function(_,k) error("DONT MAKE GLOBALS :: " .. tostring(k)) end,
    __index = function(_,k)
        if k==nil or k=="_ENV" then
            -- Fennel uses weird _G keys in compiling.
            -- Not gonna risk monkeypatch.
            return nil
        end
        error("UNDEFINED VAR :: " .. tostring(k))
    end,
    __metatable = "defensive"
})



-- Load fennel transpiler
local fennel = require("libs.NM_fennel.fennel")
table.insert(package.loaders or package.searchers, fennel.searcher)
-- Load macros first.
require("src.misc.unique.usrMacros")



require("src.systems._SYSTEMS")

require("src.entities")

require("src.misc._MISC")

Tools.assertNoDuplicateRequires()
