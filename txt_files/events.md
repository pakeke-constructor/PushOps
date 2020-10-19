

# update   ( dt )
Called every frame

# heavyupdate ( dt )
Called every 60 frames

# sparseupdate ( dt )
Called every 3 frames



# draw     ()
Called every frame


# drawEntity    ( ent )
Called for each entity with `image` and `position` component

# translate      ()
When love.graphics.translate() needs to be done, this is called


# addSigil( ent, sigilName )
Adds a sigil to ent
# removeSigil( ent, sigilName )
Removes a sigil from an ent


# keydown   ( keyname )
Called when a key is pressed.
Key will be: "up", "down", "left", "right", "pull" or "push"

# keyup     ( keyname )
Called when key is released  (same as above)

# keytap    ( keyname )
Called when key is tapped. Only works for "pull" and "push"

# changeKey  ( keyname, scancode  )
Changes a keyname to a different scancode. "wasd" and "kl" are used by default


# boom (x, y, strength)
Pushes all close entities away from pos

# moob (x, y, strength)
Pulls all close entities to pos


# startPush ( ent )
This entity starts pushing the closest entity 
# endPush ( ent )                   
This entity stops pushing whatever entity it was pushing
### (Oli, you should redo these. It is not friendly towards other systems that want information about what entity is being pushed.)


# addVel( ent, vx, vy )
Adds velocity to an entity.

# setVel( ent, vx, vy )
Sets velocity for an entity



# airborne ( ent )
when entity becomes airborne

# grounded ( ent )
when entity becomes grounded (opposite of airborne)



# dead ( ent )
Called when an entity becomes dead.



# newWorld  {
#   x = 70    (70 units wide) (1 unit = 64 pixels, or size of 1 wall)   
#   y = 70    (70 units tall)
#   type = "basic" 
#   tier = 1  (1 = easy, 2 = harder, 3 = hardest)
# }
Changes the world to a new world. New parameters will be added to this in future.


