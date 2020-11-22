

local PATH = 'src/entities'


local Proxy = { }

local Ents = setmetatable({ }, {__newindex = function(t,k,v)
    if rawget(Proxy,k) then
        error("Entity file already had the name : "..k .. ". Duplicate names not allowed!")
    end
    rawset(Proxy,k,v)
end})



local function req_TREE_push(PATH, tabl)
    for _,fname in ipairs(love.filesystem.getDirectoryItems(PATH)) do
        if fname:sub(1,1) ~= "_" then

            local proper_name = fname:gsub(".lua", "")

            fname = PATH.."/"..fname
            local info = love.filesystem.getInfo(fname)

            if info.type == "directory" then
                req_TREE_push(fname, tabl)
            else
                tabl[proper_name] = require(fname:gsub("/","."):gsub(".lua", ""))
            end
        end
    end
    return tabl
end



req_TREE_push(PATH, Ents)


-- This is actually where the entities are held
return Proxy
