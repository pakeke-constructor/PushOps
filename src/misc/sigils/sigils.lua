
local Sigils = { }


local pth = Tools.Path(...)

Tools.req_TREE(pth:gsub("%.","/") .. "/_sigils", Sigils)

assert(Sigils.strength, "Hmm, req_TREE not working")

local baseSigil = { 
    added = function()end
    ,removed = function()end
    ,update = function()end
    ,draw = function()end
    ,staticUpdate = function()end
}


local Sigil_mt = {
    __index = baseSigil
}




for k,v in pairs(Sigils) do

    setmetatable(v, Sigil_mt)

end






return Sigils