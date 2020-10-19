


# Cyan

Cyan is a lightweight ECS library built for LOVE.

It is designed to have a very minimalistic and intuitive API whilst having time complexities among the best ECS libaries out there.

I mainly built this for personal use. Check out Concord, Nata, or HOOECS if you want a more feature-complete ECS lib!


# Usage:

```lua

-- importing:
local cyan = require "(path to cyan folder).Cyan.cyan"

```

This tutorial assumes you know the basics of ECS.
If you don't, there are plenty of great online resources.

### Entities:

Entities hold data.
They are basically a glorified lua table.

```lua

local ent = cyan.Entity()


ent.position = { x=10, y=10 } -- adds "position" component

                        -- same as ent:add("position", {x=10, y=10})


-- components don't have to be tables:
ent.health = 50


ent:remove("health") -- removes component 'health'


-- Marks entity for deletion (will be deleted next frame)
ent:delete()

```
 
 
      
### Systems:
Systems is where logic is held.
It is also where the entities belong.

You do not need to add entities to systems- they will automatically be added
if they have the required set of components.
```lua

--  A system for entities with `image` and `position` components
local DrawSys = cyan.System( "image", "position" )




-- Access system entities using `System.group`.
-- Example:
function DrawSys:draw()
    for _, ent in ipairs(self.group) do -- iterates over all entities
        love.graphics.draw(ent.image, ent.position.x, ent.position.y)
    end
end



-- Another example
function DrawSys:update(dt)
    for _, ent in ipairs(self.group) do
        -- Do something to do with entity Z indexing or something, idk
    end
end



```
 
   
   
###  Calling system functions
```lua
--  To call functions in Cyan systems, use
--  " Cyan.call "

function love.update(dt)

    cyan.call("update", dt)
    -- Calls ALL systems with an `update` function, 
    -- passing in `dt` as first argument.
end


function love.draw(dt)

    cyan.call("draw")
    -- Calls ALL systems with a `draw` function, passing in 0 arguments.

end


```

# Optional ease of use:
Here are some tips that provide extra functionality, but are
entirely optional.
   
 
    
      
```lua

-- Low level entity functions:

local ent = cyan.Entity()


ent:has("pos") -- returns `true` is entity has position component, false otherwise.

-- Adds component `q` without adding to any systems.
ent:rawadd("q", 1)


-- Removes component `q` without removing from any systems.
ent:rawremove("q")


ent:getSystems() -- Gets all the systems of an entity.
    -- WARNING:: This operation is extrememly expensive!!!
    -- Do NOT use it every frame!!!



-- Low level system functions

-- removes `entity` from `Sys`
Sys:remove(entity)

-- adds `entity` to `Sys`
Sys:add(entity)

-- This is done automatically, so it doesn't really need to be done.


```

# *Final notes*

This library is not meant to be used as a barebones library. 

The user is expected to add the functionality they want through extra functions, and extra helper tables that they see necessary; minimalism comes at a cost!

For example, if you wanted an easy way to add multiple components at once,
you could do:
```lua
local function addAll(entity, comps)
    for key, value in pairs(comps) do
        entity[key] = value
    end
end


addAll(ent,
{
    pos = vec3(0,0,0);
    health = 10;
    max_health = 100;
    image = love.graphics.newImage("monkey.png")
})
```

What about components? Putting values of components in manually is a bit tedious, don't you think? That can be solved too with a little monkeypatch:

```lua
local comp_maker = {
    -- Holds component constructors.
    pos = function(...)
        return vec3(...)
    end
}

local old_ent_add = Entity.add

function Entity:add(name, ...)
    old_ent_add(self, name, comp_maker[name](...) )
end



ent:add("pos", 1,2,3)

print(ent.pos) ---> vec3( 1, 2, 3 )

```

Just make sure to stick to your conventions, and keep it
as minimalistic and strict as possible to avoid spagetti.
No edge cases!


