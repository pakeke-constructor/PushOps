

local req_TREE
--[[

Function that automatically runs all
lua files in the given directory, 
including sub folders.

]]


function req_TREE(PATH, shover)
    local T = love.filesystem.getDirectoryItems(PATH)

    table.stable_sort(T) -- Sorts by alphabetical I think?? hopefully she'll be right
    -- (basically we just need to be consistent across different OS; because lf.getDirectoryItems isn't)

    local shover = shover or {}

    for _,fname in ipairs(T) do
        if fname:sub(1,1) ~= "_" then
            local proper_name = fname:gsub("%.lua", ""):gsub("%.fnl", "")
            fname = PATH.."/"..fname
            local info = love.filesystem.getInfo(fname)

            if info.type == "directory" then
                req_TREE(fname, shover)
            else
                local ending = fname:sub(-4,-1)
                if (ending==".lua" or ending==".fnl") then
                    -- ignoring python and glsl files
                    shover[proper_name] = require(fname:gsub("/","."):gsub("%.lua", ""):gsub("%.fnl",""))
                end
            end
        end
    end

    return shover
end


return req_TREE