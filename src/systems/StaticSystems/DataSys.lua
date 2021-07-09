
--[[

Stores data across playthroughs

]]

local SaveDataSys = Cyan.System( )

local json = require("libs.NM_json.json")
local data = require("src.misc.unique.savedata")


--[[

Ensure saveData is up to data

]]
for k,v in pairs(CONSTANTS.SAVE_DATA_DEFAULT) do -- This is the default save data state
    if not data[k] then
       data[k] = v
    end
end

function SaveDataSys:load()
    CONSTANTS.SFX_VOLUME = data.sfx_volume
    CONSTANTS.MUSIC_VOLUME = data.music_volume
end


function SaveDataSys:quit()
    data.sfx_volume = CONSTANTS.SFX_VOLUME
    data.music_volume = CONSTANTS.MUSIC_VOLUME
    love.filesystem.write(CONSTANTS.SAVE_DATA_FNAME, json.encode(data))
end

function SaveDataSys:update()
end



