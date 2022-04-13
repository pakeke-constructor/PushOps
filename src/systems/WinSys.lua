
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

local atlas = require("assets.atlas")


local WinSys = Cyan.System("targetID")


local enemyCount = 0
local enemyCountTotal = 0


local bossCountTotal = 0
local bossCount = 0
local bossTotalHealth = 0



function WinSys:added(ent)
    if ent.targetID=="enemy" then
        enemyCountTotal = enemyCountTotal + 1
        enemyCount = enemyCount + 1
    elseif ent.targetID=="boss" then
        bossCountTotal = bossCountTotal + 1
        bossCount = bossCount + 1
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

    if (bossCount < bossCountTotal) and (bossCount == 0) then
        if not bossWinDone then
            ccall("bossWin")
            bossWinDone = true
        end
    end
end



function WinSys:drawUI()
    if bossCount >= 1 then
        local hp = 0

        for i, ent in ipairs(self.group) do
            if ent.targetID == "boss" and ent.hp then
                hp = hp + ent.hp.hp
            end
        end

        love.graphics.push("all")
        love.graphics.setLineWidth(4)
        local sf = CONSTANTS.UI_SCALE_FACTOR
        local w,h = love.graphics.getWidth(), love.graphics.getHeight()

        local ww = 60
        local hh = 30
        local hp_ratio = hp / bossTotalHealth
        love.graphics.setColor(0.6,0.3,0.2,0.8)
        love.graphics.rectangle("fill", sf * ww, h/sf - hh*sf, (w/sf) - (sf*ww*2), sf * hh/2)
        love.graphics.setColor(0.9,0,0)
        love.graphics.rectangle("fill", sf * ww, h/sf - hh*sf, hp_ratio * ((w/sf) - (sf*ww*2)), sf * hh/2)
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("line", sf * ww, h/sf - hh*sf, (w/sf) - (sf*ww*2), sf * hh/2)
        love.graphics.setColor(1,1,1)
        atlas:draw(atlas.quads.death_32, sf * ww + ((w/sf) - (sf*ww*2))/2 ,
                    h/sf - hh*sf, 0, 4,4, 16, 16)
        love.graphics.pop()
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
    bossTotalHealth = 0

    enemyCount = 0
    bossCount  = 0

    for _,ent in ipairs(self.group)do
        if ent.targetID=="enemy" then
            enemyCountTotal = enemyCountTotal + 1
            enemyCount = enemyCount + 1
        elseif ent.targetID=="boss" then
            bossCountTotal = bossCountTotal + 1
            bossCount = bossCount + 1
            if ent.hp then
                bossTotalHealth = bossTotalHealth + ent.hp.hp
            end
        end
    end
end


function WinSys:purge( )
    ratioWinDone = false
    voidWinDone = false
    bossWinDone = false
end


