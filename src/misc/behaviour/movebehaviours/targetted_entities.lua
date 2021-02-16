

--[[

This is not a MoveBehaviour!
This is a data structure ===>


This data structure keeps record of what entities are tracking other ents.
For example:

{
    [ ent1 ] = set( ent2, ent3, ent4 )
}

This tells us that `ent1` is being tracked by `ent2`, `ent3`, and `ent4`.



(The reason for using this, is because it allows us to ensure that
entities wont track destroyed entities. Having a data structure like this
allows us to do this stuff in a really nice, event driven way)
]]



return setmetatable({ },
--[[
    2d array of sets, keyed with entities that have been targetted.
    On entity deletion, all entities in the targetted set must be removed
]]
{__index = function(t,k)
    t[k] = Tools.set() return t[k]
end})


