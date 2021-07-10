
--[[

This is a terrible way to do this tbh man.

TODO:
find a way to deconstruct and reconstruct rather than
mutating all these dumb fields!


]]

local function physColFunc(ent, your_dead, speed)
    if your_dead.hp then
        ccall("damage", your_dead, 0xffffffffffffffff)
        if your_dead.hp.hp <= 0 then
            local x, y, z = ent.pos.x, ent.pos.y, ent.pos.z
            -- boom will be biased towards enemies with 1.2 radians
            ccall("boom", x, y, ent.strength * 3, 100, 0,0, "enemy", 1.2)
            ccall("animate", "push", x,y+25,z, 0.03) 
            ccall("shockwave", x, y, 4, 130, 7, 0.3)
            ccall("sound", "boom")
        end
    end
end



return {
    construct = function(self,player)
        local hp = player.hp
        hp.hp = 0xfff
        hp.max_hp = 0xfff
        hp.regen = 20
        
        player.collisions = {
            physics = physColFunc
        }

        player.speed.speed = 300
        player.speed.max_speed = 300

        player.draw.ox = self.ox
        player.draw.oy = self.oy

        self.super.construct(self,player)
    end;

    destruct = function(self,player)
        player.hp.max_hp = CONSTANTS.PLAYER_HP
        player.hp.hp = CONSTANTS.PLAYER_HP
        player.hp.regen = CONSTANTS.PLAYER_REGEN

        player:remove("collisions")

        player.speed.speed = CONSTANTS.PLAYER_SPEED
        player.speed.max_speed = CONSTANTS.PLAYER_MAX_SPEED

        player.draw.ox = self.og_ox
        player.draw.oy = self.og_oy

        self.super.destruct(self,player)
    end;


    initialize = function(self)
        local Quads = EH.Quads

        local _,_,w,h = Quads.red_player_down_1:getViewport()
        self.og_ox, self.og_oy = w/2, h/2
        
        _,_,w,h = Quads.bully_down_1:getViewport()
        self.ox, self.oy = w/2, h/2

        self.down = {}
        self.up={}
        self.left={}
        self.right={}
        for _ , i in ipairs{1,2,1,3} do
            table.insert(self.down, Quads["bully_down_"..tostring(i)])
            table.insert(self.up, Quads["bully_up_"..tostring(i)])
            table.insert(self.left, Quads["bully_left_"..tostring(i)])
            table.insert(self.right, Quads["bully_right_"..tostring(i)])
        end
    end
}

