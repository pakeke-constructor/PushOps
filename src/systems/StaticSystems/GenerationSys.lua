

local GenSys = Cyan.System( )


local DEFAULT_WALL_THRESHOLD = 0.8-- Noise (0->1) must be >=0.8 to form a wall


-- Noise must be 0.1 lower than the DEFAULT_WALL_THRESHOLD in order
-- to spawn an object on this location.
-- This is done so objects don't spawn right next to walls.
local DEFAULT_EDGE_THRESHOLD = 0.3

--[[

World map will be encoded by a 2d array of characters. (strings)
Capital version of any character stands for "spawn multiple."

If brackets are used, that means "spawn everything inside the brackets."
i.e. '(pqe)' means spawn physics object, spiky object, and enemy


.  :  nothing (empty space)

#  :  wall

%  :  A wall used to be here but was not important (surrounded by other walls)

e  :  enemy spawn
r  :  rare enemy spawn
u  :  unique enemy spawn (i.e. crowd control enemy, enemies that are bad solo)
n  :  neutral mob spawn

!  :  Bossfight

$  :  shop (add this at the end)
c  :  coin (add this at the end)

@  :  player spawn
&  :  exit level / next level


p  :  physics object
q :  spiky physics object (damages player upon hit)


^  :  decoration area (grass, nice ground texture, etc)

l  :  large immovable structure (basically a solo wall, ie a pillar, tree, giant mushroom)

*  :  collectable artefact / trophy!!

]]


local PROBS = {
    -- Probability of each character occuring.
    -- Each value is a weight and does not actually represent the probability.
    ["e"] = 0.03; -- 0.07 weight chance of spawning on random tile.
    ["E"] = 0.005;
    ["r"] = 0.02; -- 0.02 weight chance of spawning on random tile.
    ["R"] = 0.005;
    ["u"] = 0.01;
    ["U"] = 0.003;
    ["^"] = 0.8;
    ["l"] = 0.03;
    ["p"] = 0.3;
    ["P"] = 0.01;
    ["."] = 0.4
    -- Bossfights, artefacts, are done through special structure generator
    -- Walls, shops, player spawn, and player exit are done uniquely.
}


local weighted_selection = require("libs.tools.weighted_selection")
local default_pick_function = weighted_selection(PROBS)





-- THESE TWO ARE NOT SAFE TO BE REQUIRED IMMEDIATELY!!! Will trigger creation of premature entities.
-- instead, these are required in :newWorld.
local StructureRules-- = require("src.misc.worldGen.structureGen._StructureGen")
local WorldTypes-- = require("src.misc.worldGen.worldTypes._worldTypes")





local noise = _G.love.math.noise

local function getNoiseHeight(x, y, noise_offset_x, noise_offset_y)
    local height = (noise((x/16)+noise_offset_x, (y/16)+noise_offset_y) + (noise(x/4+noise_offset_x, y/4+noise_offset_y)/4) +
            (noise((x/8)+noise_offset_x, (y/8)+noise_offset_y)/2)
            ) / 1.4676666   -- Had to normalize, because total noise was not at 0-1

    return height -- Value between 0 - 1.
end



local function getChar(world, x, y, pick_function)
    -- height is a number between 0 -> 1
    local height = getNoiseHeight(x, y, world.noise_offset_x, world.noise_offset_y)

    local wall_threshold = world.wall_threshold or DEFAULT_WALL_THRESHOLD

    local edge_threshold = world.edge_threshold or DEFAULT_EDGE_THRESHOLD

    if height > wall_threshold then
        return "#"
    elseif height < (wall_threshold - edge_threshold) then
        -- could be anything! (within pick function constriction bounds)
        return pick_function()
    else
        return "."
    end
end



local function structureFits(worldMap, structure, wX, wY)
    --[[
        returns true if structure fits at x,y
        false otherwise.
    ]]
    local pattern = structure[1]

    for x = 1, #(pattern[1]) do
        for y = 1, #pattern do
            local chr = pattern[y]:sub(x,x)
            if chr == "?" then
                if (worldMap[wX + x][wY + y] == "#") then
                    return false
                end
            elseif not(chr == worldMap[wX + (x - 1)][wY + (y - 1)]) then
                return false
            end
        end
    end
    -- All characters have been checked- return true, buckeroo.
    return true
end




local function isSurroundedByWalls(worldMap, X, Y)
    for x = X-1,X+1 do 
        for y = Y-1, Y+1 do
            if x ~= X and y ~= Y then
                if worldMap[x][y] ~= "#" and worldMap[x][y] ~= "%" then
                    -- hits a non-wall! ret false
                    return false
                end
            end
        end
    end
    -- Makes it all the way without break condition
    return true
end

local function removeUselessStructs(worldMap)
    for x = 2, #worldMap - 1 do
        for y = 2, #worldMap[1] - 1 do
            local chr = worldMap[x][y]

            if isSurroundedByWalls(worldMap, x, y) then
                if chr == "#" then
                    worldMap[x][y] = "%" -- % denotes a blocked wall.
                else
                    worldMap[x][y] = "."
                end
            end
        end
    end

end


local function genStructures(worldMap, structureRule)

    local amount = love.math.random( structureRule.min_structures, structureRule.max_structures )
    
    local rand_x
    local rand_y

    for i = 1, amount do 

        local structure = structureRule.random()

        -- structure size on the X
        local sX = #(structure[1][1])
        -- structure size on the Y
        local sY = #(structure[1])
        --[[
            structure is a table of the form:
            {
                {"???",
                "???",
                "???"},
    
                {"^^^",
                "^#^",
                "^^^"}
            }
            See _StructureGen.lua for details.
        ]]
        
        -- Now, try to fit structure in X and Y position.
        for try = 1, structureRule.tries do
            rand_x = love.math.random(2, (#worldMap)-(sX+1))
            -- remember- spaces are ignored during world gen.
            rand_y = love.math.random(2, (#worldMap[1]) - (sY+1))

            if structureFits(worldMap, structure, rand_x, rand_y) then
                local transform = structure[2]

                for x = 1, #transform[1] do
                    for y = 1, #transform do
                        local chr = transform[y]:sub(x,x)
                        if (chr ~= "?") then
                            worldMap[rand_x + x][rand_y + y] = chr
                        end
                    end
                end
            end
        end
    end
end



local worldMap, worldMap_mt
do
    worldMap_mt =  { -- Just a simple 2d array
        __index = function(t, k)
            t[k] = { } return t[k]
        end
    }
end



--[[
    
# newWorld  {
#   x = 70    (150 units wide) (1 unit = 64 pixels)   
#   y = 70    (100 units tall)
#   type = "basic" 
#   tier = 1  (1 = easy, 2 = harder, 3 = hardest)
# }
]]


function GenSys:newWorld(world)

    -- These are now safe to be initialized, as we know All systems
    -- will have been initialized
    StructureRules = require("src.misc.worldGen.structureGen._StructureGen")
    WorldTypes = require("src.misc.worldGen.worldTypes._worldTypes")


    local tier = world.tier
    assert(tier, "world type was not given a tier")
    local type = world.type
    assert(type, "world type was not given a type")

    local worldType = WorldTypes[type][tier]

    worldMap = setmetatable({ }, worldMap_mt)

    local pick_function
    if worldType.probabilities then
        pick_function = weighted_selection(
            worldType.probabilities
        )
    else
        pick_function = default_pick_function
    end

    -- Check this over.
    -- Ensure that noise generation isn't doing anything wanky. If these
    -- offset values are too big, math.noise can yield weird artefacts.
    world.noise_offset_x = love.math.random(-10000, 10000)
    world.noise_offset_y = love.math.random(-10000, 10000)

    local size_x = world.x
    local size_y = world.y

    for X = 1, size_x do
        for Y = 1, size_y do
            worldMap[X][Y] = getChar(world, X, Y, pick_function)
        end
    end

    local rule_id = worldType.structureRule

    local default_structure_ids = {
        [1] = "default_T1",
        [2] = "default_T2",
        [3] = "default_T3"
    }

    local structureRule
    if rule_id then
        structureRule = StructureRules[rule_id]
        if not structureRule then
            error("invalid structureRule id :: "..rule_id)
        end
    else
        local def_id = default_structure_ids[tier]
        structureRule = StructureRules[ def_id ]
        if not structureRule then
            error("Default structureRule for tier "..tostring(tier).." did not exist")
        end
    end

    genStructures(worldMap, structureRule)

    removeUselessStructs(worldMap)

    -- ****
    -- Now assign entities to chars
    -- ****

    --[[
    World generation visualization.
    ]]
    for _,tab in ipairs(worldMap) do
        print(table.concat(tab, " "))
    end
    --]]

end

