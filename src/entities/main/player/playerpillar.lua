
--[[

A pillar that provides a player
selection interface

]]

local atlas = require("assets.atlas")
local Quads = atlas.Quads


local function onInteract(self, player, type)
    if type == "push" then
        ccall("switchPlayer", self.playerType)
        --TOOD: play sound here; give feedback
        return true
    end
end


local function onDraw(self)
    if not self.playerPillarImage then
        error("player pillar type: " .. (tostring(self.playerType)) .. " not given image")
    end
    local _,_,qw, qh = self.playerPillarImage:getViewport()
    atlas:draw(self.playerPillarImage, self.pos.x, self.pos.y - 32,
                0,1,1,qw/2,qh/2)
end



return function(x,y)
    --[[
    this entity will have a .playerType field
    that will hold the playertype to transfer to,
    and also a .playerPillarImage that references a quad to draw 
    ]]
    local pillar = Cyan.Entity()
    :add("pos",math.vec3(x,y,0))
    :add("image", Quads.pillar2)
    EH.PHYS(pillar,6,"static")

    pillar:add("targetID","interact")
    :add("onInteract", onInteract)

    :add("onDraw", onDraw)
    :add("hybrid",true)
    :add("size",50)
    EH.BOB(pillar)
    return pillar
end

