

local items = Tools.req_TREE("src/misc/items/items", { })




local mt = require("src.misc.items.base")

for name, item in pairs(items)do
    --assert(not item.name, "Item :: <".. name .."> This field is disallowed, its gonna be over-written")
    item.name = name
    setmetatable(item, mt)

    item.callbacks = { } -- A list of string denoting callback names that 
                        -- this item tags into

    for k,v in pairs(item) do
        if type(v) == "function" then
            table.insert(item.callbacks, k)
        end
    end
end


return items

