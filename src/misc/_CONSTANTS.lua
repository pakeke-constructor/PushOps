
--[[

WOOPS! Sorry, I lied.

Not everything here is a constant.

Everything in UPPER_CASE is a constant,
The stuff in snake_case probably aren't constants.

]]
return{
    PLAYER_SPEED = 170
,
    PLAYER_MAX_SPEED = 180
,
    PLAYER_HP = 100
,
    PLAYER_REGEN = 3
,
    MAX_DT = 0.05 -- Maximum value `dt` will ever take.
,
    AVERAGE_DT = 1/60
,
    GRAVITY = -981
,
    MAX_VEL = 5000
,
    PHYS_CAP = 35 -- the max number of phys objs allowed in each spatial bucket
,
    TILESIZE = 64 -- The width and height of tiles in generation sys
,
    PUSH_RANGE = 50
,
    PUSH_COOLDOWN = 0.5
,
    PULL_COOLDOWN = 0.6
,
    PHYSICS_LINEAR_DAMPING = 0.05
,
    ENT_DMG_SPEED = 300 -- ents hit faster than this will be damaged (except player!)
,
    PROBS = {
        -- World generation:
        -- Probability of each character occuring.
        -- Each value is a weight and does not actually represent the probability.
        -- see `GenerationSys` for what character represents what.
        ["^"] = 0.8;
        ["l"] = 0.03;
        ["p"] = 0.3;
        ["P"] = 0.01;
        ["."] = 0.5
        -- Bossfights, artefacts, are done through special structure generator
        -- Walls, shops, player spawn, and player exit are done uniquely.
    }
,
    TARGET_GROUPS = {
        "player";
        "physics";
        "enemy";
        "static";
        "neutral";
        "interact";
        "coin";
        "boss"
    }
,
    WIN_RATIO = 0.3-- Good value is 0.3 (had to make higher because of invisible ents)
    -- percentage of enemies that need to be killed before ccall("winRatio")
,
    paused = false  -- debug only  (if not debug only, make an cyan.call event for this)
,
    runtime = 0 -- The time currently taken in the run (note that menu counts as a run)
,
    grass_colour = {0.3,1,0.4}-- colour of ground grass    
                -- TODO: Player should be able to change grass colour!
,
    GRASS_COLOURS = {
        green = {0.3,1,0.4};
        aqua  = {100/255, 150/255, 240/255};
        yellow = {255/255, 250/255, 66/255}
    }
,
    SCALE = 2 -- a good scale factor
,
    SCREEN_DIAG_LAPTOP = 1762 -- My laptop screen diagonal size (DrawSys uses.)
,
    SAVE_DATA_FNAME = "game.png" -- save data filename
    -- We encode as a png so people wont tamper with it ahahahahaha
,
    SAVE_DATA_DEFAULT = {
        -- The default save data for a program.
        -- Putting this in CONSTANTS.lua ensures future compatibility.
        tokens = 0; -- the number of tokens player has collected

        owned_players = {
            red = true;
            challenge = false;
            bully = false;
            glasses = false;
            cyclops = false;
            rainbow = false;
        };

        colourblind = false;
        devilblind = false;
        navyblind = false;

        basic_time = 0xffffffffff;
        endless_time = 0;

        playerType = "red";

        sfx_volume = 0.4;
        music_volume = 0.3
    }
,
    SPLAT_COLOUR = {255/255, 241/255, 16/255}
,
    COLOURBLIND = false --==>>>  swaps blue-green
,
    DEVILBLIND  = false --==>>>  swaps red-green
,
    NAVYBLIND   = false --==>>>  swaps blue-red
,
    SHADER_NOISE_AMOUNT = 0.07,
    SHADER_NOISE_PERIOD = 5
,
    minimap_enabled = true
,
    SFX_VOLUME = 0.4--.4-- = 0.4 -- volume is always a number:   0 --> 1
,
    MUSIC_VOLUME = 0.3 --.4   0 --> 1
,
    DEBUG = true
}



