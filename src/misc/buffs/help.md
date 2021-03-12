


# PROBLEMS ::

!!! There is a bit of a problem with buffs and debuffs mutating data.
you have to be extremely careful not to mutate a component that is
shared among others.

!!! Likewise, you have to be extremely careful not to give an entity a new
component (to avoid mutation of other ents), and that component being
held/accessed by another entity, thus they have the wrong one.
I dont know if there is a way around this. I suppose we just have to be really careful.





# Buffs and Debuffs
Buffs are for making safe, intermediate changes to entities.


# Important thing to remember !
Most components should be read only, as they are often shared between
entities. 
If you are changing a component, firstly, ensure that it isn't a component
that could be being held by another entity, and secondly, ensure that when
you are modifying it, make a *copy* of that component and change it from there.

#### Note that buffs can be negative! i.e. there could be a buff that reduces speed

Buffs should be of the form:

```lua

local BuffObj = { }


function BuffObj : buff( e, ... )
end


function BuffObj : debuff( e )  -- debuff removes the buff.
end



```
