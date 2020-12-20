
# ABANDONED

planning ::::::


Each Node should hold a `start`, `run`, and `finish` function,
as well as a set of keyworded arrays that can hold other nodes.
eg
```lua
Node{
    start = function(node,e,dt)
        node:to("alpha")
        node:continue() -- Runs first portion of `alpha` this frame
    end

    alpha = {
        "idle",
        "attack",
        "eat",
    },
    bravo = {
        "attack",
        "heal"
    }
}


```
when ran, a node will run itself, and according to what methods are called,
the node can choose to run it's children.





In the `update` loop, every Node must `finalize` itself.

```lua

--[[
    NODE FINALIZERS ::::
]]
node:running( run_again? ) -- This node is still running.

node:next( run_again? ) -- runs the next task in the current subtree next frame
-- (If it is the last node in the parent node array, it resets fully to root node)
    -- NOTE THAT THIS FUNCTION WILL CALL node:finish(ent, dt)

node:continue( run_again? ) -- tells the root node to run another loop
-- (good for selection nodes)

node:to(child_index, run_again? ) -- runs this node's child node next frame
                        -- (according to index)
    -- NOTE THAT THIS FUNCTION WILL CALL node:finish(ent, dt)

node:reset( run_again? ) -- resets the whole state of the tree.
-- All running task runtimes are set to 0, control is given to root.
    -- (If called on child node, the child node will call :reset on parent.)


-- Each node function takes these args:  
function(node, object, dt)



node:runtime(ent) -- gets runtime

node:overtime(ent, 5) --return true if it has been running for over 5 seconds, false otherwise



node:root() -- returns ultimate root of tree (if this node is the root, ret nil.)

node:parent() -- returns parent node of this node, or nil.





-- Specialized callbacks!
-- These can be called with node:event(ent, ...)

Node:on("callback_id", function(node, ent, ...)

end)


Node:event("callback_id", ent, 1,2,3,4) -- Emits the callback


```





CONSTRUCTION:::::
(AND USAGE)

```lua

return Node{
    name = nil, -- Anonymous!

    update = function(node, ent, dt)
    end,

    start = function(node, ent, dt)
        -- So this node is a selector node.
        local rand = math.random(1,2)
        
        if rand < 2 then
            node:to("left")
        else
            node:to("right")
        end

        return node:continue()
    end,

    
    --[[
        Note that there is nothing special about the names
        `left` and `right`, except for the fact that they are
        referenced in `node:run` in `start` function
    ]]
    left = {

        -- These are all names of nodes that were previously defined!
        "wait3", -- wait for 3 seconds
        "randommove",
        "wait10", -- stays in randommove behaviour state for 10 seconds
        "idlemove"
    },

    right = {
        "rookmove",
        "wait10"
    }
}



```


