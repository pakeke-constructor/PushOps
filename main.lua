


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
    _G.Cyan = require "libs.Cyan.Cyan"

    --[[ heres something real dumb :  
    local Ent = Cyan.Entity
    _G.Cyan.Entity = function()
        return Ent()
        -- hahahhahaha
        :add("rot", love.math.random()*2*math.pi)
        :add("avel", love.math.random()/20)
    end
    --]]

    _G.ccall = _G.Cyan.call -- quality of life

    _G.Tools = require"libs.tools.tools"

    -- math lib additions
    _G.math.vec3  = require "libs.math.NM_vec3"
    _G.math.dot   = require "libs.math.dot"
    _G.math.roman = require "libs.math.NM_roman" -- roman numeral converter

    _G.table.copy = require "libs.tools.copy"
    _G.table.shuffle = require "libs.NM_fisher_yates_shuffle.shuffle"
    require("libs.NM_stable_sort.sort"):export() -- exports to `_G.table`

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



-- Entity construction helper functions / util
rawset(_G, "EH", require 'src.entities._EH')



-- Load fennel transpiler
local fennel = require("libs.NM_fennel.fennel")
table.insert(package.loaders or package.searchers, fennel.searcher)



require("src.systems._SYSTEMS")

require("src.entities")

require("src.misc._MISC")

print(("We got %d bits left in compbitbase"):format(Cyan.getFreeBits()))

Tools.assertNoDuplicateRequires()


