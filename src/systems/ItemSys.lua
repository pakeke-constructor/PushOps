
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

local flags = require("src.misc.items.itemflags")


local callbackGroups = setmetatable({},{__index = function(t,k)
    t[k] = {}
    return t[k]
end})


local Sets = require("src.misc.unique.sset_targets")


function ItemSys:giveItem( player, itemType )
    if flags[itemType] then
        return -- No duplicate items in this game
    end

    if not Items[itemType] then
        error("No item of type: "..itemType)
    end
    local item = Items[itemType]

    for _,v in ipairs(item.callbacks) do
        table.insert(callbackGroups[v], item)
    end

     -- See  src/misc/items for a better understanding.
    item:_load(player)
end



local callbacks = {
    "update";    -- Dont use update and draw unless we really need to
    --"draw";
    "heavyupdate";
    "boom";
    "moob";
    "splat";
    "kill";
    "damage";
--[[
    "load";    -- These callbacks are specific to items
    "reset";   -- (see src/misc/items)
    "fullLoad"; 
    "fullReset"
]]
}



--[[
    Give callback functions to system w/ closures
]]
for _, callback in ipairs(callbacks)do
    ItemSys[callback] = function(self, a,b,c,d,e)
        local player = self.group[1]
        if player then
            for _, ite in ipairs(callbackGroups[callback])do
                ite[callback](player, a,b,c,d,e)
            end
        end
    end
end



function ItemSys:finalizeWorld()
    for _, item in ipairs(callbackGroups.load) do
        if self.group[1] then
            local player = self.group[1]
            item:_load(player)
        end
    end
end


function ItemSys:purge()
    for _, item in ipairs(callbackGroups.load) do
        if self.group[1] then
            local player = self.group[1]
            item:_reset(player)
        end
    end
end



function ItemSys:resetItems()
    for _, key in ipairs(callbacks) do
        callbackGroups[key] = nil
    end
end


