
--[[
    handles win conditions.

There are multiple win conditions that are emitted.

 * ccall( ratioWin ) 
    When the enemy : total enemy ration is less than CONSTANTS.WIN_RATIO

 * ccall( voidWin )
    when enemyCount == 0
 


TODO:
IDEA:
    Make it so each level only has 1 win condition.

    The win condition for each level is specified inside of the worldType files.
    e.g. 
        wType.winCondition = "ratioWin"
    or
        wType.winCondition = "voidWin"

    Each worldType should also give a function that can be called
    for the win condition when it is invoked.

]]


local WinSys = Cyan.System("targetID")


local enemyCount = 0
local enemyCountTotal = 0


local bossCountTotal = 0
local bossCount = 0



function WinSys:added(e)
    if e.targetID == "enemy" then
        enemyCount = enemyCount + 1
        enemyCountTotal = enemyCountTotal + 1
    end
    if e.targetID == "boss" then
        bossCount = bossCount + 1
        bossCountTotal = bossCountTotal + 1
    end
end





local function checkWin(dt)
    --[[
        TODO:
        maybe add an extra check to account
        for bosses. We dont want to spawn an exit
        portal if the player is halfway thru fighting
        a boss


        GenerationSys SHOULD handle the ratioWin world generation for this.
        SoundSys should handle the sound, and DrawSys should handle the visual feedback
    ]]
    if (enemyCount / enemyCountTotal) < CONSTANTS.WIN_RATIO then
        ccall("ratioWin")-- yyeahhh baby
    end
    if enemyCount <= 0 then
        ccall("voidWin")
    end
end


function WinSys:removed(e)
    if e.targetID == "enemy" then
        enemyCount = enemyCount - 1
    end
    checkWin()
end


function WinSys:purge( )
    bossCountTotal=0
    bossCount=0

    enemyCount=0
    enemyCountTotal=0
end


