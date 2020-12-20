

local req_TREE
--[[

Function that automatically runs all
lua files in the given directory, 
including sub folders.

]]



function req_TREE(PATH, shover)
    local T = love.filesystem.getDirectoryItems(PATH)
    table.sort(T) -- Sorts by alphabetical I think?? hopefully she'll be right
    
    local shover = shover or {}

    for _,fname in ipairs(T) do
        if fname:sub(1,1) ~= "_" then
            local proper_name = fname:gsub("%.lua", "")
            fname = PATH.."/"..fname
            local info = love.filesystem.getInfo(fname)

            if info.type == "directory" then
                req_TREE(fname, shover)
            else
                shover[proper_name] = require(fname:gsub("/","."):gsub(".lua", ""))
            end
        end
    end

    return shover
end



return req_TREE


