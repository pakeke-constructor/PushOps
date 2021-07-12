
Shittt, okay we gotta really think about this.

This could easily spagettify and ruin everything, so lets
jot some ideas down:


- We need a clean way to modify damage of physics blocks
    to enemies and bosses exclusively
<IDEA>: thru HealthSys?   - Yes, this is a good idea
have a hasher:   damagemods = {
    enemy = 1;
    boss = 1
}


-   :fullload(player)   called once, when the upgrade is loaded
-   :fullreset(player)  called once, when the upgrade is removed. (when run resets)


:load(player)  and  :reset(player) are different, in that they are
called whenever player destructs and reassembles.
(i.e. are called multiple times in a run, across levels.)


