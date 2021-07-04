

local playables = {}

Tools.req_TREE("src/misc/playables/playables",playables)



local base_mt = require("src.misc.playables.base")



for k,v in pairs(playables)do
    setmetatable(v, base_mt)
    v.type = k
    v.super = base_mt.__index -- base table
    v:initialize()
end


return playables

