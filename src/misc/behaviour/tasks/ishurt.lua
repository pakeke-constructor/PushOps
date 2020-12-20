



--[[

ishurt function task manager.

This task does not actually perform anything, but it does
manage the control of the behaviour Tree.

if the entity is hurt, control will be given to the Node/task 2 steps in
front, else, control is given to the node/task directly in front of `ishurt`.

NOTE ::::

For a selector task like this, the underlying tasks must either
(A) be Nodes, so they reset to top of tree
or (B) be a task that resets to top of the tree upon exit.


]]


local B=require'libs.BehaviourTree'

B.Task{
    name = "ishurt",

    run = function(t,e)
        if e.hp.hp < e.hp.max_hp + 0.01 then-- account for FP err
            -- is hurt! skip 1
            t:next(2)
        else
            t:next(1) -- Is not hurt, act normally
        end
    end
}


