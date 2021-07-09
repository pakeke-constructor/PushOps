
--[[

A pillar that provides a player
selection interface

]]

local atlas = require("assets.atlas")
local savedata = require("src.misc.unique.savedata")
local playables = require("src.misc.playables.initialize")

local Quads = atlas.Quads


local function isOwned(self)
    return savedata.owned_players[self.playerType]
end


local function onInteract(self, player, type)
    if type == "push" then
        if isOwned(self) then
            -- Then the player owns this character
            ccall("switchPlayer", self.playerType)
            --TOOD: play sound here; give feedback
            ccall("sound","poof")
            local x,y = player.pos.x, player.pos.y
            for i=-1,1 do
                for j=-1,1 do
                    ccall("emit", "dust", x + i*10, y + j*10, 0, 4)
                end
            end
            return true
        else
            -- Else, provide interface to unlock
            if not self.playerCost then
                error("player pillar type: " .. (tostring(self.playerType)) .. " not given a cost")
            end
            
            if savedata.tokens >= self.playerCost then
                -- TODO: add feedback when player unlocks and cant afford, etc
                savedata.owned_players[self.playerType] = true
                savedata.tokens = savedata.tokens - self.playerCost
                if self._cost_text then
                    ccall("kill", self._cost_text)
                end
                return true
            else
                -- TODO: feedback, player cannot afford
            end
        end
    end
end


local function onDraw(self)
    if not self.playerType then
        error("not given playerType")
    end
    if not self.playerPillarImage then
        error("player pillar: " .. (tostring(self.playerType)) .. " not given quad")
    end
    if not self.unownedPillarImage then
        error("player pillar: " .. (tostring(self.playerType)) .. " not given unowned quad")
    end
    if not playables[self.playerType] then
        error("player pillar: unknown playable playerType: "..tostring(self.playerType))
    end

    if isOwned(self) then
        local _,_,qw, qh = self.playerPillarImage:getViewport()
        atlas:draw(self.playerPillarImage, self.pos.x, self.pos.y - 32,
                    0,1,1,qw/2,qh/2)
    else
        -- Is unowned!
        local _,_,qw, qh = self.unownedPillarImage:getViewport()
        atlas:draw(self.unownedPillarImage, self.pos.x, self.pos.y - 32,
                    0,1,1,qw/2,qh/2)
        if (not self._cost_text) and self.playerCost then
            -- Construct cost text
            
            -- HAD TO DO A SHITTY Z POSITION HACK. So stupid, oh well
            self._cost_text = EH.Ents.txt(self.pos.x, self.pos.y, "$"..tostring(self.playerCost), 40)
            self._cost_text.colour = {0.25,0.3,0.25}
        end
    end
end



return function(x,y)
    --[[
    this entity will have multiple special fields:

     .playerType    the type as a string, see  src/misc/playables
     .playerPillarImage  references a quad to draw (when owned)
     .unownedPillarImage  reference a quad to draw (unowned.)
     .playerCost     the token cost to unlock this player type

     ._cost_text     a text ent that this entity will use, to display cost
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

