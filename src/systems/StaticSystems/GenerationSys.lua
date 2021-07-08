

local GenSys = Cyan.System( )


local DEFAULT_WALL_THRESHOLD = 0.7-- Noise (0->1) must be >=0.7 to form a wall


-- Noise must be 0.1 lower than the DEFAULT_WALL_THRESHOLD in order
-- to spawn an object on this location.
-- This is done so objects don't spawn right next to walls.
local DEFAULT_EDGE_THRESHOLD = 0.2


-- Frequency modifier of noise. 
local FREQUENCY = 1.2


local WALL_BORDER_LEN = 6


--[[

World map will be encoded by a 2d array of characters. (strings)
Capital version of any character stands for "spawn multiple."

If brackets are used, that means "spawn everything inside the brackets."
i.e. '(pqe)' means spawn physics object, spiky object, and enemy


.  :  nothing (empty space)

#  :  wall

%  :  An invincible wall
~  :  A decoration entity to be placed outside border

e  :  enemy spawn
r  :  rare enemy spawn
u  :  unique enemy spawn (i.e. crowd control enemy, enemies that are bad solo)
n  :  neutral mob spawn

!  :  Bossfight

$  :  shop (add this at the end)
c  :  coin (add this at the end)

@  :  player spawn
&  :  portal


p  :  physics object
q :  spiky physics object (damages player upon hit)


^  :  decoration area (grass, nice ground texture, etc)

l  :  large immovable structure (basically a solo wall, ie a pillar, tree, giant mushroom)

*  :  collectable artefact / trophy!!

]]


local PROBS = CONSTANTS.PROBS

local weighted_selection = require("libs.tools.weighted_selection")
local default_pick_function = weighted_selection(PROBS)
local rand = love.math.random





-- THESE TWO ARE NOT SAFE TO BE REQUIRED IMMEDIATELY!!! Will trigger creation of premature entities.
-- instead, these are required in :newWorld.
local StructureRules-- = require("src.misc.worldGen.structureGen._StructureGen")
local WorldTypes-- = require("src.misc.worldGen.worldTypes._worldTypes")





local noise = love.math.noise


local function getNoiseHeight(x, y, noise_offset_x, noise_offset_y)
    x,y = x * FREQUENCY, y * FREQUENCY
    local height = (noise((x/16)+noise_offset_x, (y/16)+noise_offset_y) + (noise(x/4+noise_offset_x, y/4+noise_offset_y)/4) +
            (noise((x/8)+noise_offset_x, (y/8)+noise_offset_y)/2)
            ) / 1.4676666   -- Had to normalize, because total noise was not at 0-1

    return height -- Value between 0 - 1.
end



local function getHeight(world, x, y)
    assert(world.heightMap, "world table not given heightmap in worldgen")
    return world.heightMap[x][y]
end



local function getChar(world, x, y, height, pick_function)
    -- height is a number between 0 -> 1
    local wall_threshold = world.wall_threshold or DEFAULT_WALL_THRESHOLD
    local edge_threshold = world.edge_threshold or DEFAULT_EDGE_THRESHOLD

    if height > wall_threshold then
        return "#"
    elseif height < (wall_threshold - edge_threshold) then
        -- could be anything! (within pick function constriction bounds)
        return pick_function()
    else
        return " "
    end
end


--[[
local function charIsAllowed(worldMap, wType, X, Y, c)
    local xcl_z = wType.entExclusionZones

    if not xcl_z[c] then
        return true
    end

    for ent_c, radius in pairs(xcl_z[c]) do
        -- (Square radius btw, not a circle!)
        for x= -radius, radius do
            if x+X > #worldMap then
                -- Passes because all other checks are out of bounds
                return true 
            end

            for y= -radius, radius do
                if y+Y > #worldMap[1] then
                    -- Passes onto next X iteration
                    goto skip
                end
                
                if worldMap[X+x] then
                    if worldMap[X+x][Y+y] == ent_c then
                        return false
                    end
                end
                
                -- TODO :
                -- im like 90% sure this ::skip:: is in the wrong place,
                -- but its been so long since i worked on this code
                ::skip::
            end
        end
    end
    return true -- Yay, is allowed. Now lets test this mofo.
end
]]


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
            if not(x == X and y == Y) then
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


local function genStructures(world)
    local worldMap = world.worldMap
    local structureRule = world.structureRule

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



local worldMap_mt
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


local er_missing_ents = "Missing entities table... what are you, stupid???????!! jk"
local entCounter_mt = {__index = function() return 0 end}


local function makeEnts(world)
    local worldMap = world.worldMap
    local worldType = world.worldType
    assert(worldMap, "world.worldMap does not exist")
    assert(worldType, "world.worldType does not exist")

    local ents = worldType.entities
    assert(ents, er_missing_ents)

    -- Hasher to count the occurance of every single entity.
    -- usage: { ["e"] = 5; }
    local entCounter = setmetatable({} , entCounter_mt) 

    for x=1, #worldMap do
        for y=1, #worldMap[1] do
            local eType = worldMap[x][y]
            if not eType then
                goto skip
            end
            entCounter[eType] = entCounter[eType] + 1
            if not(entCounter[eType] > ents[eType].max) then
                local height
                if world.heightMap then
                    if not world.heightMap[x] then
                        print("wmap x?? ",worldMap[x])
                        error()
                    end
                    height = world.heightMap[x][y]
                end

                ents[worldMap[x][y]][1](y*64, x*64, height)
                -- What? you have `(y*64, x*64)` as opposed to `(x*64, y*64)`?
                -- This is because for some reason, the "map matrix" for lack of a better word,
                -- was transposed. 
                -- flipping around X and Y will not do anything in theory, it just
                -- makes menus a lot easier to design
            end
            ::skip::
        end
    end

    entCounter = nil
end


local function makeWalls(world)
    local worldMap = world.worldMap
    local heightMap = world.heightMap
    local BLEN = WALL_BORDER_LEN

    for i=1, #worldMap do
        local ar = worldMap[i]
        local height_ar = heightMap[i]
        for j=1,BLEN do
            table.insert(ar, "~")
            table.insert(ar, 1, "~")

            table.insert(height_ar, 0)
            table.insert(height_ar, 1, 0)
        end
    end

    for i=1,BLEN do
        local q1 = {}
        local q2 = {}
        for i=1, #worldMap[1] do
            table.insert(q1, "~")
            table.insert(q2, "~")
        end
        table.insert(worldMap, 1, q1)
        table.insert(worldMap, q2)

        local h_q1 = {}
        local h_q2 = {}
        for i=1, #heightMap[1] do
            table.insert(h_q1, 0)
            table.insert(h_q2, 0)
        end
        table.insert(heightMap,1,h_q1)
        table.insert(heightMap,h_q2)
    end

    local xlen = #worldMap
    local ylen = #worldMap[1]

    for xx=BLEN, #worldMap-BLEN do
        worldMap[xx][BLEN] = "%"
        worldMap[xx][ylen-(BLEN)] = "%"  
    end

    for yy=BLEN, #worldMap[1]-BLEN do
        worldMap[BLEN][yy] = "%"
        worldMap[xlen-BLEN][yy] = "%"
    end
end


local function genRequiredStructures(world)
    do
        -- Need to do this function up
        return nil
    end
    local worldMap = world.worldMap
    local structureRule = world.structureRule

    local amount = love.math.random( structureRule.min_structures, structureRule.max_structures )
    
    local rand_x
    local rand_y

    for i = 1, amount do 
        local structure = structureRule.random()

        -- structure size on the X
        local sX = #(structure[1][1])
        -- structure size on the Y
        local sY = #(structure[1])
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



local function isWall(world, x, y)
    local worldMap = world.worldMap
    return  ((worldMap[x][y] == "%") or (worldMap[x][y] == "#") or (worldMap[x][y]=="~"))
end






local function isGoodFit(world, x, y)
    --[[
        returns whether the position is a fit
        (i.e, whether it is within the bounds of the worldMap,
        AND is greater than noise threshold)
        (AND has no walls next to it)
    ]]
    local is_within_border = (1 < x and x < world.x) and (1 < y and y < world.y)
    if not is_within_border then
        return false -- yeah its scuffed. The other tests gotta be chopped
    end

    for xoff=-1,1 do
        for yoff=-1,1 do
            if isWall(world, x + xoff, y + yoff) then
                return false -- its too close to a wall
            end
        end
    end

    local wall_threshold = world.wall_threshold or DEFAULT_WALL_THRESHOLD
    local edge_threshold = world.edge_threshold or DEFAULT_EDGE_THRESHOLD

    local h = world.heightMap[x][y]
    local good_noise = h < wall_threshold - edge_threshold

    return good_noise and (not isWall(world, x, y))
end




local function addPlayer(world)
    local worldMap = world.worldMap
    local heightMap = world.heightMap
    assert(#worldMap > 16 and #worldMap[1] > 16,
    "worldMap too small, this is too risky to spawn player in reliably.")
    for x = rand(5, 10), #worldMap do
        for y = rand(5, 10), #worldMap[1] do
            if isGoodFit(world, x, y) then
                worldMap[x][y] = "@"
                return x,y
            end
        end
    end
    error("player failed to generate in (this should never happen)")
end





local function findEmpty(world, X, Y)
    local worldMap = world.worldMap
    assert(worldMap, "world.worldMap is nil")

    if not isWall(worldMap, X, Y) then
        return X, Y
    end

    local n = 1

    repeat
        for x = -n, n do
            for y=-n, n do
                if ((y~=0) and (x~=0)) then
                    if (not isWall(worldMap, X+x, Y+y)) then
                        return X+x, Y+y
                    end
                end
            end
        end

        if n > 30 then
            return false -- lookup failed
        end

        n = n + 1
    until false
end

local function findGoodFit(world, X, Y)
    local worldMap = world.worldMap
    local heightMap = world.heightMap
    local worldMap = world.worldMap
    assert(heightMap, "what ??/ world.heightMap is nil ???")
    
    if isGoodFit(world, X, Y) then
        return X, Y
    end

    local n = 1
    local done = {
        -- 2d hasher with  N = 2*(10000 + x) * 3*(10000 + y)
        -- we offset by 10000 so no collisions with negative numbers
        
        [2*(10000 + 0) * 3*(10000 + 0)] = true -- This is the hash for 0,0.
        -- We dont want to search 0,0, so we add it to the `done` table
    }

    while 1 do
        for x = -n, n do
            for y=-n, n do
                if not done[2*(10000+x) * 3*(10000+y)] then
                    if (isGoodFit(world, X+x, Y+y)) then
                        return X+x, Y+y
                    end
                    done[2*(10000+x) * 3*(10000+y)] = true
                end
            end
        end

        if n > 30 then -- 30 is max tries
            return false -- lookup failed
        end

        n = n + 1
    end
end

local function addEnemies(world, player_x, player_y)
    --[[
        plan: How is this gonna work???
        
        Get the amount, sqrt the total enemies, and step across the map
        by each enemy count.
        Place them accordingly.
        Revoke the placement if the position is close to the player
    ]]
    local worldMap = world.worldMap
    local heightMap = world.heightMap
    local worldType = world.worldType
    local dist = Tools.dist

    local amount = worldType.enemies.n + math.floor(0.5+math.sin(6.3*rand()) * (worldType.enemies.n_var or 0))
    local big_amount = worldType.enemies.bign + math.floor(0.5+math.sin(6.3*rand()) * (worldType.enemies.bign_var or 0))

    local size = math.floor(math.sqrt(amount + big_amount))
    assert(size == size, "size is a nan. ohhh.. no")

    local width = #worldMap
    assert(worldMap[1],'wattt????')
    local height = #worldMap[1]

    for x = 1, size do
        for y = 1, size do
            local x_pos = math.floor((x / (size + 1)) * width)
            local y_pos = math.floor((y / (size + 1)) * height)

            local type
            if rand() <= (amount / (big_amount + amount)) then
                -- we choose small `e`.
                type = "e"
                amount = amount - 1
            else
                -- we choose big 'E'.
                type = "E"
                big_amount = big_amount - 1
            end

            x_pos, y_pos = findGoodFit(world, x_pos, y_pos)
            if x_pos and dist(player_x - x_pos, player_y - y_pos) > 4 then
                worldMap[x_pos][y_pos] = type
            end
        end
    end
end




local function procGenerateWorld(world)
    --[[
        generates world from scratch, according to the structureRule
    ]]
    local worldMap = world.worldMap
    local worldType = world.worldType
    assert(world.worldMap, "worldMap not in world table")
    assert(world.worldType, "worldType not in world table")

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

    local heightMap = {}
    for ii = 1, size_x do
        heightMap[ii] = {}
    end

    for X = 1, size_x do
        for Y = 1, size_y do
            local height = getNoiseHeight(X, Y, world.noise_offset_x, world.noise_offset_y)
            heightMap[X][Y] = height
            local c = getChar(world, X, Y, height, pick_function)
            worldMap[X][Y] = c
        end
    end

    world.heightMap = heightMap

    local rule_id = worldType.structureRule

    local structureRule
    if rule_id then
        structureRule = StructureRules[rule_id]
        if not structureRule then
            error("invalid structureRule id :: "..rule_id)
        end
    else
        assert(world.tier, ("worldtype %s did not have a tier"):format(world.type or '<nil type>'))
        local def_id = "default_T" .. tostring(world.tier)
        structureRule = StructureRules[ def_id ]
        if not structureRule then
            error("Default structureRule for tier "..tostring(world.tier).." did not exist")
        end
    end
    world.structureRule = structureRule

    genRequiredStructures(world)
    genStructures(world)
    makeWalls(world)
    local player_x, player_y = addPlayer(world)
    addEnemies(world, player_x, player_y)
    return player_x, player_y
end


local world_type
local world_tier



local function getPlayerXY(worldMap)
    for i=1, #worldMap do
        for j=1,#worldMap[i] do
            if worldMap[i][j] == "@" then
                return i,j
            end
        end
    end
end




-- ===>
-- callbacks here
-- ===>


function GenSys:newWorld(world, worldMap)
    -- These are now safe to be initialized, as we know All systems
    -- will have been initialized
    StructureRules = require("src.misc.worldGen.structureGen._StructureGen")
    WorldTypes = require("src.misc.worldGen.worldTypes._worldTypes")

    local tier = world.tier
    world_tier = tier
    assert(tier, "world type was not given a tier")

    local type = world.type
    world_type = type
    assert(type, "world type was not given a type")

    local worldType = WorldTypes[type][tier]
    world.worldType = worldType
    assert(worldType, "HUH? worldTypes[type][tier] gave nil")

    local player_x, player_y
    if not worldMap then
        worldMap = setmetatable({ }, worldMap_mt)
        world.worldMap = worldMap
        player_x, player_y = procGenerateWorld(world)
    else
        world.worldMap = worldMap
        player_x, player_y = getPlayerXY(worldMap)        
    end

    if WorldTypes[type][tier].construct then
        WorldTypes[type][tier].construct(world, worldMap,
                            player_y * 64, player_x * 64)
                    -- times by 64 to get real world pos
                    -- ALSO, WTF. The x and y are switched. Ahhh, I knew i
                    -- shouldnt have messed with this shit. Now there are
                    -- no excuses, this is literally spagetti code
    end

    makeEnts(world)

    ccall("finalizeWorld", world, world.worldMap)

    --[[  ]]
    for _,tab in ipairs(worldMap) do
        print(table.concat(tab, " "))
    end
    --]]
end





function GenSys:switchWorld(world, worldMap)
    if world_tier and world_type then
        local oldWType = WorldTypes[world_type][world_tier]
        if oldWType.destruct then
            oldWType.destruct( )
        end
    end
    ccall("purge")
    Cyan.flush()
    ccall("newWorld", world, worldMap)
end







-- Win and lose conditions
do
    local cam = require("src.misc.unique.camera")



    -- lose condition
    function GenSys:lose()
        local cam = require("src.misc.unique.camera")

        if world_tier and world_type then
            local wType = WorldTypes[world_type][world_tier]
            assert(wType.lose, "worldTypes must have a lose condition")
            wType.lose(cam.x, cam.y)
        end
    end


    -- win condition callbacks.
    -- these are pretty much all the same...
    do
        function GenSys:ratioWin()
            local cam = require("src.misc.unique.camera")

            if (not StructureRules) or (not WorldTypes)then
                return -- This means that :newWorld hasnt been called yet.
                -- very bizzare situation... but oh well.
            end

            if world_tier and world_type then
                local worldType = WorldTypes[world_type][world_tier]
                assert(worldType,"?? ")
                if worldType.ratioWin then
                    ccall('sound', "gong",0.5)
                    ccall("sound", "superbang",0.4) 
                    worldType.ratioWin(cam.x,cam.y)
                end
            end
        end


        function GenSys:voidWin()
            local cam = require("src.misc.unique.camera")

            if (not StructureRules) or (not WorldTypes)then
                return -- This means that :newWorld hasnt been called yet.
                -- very bizzare situation... but oh well.
            end

            if world_tier and world_type then
                local worldType = WorldTypes[world_type][world_tier]
                assert(worldType,"?? ")
                if worldType.voidWin then
                    ccall('sound', "gong",0.5)
                    ccall("sound", "superbang",0.4) 
                    worldType.voidWin(cam.x,cam.y)
                end
            end 
        end


        function GenSys:bossWin()
            local cam = require("src.misc.unique.camera")

            if (not StructureRules) or (not WorldTypes)then
                return -- This means that :newWorld hasnt been called yet.
                -- very bizzare situation... but oh well.
            end

            if world_tier and world_type then
                local worldType = WorldTypes[world_type][world_tier]
                assert(worldType,"?? ")
                if worldType.bossWin then
                    ccall('sound', "gong",0.5)
                    ccall("sound", "superbang",0.4) 
                    worldType.bossWin(cam.x,cam.y)
                end
            end 
        end
    end
end


