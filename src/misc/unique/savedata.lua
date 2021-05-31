

local json = require("libs.NM_json.json")

local FNAME = CONSTANTS.SAVE_DATA_FNAME


if not love.filesystem.getInfo(FNAME) then
    local file, err = love.filesystem.newFile(FNAME, "w")
    if not file then
        error(err)
    end
    file:write(
        "{}" -- Nothing, dataSys should take care of this
    )
    file:close()
end


local fdat, err
fdat, err = love.filesystem.read(FNAME)
if not fdat then
    error(err)
end



local savedata = json.decode(fdat)

return savedata

