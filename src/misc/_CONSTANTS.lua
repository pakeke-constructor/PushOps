
return{
    MAX_DT = 0.05 -- Maximum value `dt` will ever take.
,
    GRAVITY = -981
,
    MAX_VEL = 10000
,
    AVERAGE_DT = 1/60
,
    PUSH_RANGE = 50
,
    PUSH_COOLDOWN = 0.5
,
    PULL_COOLDOWN = 0.4
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
        "neutral";
        "interact";
        "coin"
    }
,
    WIN_RATIO = 0.35 -- should be like 0.35
    -- percentage of enemies that need to be killed before ccall("winRatio")
,
    paused = false  -- debug only  (if not debug only, make an cyan.call event for this)
,
    GRASS_COLOUR = {0.1,1,0.2} -- colour of ground grass    
                -- TODO: Player should be able to change grass colour!
,
    SPLAT_COLOUR = {1, 0.65, 0.2}
,
    COLOURBLIND = false --==>>>  swaps blue-green
,
    DEVILBLIND  = false --==>>>  swaps red-green
,
    NAVYBLIND   = false --==>>>  swaps blue-red
,
    MASTER_VOLUME = 0.4 -- volume is always a number:   0 --> 1
,
    DEBUG = true
}



