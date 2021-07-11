


# Next time I develop a game in love2d, remember these things:

Don't forget to use hybrid OOP and ECS!!
EG: if I ever add upgrades for this game, I should make one base "upgrade entity",
    and have all other upgrades extend the base upgrade entity



Make sure to keep stuff like worldGen clean. None of that
 spawnEntity(y, x) shit, thats just spagetti, do it properly



Always try use components for stuff if you can. I.e. instead of doing
ccall("sound","hit") in physColFuncs, add a `hitsound` component, or
something along those lines.


