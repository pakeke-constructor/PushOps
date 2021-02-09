

--[[


This data structure keeps record of what entities are tracking other ents.
For example:

{
    [ ent1 ] = set( ent2, ent3, ent4 )
}

This tells us that `ent1` is being tracked by `ent2`, `ent3`, and `ent4`.



]]



return setmetatable({ },
--[[
    2d array of sets, keyed with entities that have been targetted.
    On entity deletion, all entities in the targetted set must be removed
]]
{__index = function(t,k)
    t[k] = Tools.set() return t[k]
end})
