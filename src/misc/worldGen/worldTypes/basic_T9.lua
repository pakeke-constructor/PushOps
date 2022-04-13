
local Ents = require("src.entities")
local WH = require("src.misc.worldGen.WH")
local rand = love.math.random


local enemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.devil]      = 0.2;
    [Ents.splatmallow] = 0.2;
    [Ents.splatenemy] = 0.8;
    [Ents.boxbully]   = 0.15;
    [Ents.boxenemy]   = 0.25;
    [Ents.multienemy] = 0.25;
    [Ents.ghost_squad]= 0.05;
    [Ents.boxsplitter]= 0.05
}


local bigEnemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.splatbully]  = 1;
}


local purge_fn = function(e, cam_x, cam_y)
    -- called at end of level to clear enemies and walls.
    -- (Passed in as a param to `ccall(apply, .)`  ).
    if (e.targetID ~= "player")
    and (Tools.dist(cam_x-e.pos.x,cam_y-e.pos.y) < 160) then
        ccall("damage",e,0xffff)
    end
end




local function spawn_portal(x, y)
    local portal = EH.Ents.portal(x, y)
    ccall("shockwave", x, y, 10,550,30,1)
    ccall("emit", "dust", x, y, 0, 10)
    portal.portalDestination = {
        x = 30;
        y = 30;
        tier = 10;
        type="basic";
    }
end




return {
    type = 'basic',
    tier = 9,
    structureRule = 'default_T1', -- Use default Tier 1 structure rule for this tier.
        -- Note that this is NOT referring to the filename,
        -- it is referring to the `id` of the structureRule.
    
    construct = function(wor,wmap,px,py)
        WH.zonenum(9, px,py)
        WH.lights(wor, wmap, 15, 500)
        ccall("setGrassColour", "yellow")
    end;
    destruct = function(  )
        ccall("setGrassColour", "green")
    end;

    music = "gameon_main1",
    music_volmod = 0.75,

    PROBS = {
            -- World generation:
            -- Probability of each character occuring.
            -- Each value is a weight and does not actually represent the probability.
            -- see `GenerationSys` for what character represents what.
            ["^"] = 0.8;
            ["l"] = 0.12;
            ["p"] = 0.3;
            ["P"] = 0.01;
            ["."] = 0.4
            -- Bossfights, artefacts, are done through special structure generator
            -- Walls, shops, player spawn, and player exit are done uniquely.
    }, -- Can modify the char probabilities by setting
                        -- this to a table. 

    enemies = {
        n = 25;
        n_var = 4;

        bign = 2;
        bign_var = 0
    };

    ratioWin = function(cam_x, cam_y)
        ccall("apply", purge_fn, cam_x, cam_y)
        ccall("await", spawn_portal, 0.8, cam_x, cam_y)
        ccall("shockwave", cam_x,cam_y, 10,250,4,0.43)
    end;

    entities = {

    ["#"] = {
        max = math.huge;
        Ents.splatwall
    };

    ["e"] = {
        max = 200;
        function(x,y)
            for i=0, 1+rand(1,2) do
                local f = enemySpawns()
                f(x+(i-1)*10 + (rand()-.5)*20, y+(i-1)*10 + (rand()-.5)*20)
            end
        end
    };

    ["E"] = {
        max = 10;
        function(x,y)
            bigEnemySpawns()(x,y)
        end
    };


    ["p"] = {
        max = 300,
        function(x, y)
            for i = 1, rand(1,3) do
                Ents.block(
                    x + rand(-10, 10),
                    y + rand(-10, 10)
                )
            end
        end
    };

    ["P"] = {
        max = 3, 
        function(x, y)
            local block_ctor = Ents.block
            for i = 1, rand(3,6) do
                block_ctor(
                    x + rand(-32, 32),
                    y + rand(-32, 32)
                )
            end
        end
    };

    ['^'] = {
        max = 0xFFFFFFF;
        function(x,y)
            local grass = Ents.bluegrass
            for i=1, rand(8,9) do
                grass(x + rand(-50, 50), y + rand(-50, 50))
            end
        end
    };


    ['l'] = {
        max = 100;
        function (x, y)
            if rand()<0.3 then
                Ents.mushroom(x+rand(-30,30),y+rand(-30,30))            
            else
                Ents.yellowpine(x+rand(-30,30),y+rand(-30,30))
            end
        end
    };

    
    ["%"] = {
        max=math.huge;
        function(x,y)
            Ents.inviswall(x,y)
            for i=1, (rand()*2) do--4 + rand()*2 do
                local X = x+rand(-45,45)
                local Y = y+rand(-45,45)
                Ents.fakeyellowpine(X,Y)    
            end
        end
    };

    ["~"] = {
        max=math.huge;
        function(x,y)
            for i=1, rand()*4 do--4 + rand()*2 do
                local X = x+rand(-100,100)
                local Y = y+rand(-100,100)
                Ents.fakeyellowpine(X,Y)    
            end
        end
    };
}
}











