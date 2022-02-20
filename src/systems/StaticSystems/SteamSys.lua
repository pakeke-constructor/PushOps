
--[[

File for steam achievements,
and steam rich presence

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


`invisible` --> make it to zone 5
    Zone Stomper : Make it past zone 4

`spender` --> unlock a character
    Costume time : Use a different character skin

`bully` --> switch to the bully
    BOOOM : Switch to the bully character

`monk` --> switch to the monk
    Blindfold operative : Buy and switch to the blindfold character


`splat` --> encounter a splat
    Where blocks? : Encounter a splat enemy that destroys some of your blocks

`deaths_100` --> die 100 times
    Friend of death : Ya know, death and I seem to get along. You could say we are pretty good pals.

`tokens_1` --> collect 1000 tokens
    Tokens I : Collect 1000 tokens

`tokens_2 --> 10000 tokens
    Tokens II : Collect 10,000 tokens

`tokens_3` --> 100000 tokens
    Tokens III: Nice!


]]




--[[
#### NOT DONE YET:
        `hoarder` --> pick up an item
         `survivor` --> survive 8 minutes in endless
]]


local SteamSys = Cyan.System()

local savedata = require("src.misc.unique.savedata")



local function setAchievement(name)
    if not savedata.achievements[name] then
        luasteam.userStats.setAchievement(name)
        luasteam.userStats.storeStats()
        savedata.achievements[name] = true
    end
end


local REQUIRED_DEATHS = 100

function SteamSys:lose()
    savedata.deaths = savedata.deaths + 1
    luasteam.userStats.setStatInt("deaths", savedata.deaths)
    if savedata.deaths > REQUIRED_DEATHS then
        setAchievement("deaths_100")
    end
    luasteam.userStats.storeStats()
end


function SteamSys:collectToken()
    savedata.total_tokens = savedata.total_tokens + 1
    local total = savedata.total_tokens
    luasteam.userStats.setStatInt("tokens", total)
    if total > 1000 then
        setAchievement("tokens_1")
    end
    if total > 10000 then
        setAchievement("tokens_2")
    end
    if total > 100000 then
        setAchievement("tokens_3")
    end
end


function SteamSys:splat()
    setAchievement("splat")
end


function SteamSys:switchPlayer(type)
    setAchievement("spender")
    if type == "bully" then
        setAchievement("bully")
    end
    if type == "blind" then
        setAchievement("monk")
    end
end


function SteamSys:load()
    luasteam.friends.activateGameOverlay("achievements")
    setAchievement("load")
end


function SteamSys:bossWin()
    setAchievement("winner")
end


local presences = {
    basic = function(wt)
        if wt == 11 then
            return "Fighting a final Boss"
        else
            return "Fighting in Zone " .. math.roman(wt.tier)
        end
    end;

    menu = function()
        return "In lobby"
    end;

    endless = function()
        local time = Tools.totime(math.floor(CONSTANTS.runtime))
        local s,_ = time:find("%.")
        if s then
            time = time:sub(1,s-1)
        end
        return "Endless mode - " .. time
    end
}


local count_endless = false

local function setPText(txt)
    luasteam.friends.setRichPresence('steam_display', '#StatusTotal')
    luasteam.friends.setRichPresence('text', txt)
end


function SteamSys:newWorld(world_table)
    count_endless = false

    local fn = presences[world_table.type]
    if fn and luasteam then
        local text = fn(world_table)
        setPText(text)
    end

    if world_table.type == "endless" then
        count_endless = true
        setAchievement("endless")
    end
    if world_table.type == "basic" and world_table.tier == 5 then
        setAchievement("invisible")
    end
end



function SteamSys:heavyupdate()
    if luasteam and count_endless then
        local txt = presences.endless()
        setPText(txt)
    end
end




function SteamSys:quit()
    luasteam.shutdown()
end

