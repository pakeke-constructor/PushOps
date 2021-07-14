


local items = require("src.misc.items.initialize")

local itemlist = {}

for itemname, item in pairs(items) do
    table.insert(itemlist, itemname)
end


return itemlist
