


local weighted_selection = _G.Tools.weighted_selection

local PATH = Tools.Path(...):gsub("%.","%/")

local StructureGenRules = {}


do
    local function req_TREE(PATH)
        for _,fname in ipairs(love.filesystem.getDirectoryItems(PATH)) do
            if fname:sub(1,1) ~= "_" then
                fname = PATH.."/"..fname
                local info = love.filesystem.getInfo(fname)
                if info.type == "directory" then
                    req_TREE(fname)
                else
                    local structRule = require(fname:gsub("%/","%."):gsub(".lua", ""))

                    assert(structRule, "StructRule file empty or did not return")
                    assert(structRule.id, "StructRule not given an id")

                    assert(not (StructureGenRules[structRule.id]),
                    "Attempt to overwrite structureRule. Ensure structureRules have different `id`s.")
                    StructureGenRules[structRule.id] = structRule
                end
            end
        end
    end

    req_TREE(PATH)
end





for _, structRule in pairs(StructureGenRules) do
    
    -- Creates a random selection function from the ruleset.
    structRule.random = weighted_selection(
        structRule.structures
    )

    for structure, _ in pairs(structRule.structures) do
        for n=1,2 do
            for i, str in ipairs(structure[n]) do
                structure[n][i] = str:gsub(" ","")
            end
        end
    end
end


--[[

Table encoded as :::


{
    id1 = <structRule>
    id2 = <structRule>
    id3 = <structRule>

    etc
}



]]




return StructureGenRules

