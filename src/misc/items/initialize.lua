

local items = Tools.req_TREE("src/misc/items/items", { })




local mt = require("src.misc.items.base")

for name, item in pairs(items)do
    --assert(not item.name, "Item :: <".. name .."> This field is disallowed, its gonna be over-written")
    item.name = name
    setmetatable(item, mt)
end


return items




