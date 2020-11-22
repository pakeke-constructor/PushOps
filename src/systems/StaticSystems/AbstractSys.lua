
--[[

Handles abstract events that don't really belong to any other system,
or events that other Systems use.


]]


local AbstractSys = Cyan.System()


local Partition = require("src.misc.partition")


function AbstractSys:apply(effect, x,y)
    --[[
        Applys `effect` function to all entities within
        relative range of `x` and `y`.
    ]]
    for ent in Partition:iter(x,y)do
        effect(ent)
    end
end







