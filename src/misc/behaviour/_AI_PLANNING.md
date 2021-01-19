

BEHAVIOUR WILL 100% BE THE HARDEST MODULE TO DO.
If this is not done correctly, this game won't be completed.

If it is done well, however, game will be easy to make.


IDEA ::::
Split ent behaviour up into 3 systems ::

MoveBehaviour -- handles motion of entities

BehaviourTree -- handles everything else






Something to keep in mind though!!!!

```lua
-- HOWEVER, all the actions / movement will be done under specialized callbacks.
-- Example:
-- If FSM wants to direct entity to follow a player, it should emit:
Cyan.call("follow", ent, target_ent)

-- If FSM wants entity to go into its shell or something, it should do:
Cyan.call("sound", ent, "shellclose")
Cyan.call("emit", "rock", ent.x ... )

```






