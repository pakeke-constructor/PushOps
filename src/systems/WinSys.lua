
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


local tmp_hash = { -- temporary debug hasher
    
}



function WinSys:added(e)
    tmp_hash[e]=true
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






function WinSys:update(dt)
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
    if e.targetID == "enemy" then
        enemyCount = enemyCount - 1
    end
    if e.targetID == "boss" then
        bossCount = bossCount - 1
    end
end

function WinSys:newWorld()
    bossCountTotal  = 0
    enemyCountTotal = 0

    enemyCount = 0
    bossCount  = 0

    for _,ent in ipairs(self.group)do
        if ent.targetID=="enemy" then
            enemyCountTotal = enemyCountTotal + 1
            enemyCount = enemyCount + 1
        elseif ent.targetID=="boss" then
            bossCountTotal = bossCountTotal + 1
            bossCount = bossCountTotal + 1
        end
    end
end


function WinSys:purge( )
    ratioWinDone = false
    voidWinDone = false
    bossWinDone = false
end


