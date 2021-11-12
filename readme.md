
# PushOps
Hi, this is my game!
Here is a [video demo](https://youtu.be/q7SY_eWbJjM)

# building
The game is written in love2d.
To run, navigate to the directory and run `love .` in the terminal.

# Contribution!
Feel free to contribute to the project!! :)

Be warned though-
A lot of the code here was written when I was still learning,
so some of the code isn't the best. The worldgen is particularly scuffed IMO.
Also, when this project was nearing completion, I took a few "shortcuts" that
caused quite a bit of technical debt in the codebase. Just be wary of this!

Overall the codebase is still relatively modular and still follows a nice
ECS-like design, so it's not too bad.

# Codebase structure:
To read about the codebase structure and how it all fits together,
follow [This link here.](txt_and_images/codebase/codebase.md)


![menu](https://i.ibb.co/nqXV7pV/menu.png)

![ingame](https://i.ibb.co/rG5xbkt/ingame.png)


# Controls:

`WASD` to move.

Arrow keys to push and pull.

`escape` to pause.


# Some things to know:

Clojure is not actually used here! The language used is Fennel, a lisp dialect that transpiles to lua

Files starting with `NM` are not my own. (i.e. other people's code.)



An example of a generated Map:
(See src/systems/StaticSystems/generationSys.lua for what the chars mean)
```
~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
~ % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % ~
~ % ^ . ^ .   # # #     # # # # #     ^ ^ ^ ^   # # # # #   l . % ~
~ % ^ ^ ^ p . #     ^     # # # #     p ^ . ^     # # # # #     % ~
~ %       ^ .     . ^ l   # # # #       ^ p ^ .     # # # # # # % ~
~ %   #         @ ^ ^ ^ ^ # # # #     p p l e .     # # # # # # % ~
~ % # # # #   ^ p ^ p ^ ^ # # # # e   # # # # #   # # # # # # # % ~
~ % # # # #   p l p l p . . # # # #   # .   . #   # # # # # #   % ~
~ % # # # # # ^ p ^ p ^ ^   # # # #   #       .   # # # # # #   % ~
~ %   # # # #     ^   . .   # # # #   # . ^ . #   # # # # # #   % ~
~ % .   # # # #     #         # # #   # # # # #     # # # # #   % ~
~ % .   # # # # # #     . p   # # #       ^ ^ ^ ^   # # # # #   % ~
~ %   # # # # # #     . l .   # # # # #   ^ ^ . ^ ^   # # # # # % ~
~ %   # # # # # #   . l p .   # # # # # # ^ ^ ^ ^ P   # # # # # % ~
~ %   # # # # # # ^ p ^ ^ ^ # # # # # # # . . ^ ^ ^ p ^ # #     % ~
~ %   # # # # # e p l p p ^ p ^ # # # # # . ^ l p ^ l p       . % ~
~ % ^   # # # #   ^ p ^ ^ p l p e   # # #   l p e p p ^         % ~
~ % ^ ^ # # # #       ^ ^ l p ^ l ^     #     ^ p ^ #   # # #   % ~
~ % . ^     # # #       l p ^ l l p     # #       # # # # # # # % ~
~ % ^ ^ ^ p ^             . . ^ p ^   # # # # #         # # # # % ~
~ % ^ ^ p l p ^ ^           ^ ^   p   # # # # #           # # # % ~
~ % p . ^ p ^         # # #         # # # # # # ^ p ^   # # # # % ~
~ % . . . .     #   # # # # # #   # # # #       p l p     # # # % ~
~ % . ^   p   # # # # # # # # # # #             ^ p l ^   # # # % ~
~ % #   # #   # # # # # #   # # # #   ^         e l ^ p   # #   % ~
~ % # # # # # # e               # e   ^ P   . ^ ^ . ^ ^ .   # # % ~
~ % # # # #         # # # # #     ^ p ^ # # # # # ^ ^ .   # # # % ~
~ %     # #         # .   . # p . ^ ^ ^ # . p . # ^ p   # # # # % ~
~ %     ^ p ^   l . . ^ l . # ^ ^   l   #   l ^ # ^   # # # # # % ~
~ %     p l p l   l # . . . # ^ ^ l ^   # . ^ . #   # # # # # # % ~
~ %     ^ p ^       # # # # # p p l p ^ # # . # #   # # #     # % ~
~ % ^ ^ p . ^       ^       ^ ^ ^ p ^ ^             #       ^   % ~
~ % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % ~
~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
```
