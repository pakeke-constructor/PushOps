
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call

local tree = EH.Node("_tok ent behaviour")

local function playerColFunc(ent, player, dt)

end


return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    
    e.behaviour = {
        tree=tree
    }

    e.collisions = {
        area = {
            player = playerColFunc
        }
    }
end

