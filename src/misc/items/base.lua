

local mt = {__index = base}

local base = { }


local flags = require("src.misc.items.itemflags")

function base:_load(player)
    --[[
        Called whenever the player is instantiated
    ]]
    if self.load then
        self:load(player)
    end
end


function base:_reset(player)
    --[[
        Called upon :purge()
        (NOTE: THIS DOES NOT REMOVE THE UPGRADE)
    ]]
    if self.reset then
        self:reset(player)
    end
end


function base:_fullLoad(player)
    flags[self.name] = true
    if self.fullLoad then
        self:fullLoad(player)
    end
end


function base:_fullReset(player)
    flags[self.name] = false
    if self.fullReset then
        self:fullReset(player)
    end
end


return mt


