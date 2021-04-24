
--[[
    handles win conditions.

NOTE: What actually happens when a win condition is invoked depends on
the worldType!


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





-- Win conditions can only be called once per world.
local ratioWinDone = false
local voidWinDone = false
local bossWinDone = false







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
    if (enemyCount / enemyCountTotal) <= CONSTANTS.WIN_RATIO then
        if not ratioWinDone then
            ccall("ratioWin")-- yyeahhh baby
            ratioWinDone = true
        end
    end
    if enemyCount <= 0 then
        if not voidWinDone then
            ccall("voidWin")
            voidWinDone = true
        end
    end
    if bossCount <= 0 then
        if not bossWinDone then
            ccall("bossWin")
            bossWinDone = true
        end
    end
end


function WinSys:removed(e)
    local check = false -- we should only check for a win if a boss or enemy was removed
    if e.targetID == "enemy" then
        check = true
    enemyCount = enemyCount - 1
    end
    if e.targetID == "boss" then
        check = true
        bossCount = bossCount - 1
    end
    if check then
        checkWin()
    end
end



function WinSys:update(dt)
    if enemyCount < 0 then
        error("wtf man...")
    end
end


function WinSys:purge( )
    bossCountTotal  = 0
    enemyCountTotal = 0

    enemyCount = 0
    bossCount  = 0

    ratioWinDone = false
    voidWinDone = false
    bossWinDone = false
end


