

# update   ( dt )
Called every frame

# heavyupdate ( dt )
Called every 60 frames

# sparseupdate ( dt )
Called every 3 frames

# await ( func, time, ... )
Applies function `func` `time` seconds later with args `...`
(KINDA EXPENSIVE)



# draw     ()
Called every frame

# drawUI ()
Called for drawing UI.


# drawEntity    ( ent )
Called for each entity with `image` and `position` component

# drawIndex ( z_depth )
Called for every draw index, so systems can draw in order without caring for entity

# translate      ()
When love.graphics.translate() needs to be done, this is called


# addSigil( ent, sigilName )
Adds a sigil to ent
# removeSigil( ent, sigilName )
Removes a sigil from an ent

# emit ( emitter_type, x, y, z,  num_particles )
emits a burst of particles of `emitter_type` at x,y,z.
-> see `src.misc.particles._types` for a list of types.

# animate ( animationType, x, y, z, frame_len, track_ent )
Plays animation at x,y,z with specified frame length, and can track an entity.
NOTE: The animation z depth won't change even when the entity moves! So tracking is only good for short animations
-> see `src.misc.animation._types` for a list of types


# keydown   ( keyname )
Called when a key is pressed.
Key will be: "up", "down", "left", "right", "pull" or "push"

# keyup     ( keyname )
Called when key is released  (same as above)

# keytap    ( keyname )
Called when key is tapped. Only works for "pull" and "push"

# changeKey  ( keyname, scancode  )
Changes a keyname to a different scancode. "wasd" and "kl" are used by default



# sound ( sound, volume=1, pitch=1,  volume_variance=0,  pitch_variance=0)
Plays a sound.
See `soundSys` for a more detailed explanation on how sound files are handled



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


# hit ( ent_A, ent_B, hardness )
Called when an entity collides with a speed greater than it's toughness component. 
===> collision_hardness = collision_speed - ent_A.toughness 
(if no toughness component, assume ent can never be hit)

# collide ( ent_A, ent_B, speed )
Called when 2 entities collide regardless of conditions


# pquery ( X, Y, callback )
If X, Y is touching a physics object, `callback` is called with the fixture as the first argument.
See https://love2d.org/wiki/World:queryBoundingBox



# airborne ( ent )
when entity becomes airborne

# grounded ( ent )
when entity becomes grounded (opposite of airborne)



# damage( ent, amount )
Removes `amount` hp from `ent`.
if ent has no HP component, nothing happens

# dead ( ent )
Called when an entity becomes dead.




# purge ( )
Frees all memory in preperation for new world gen (including destroying ents)

# newWorld  {
#   x = 70    (70 units wide) (1 unit = 64 pixels, or size of 1 wall)   
#   y = 70    (70 units tall)
#   type = "basic" 
#   tier = 1  (1 = easy, 2 = harder, 3 = hardest)
# }
Changes the world to a new world. New parameters will be added to this in future.


