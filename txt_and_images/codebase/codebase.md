

# about the codebase.

All globals have been defined in `main.lua`.  Take a quick look through them.


PushOps uses an Entity Component System (ECS) called Cyan; [give it a skim read.](https://github.com/pakeke-constructor/Cyan)
(It's actually more of an entity-system library though,
because entities are just lua tables, and components are just table keys.)


`Cyan.call` or `ccall` is something you will see a lot. This is basically just broadcasting an event that Cyan Systems will latch on to.


You can find all of the entity components [here.](components.md)

You can find all of the `Cyan.call` events [here.](events.md)

# Folder structure:

================================================
## src 
Where all the main source code is.

#### src/entities:
Where all of the entities are defined. Each entity file has a ctor function
that *usually* takes arguments `(x, y)`.

You will also see `EH` a lot; this is the "Entity Helper" module, and is a small
module with helper functions used to streamline entity construction.


#### src/misc:
Miscellaneous stuff is defined here. Such as:
- Gamestate
- World generation config files
- shockwave objects, animation objects, particle objects
- Items
- Playable characters
- Movement behaviour for entities
- Camera, font, shader, savedata, spatial partitions, etc.


#### src/systems
All of the ECS Systems are defined here.

Most of the time, there is only one system per file, but
*sometimes* there are two.

Systems files don't return anything, and are only ever `require`'d at load
time.

`StaticSystems` hold all ECS Systems that don't take entities.  If a system
doesn't take entities, its just used for tagging onto events.

`DrawSystems` holds all Systems that are directly to do with rendering


================================================
## libs  
Where the libraries are kept.

Libraries starting with `NM_` are not my code.

================================================
## assets
Holds sound, images, and the atlas loading files.
