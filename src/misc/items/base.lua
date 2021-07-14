

local base = { }

local mt = {__index = base}



local flags = require("src.misc.items.itemflags")

function base:_load(player)
    --[[
        Called whenever the player is instantiated
    ]]
    if self.load then
        self.load(player)
    end
    flags[self.name] = true
end


function base:_reset(player)
    --[[
        Called upon :purge()
        (NOTE: THIS DOES NOT REMOVE THE UPGRADE)
    ]]
    if self.reset then
        self.reset(player)
    end
    flags[self.name] = false
end


return mt


