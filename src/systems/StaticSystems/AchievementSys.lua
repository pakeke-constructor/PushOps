
--[[

File for steam achievements

]]


if not luasteam then
    do return end
    -- don't run this file if luasteam is not active.
end



--[[
List of achievements:

`load`  --> start the game
    ITS WORKING : Enter the lobby for the first time


`winner` --> beat a boss
    Titan Slayer : beat a boss!

`endless` --> start an endless run
    GLHF! : start an endless run

#### `survivor` --> survive 8 minutes in endless

`invisible` --> make it to zone 5
    Zone Stomper : Make it past zone 4

`spender` --> unlock a character
    Costume time : Use a different character skin

`bully` --> switch to the bully
    BOOOM : Switch to the bully character

`monk` --> switch to the monk
    Blindfold operative : Buy and switch to the blindfold character

        `hoarder` --> pick up an item

`splat` --> encounter a splat
    Where blocks? : Encounter a splat enemy that destroys some of your blocks

]]


local AchievementSys = Cyan.System()

local savedata = require("src.misc.unique.savedata")


savedata.achievements = savedata.achievements or {}


local function setAchievement(name)
    if not savedata.achievements[name] then
        print("GOT ACHIEVEMENT: ", name)
        luasteam.userStats.setAchievement(name)
        savedata.achievements[name] = true
    end
end

function AchievementSys:splat()
    setAchievement("splat")
end

function AchievementSys:switchPlayer(type)
    setAchievement("spender")
    if type == "bully" then
        setAchievement("bully")
    end
    if type == "blind" then
        setAchievement("monk")
    end
end

function AchievementSys:load()
    setAchievement("load")
end

function AchievementSys:bossWin()
    setAchievement("winner")
end

function AchievementSys:newWorld(world_table)
    if world_table.type == "endless" then
        setAchievement("endless")
    end
    if world_table.type == "basic" and world_table.tier == 5 then
        setAchievement("invisible")
    end
end


