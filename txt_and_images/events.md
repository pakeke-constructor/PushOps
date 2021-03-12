

Any callback starting with `_` is a private callback.
(Used for communicating between systems)



# update   ( dt )
Called every frame

# heavyupdate ( dt )
Called every 60 frames

# sparseupdate ( dt )
Called every 3 frames

# await ( func, time, ... )
Applies function `func` `time` seconds later with args `...`
(KINDA EXPENSIVE)

# apply ( func, x, y, targetID = <all> )
Applies function `func` to all ents in spatial partition at x,y,
with signature:    func( ent, x, y )



# draw     ()
Called every frame

# drawUI ()
Called for drawing UI.


# drawEntity    ( ent )
Called for each entity with `image` and `position` component

# drawIndex ( z_depth )
Called for every draw index, so systems can draw in order without caring for entity

# transform  
When all the transformations need to be applied, this func is called

# untransform
Removes all draw transformations/shaders (basically just pops from lg.push stack.)


# addSigil( ent, sigilName )
Adds a sigil to ent
# removeSigil( ent, sigilName )
Removes a sigil from an ent

# emit ( emitter_type, x, y, z,  num_particles, colour={1,1,1}, spread= default)
emits a burst of particles of `emitter_type` at x,y,z.
types:  {  guts  beam  dust   smoke  }


# animate ( animationType, x, y, z, frame_len, cycles,
#            colour={1,1,1}, track_ent=nil, hide_ent=false )
Plays animation at x,y,z with specified frame length, and can track an entity.
NOTE: The animation z depth won't change even when the entity moves! So tracking is only good for short animations
-> see `src.misc.animation._types` for a list of types

# shockwave ( x, y, start_size, end_size, thickness, time, colour=WHITE )
Sends out (or in) a cool shockwave


# keydown   ( keyname )
Called when a key is pressed.
Key will be: "up", "down", "left", "right", "pull" or "push"

# keyup     ( keyname )
Called when key is released  (same as above)

# keytap    ( keyname )
Called when key is tapped. Only works for "pull" and "push"


# sound ( sound, volume=1, pitch=1,  volume_variance=0,  pitch_variance=0)
Plays a sound.
See `soundSys` for a more detailed explanation on how sound files are handled



# boom (x, y, strength, distance, 
#                       [vx, vy, bias_group, bias_angle]  )  -- optional args
Pushes all close entities away from pos
bias_group allows you to target certain groups
bias_angle is the angle in radians that `boom` will target.
vx, vy is velocity of the `boom`.

# moob (x, y, strength, distance)
Pulls all close entities to pos


# startPush ( ent, pushed_ent )
For when an entity starts pushing another

# endPush ( ent, pushed_ent )                   
This entity stops pushing whatever entity it was pushing



# addVel( ent, vx, vy )
Adds velocity to an entity.

# setVel( ent, vx, vy )
Sets velocity for an entity

# setPos(ent, x, y, z=0)
Sets position for entity

# setMoveBehaviour( ent, newMoveBehaviour, target_ID )
Sets moveBehaviour state for entity.
newMoveBehaviour => { "IDLE", "ORBIT", "ROOK", "RAND", "LOCKON" ... }
Target ID is the target group that the moveBehaviour acts upon. (optional)

# hit ( ent_A, ent_B, hardness )
Called when an entity collides with a speed greater than it's toughness component. 
===> collision_hardness = collision_speed - ent_A.toughness 
(if no toughness component, assume ent can never be hit)

# collide ( ent_A, ent_B, speed )
Called when 2 entities collide regardless of conditions


# boxquery ( X, Y, callback )
If X, Y is touching a physics object, `callback` is called with the fixture as the first argument.
See https://love2d.org/wiki/World:queryBoundingBox

# rayquery ( x1, y1, x2, y2, callback )
If ray intersects physics fixture, "callback" is called with
the fixture as the first argument.
See https://love2d.org/wiki/World:raycast


# airborne ( ent )
when entity becomes airborne

# grounded ( ent )
when entity becomes grounded (opposite of airborne)



# damage( ent, amount )
Removes `amount` hp from `ent`.
if ent has no HP component, nothing happens

# dead ( ent )
Called when an entity becomes dead.
# ALIAS:    kill ( ent )



# buff ( e, type, time, ... )
Buffs an entity. See `src.misc.buffs` and `systems -> BuffSystem`.
types:  speed(amount)   tint(newcolour)

# debuff( e, type ) 
removes a buff




# shoot ( x, y, vx, vy )
Shoots a bullet in a direction

# purge ( )
Frees all memory in preperation for new world gen (including destroying ents)


# newWorld({
#   x = 70    (70 units wide) (1 unit = 64 pixels, or size of 1 wall)   
#   y = 70    (70 units tall)
#   type = "basic" 
#   tier = 1  (1 = easy, 2 = harder, 3 = hardest)
# }, worldMap=nil)
Changes the world to a new world. New parameters will be added to this in future.


