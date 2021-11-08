
# PushOps
Hi, this is my game!
Here is a [video demo](https://youtu.be/q7SY_eWbJjM)

A lot of the code here was written when I was still learning,
so excuse the inconsistent style :P


# About this code-base
## TODO:
## There needs to be a short overview of this codebase and how to navigate it.

![menu](https://i.ibb.co/nqXV7pV/menu.png)

![ingame](https://i.ibb.co/rG5xbkt/ingame.png)


# Controls:

`WASD` to move.

Arrow keys to push and pull.

`escape` to pause.



# build into exe: 
## windows:
zip file, rename into PushOps.love
   copy /b D:\PROGRAMMING\LOVE\love.exe+PushOps.love PushOps.exe


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
