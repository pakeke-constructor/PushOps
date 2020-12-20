


--[[

"Exclusion zone tables" are set up to ensure
ents don't spawn too closely to each other.

For example, we can set up an exclusion table to ensure enemies
don't spawn around ["E"] spawn locations:
see example:
exclusionZones = {
    ["E"] = {
        ["e"] = 1, -- exclusion radius 1
        ["u"] = 1, -- exclusion radius 1
        ["E"] = 3 -- exclusion radius 3.
    };
    -- Likewise, we can ensure large structures don't spawn
    -- next to each other:
    ["l"] = {
        ["l"] = 1
    }
}



(please note that player spawn, walls, player exit, shop, etc are done 
such that exclusion zones should not need to be used for those spawns)
]]


return {

    e={
        e=1;
        r=1;
        u=1;
    };

    E={
        E=3;
        e=1;
        r=1;
        u=1
    };

    u={
        E=1;
        e=1;
        r=1;
        u=1
    };

    p={
        p=1
    };

    q={
        q=2
    };

    l={
        l=1
    };

}