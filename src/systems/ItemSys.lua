
local ItemSys = Cyan.System("control")

--[[
Okay, Items are kept in a list.

When player relocates to menu, 
the Items are cleared.

Each `upgrade object` is just a table with
functions attached to optional callbacks.
\
]]

local Items = require("src.misc.items.initialize")
local current = {}

function ItemSys:giveUpgrade( upgradeType )
    assert(Items[upgradeType])
    table.insert(current, upgradeType)
end



local callbacks = {
    --"update";    -- Dont use update and draw unless we really need to
    --"draw";
    "heavyupdate";
    "boom";
    "moob";
    "splat";
    "kill";
    "damage"
}


for _, callback in ipairs(callbacks)do
    ItemSys[callback] = function(self, a,b,c,d,e)
        for _, ite in ipairs(current)do
            if ite[callback] then
                ite[callback](player, a,b,c,d,e)
            end
        end
    end
end

