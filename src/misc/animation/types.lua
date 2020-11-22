

local PTH = Tools.Path(...)

local AnimCtor = require(PTH..".anim_base")

--[[

Each lua file in `_types` should return a list of quads,
that each serve as frames for each animation object.

This file will construct each animation object 
from Anim:new( type, frames ).

]]

local AnimTypes = { }
Tools.req_TREE(PTH:gsub("%.", "/").."/_types", AnimTypes)


for typename, frames in pairs(AnimTypes) do
    AnimTypes[typename] = AnimCtor({ }, typename, frames)
end

return AnimTypes

