

--[[

B-B-B-B-B-BOSS FIGHT!!!


world type:  basic
tier 8

]]


local Ents = require("src.entities")
local WH = require("src.misc.worldGen.WH")

local menu_map = require("src.misc.worldGen.maps.menu_map")

local rand = love.math.random


local purge_fn = function(e, cam_x, cam_y)
    -- called at end of level to clear enemies and walls.
    -- (Passed in as a param to `ccall(apply, .)`  ).
    if (e.targetID ~= "player")
    and (Tools.dist(cam_x-e.pos.x,cam_y-e.pos.y) < 160) then
        ccall("damage",e,0xfffffffff)
    end
end




local function spawn_portal(x, y)
    local portal = EH.Ents.portal(x, y)
    portal.portalDestination = {
        x = 30;
        y = 30;
        tier = 1;
        type="menu";
        map = menu_map;
        minimap = EH.Quads.menu_minimap
    }
end



local bosses = {
    EH.Ents.bigworm;
    EH.Ents.bigblob
}




return {
    type = 'basic',
    tier = 8,

    music = "challenge_main1",

    structureRule = 'default_T1',

    enemies = {
        n = 30;
        n_var = 1;

        bign = 1;
        bign_var = 0
    };

    construct = function(wor,wmap,px,py)
        ccall("spawnText", px, py - 220, "boss", 400, 30)
    end;

    bossWin = function(cam_x, cam_y)
        ccall("apply", purge_fn, cam_x, cam_y)
        ccall("await", spawn_portal, 0, cam_x, cam_y)
        ccall("spawnText", cam_x, cam_y - 90, "gg", 400, 30)
        ccall("shockwave", cam_x,cam_y, 10,250,4,0.43)
        for x=-70, 70, 10 do
            for y = -70, 70, 10 do
                local dist = Tools.dist(x, y)
                if dist < 400 and dist > 20 then
                    EH.Ents.tok(cam_x + x, cam_y + y)
                end
            end
        end
    end;

    entities = {

    ["!"] = {
        max=1;
        function(x,y)
            Tools.rand_choice(bosses)(x,y)
        end
    };

    ["p"] = {
        max = 300,
        function(x, y)
            for i = 1, rand(1,2) do
                Ents.block(
                    x + rand(-10, 10),
                    y + rand(-10, 10)
                )
            end
            local light = Ents.light(x + rand(-30, 30), y + rand(-30, 30))
            light.light.distance = 160
        end
    };

    ['^'] = {
        max = 0xFFFFFFF;
        function(x,y)
            local grass = Ents.grass
            for i=1, rand(8,9) do
                grass(x + rand(-50, 50), y + rand(-50, 50))
            end
        end
    };


    ['l'] = {
        max = 100;
        function (x, y)
            if rand()<0.5 then
                Ents.mushroom(x+(rand()-.5)*40,y+(rand()-.5)*40)
            else
                Ents.pine(x+(rand()-.5)*40,y+(rand()-.5)*40)
            end
        end
    }
}
}











