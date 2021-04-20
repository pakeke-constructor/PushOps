
--[[
    @module spatial_partition
    partition expects all objects added to have a `x` and `y` component


NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB

NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB


NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB


NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB


NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB


NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB


NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB


NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB


NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB


NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB


NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB






]]


-- path to file
local PATH = (...):gsub('%.[^%.]+$', '')

-- math set O(1) removal
local set = require(PATH..".sets")

local floor = math.floor


local Partition = {}



local mt = {__index = function(t,k)
    t[k] = setmetatable({}, {__index = function(te,ke)
        te[ke] = set()
        return te[ke]
    end})
    return t[k]
end}



function Partition:new(size_x, size_y)
    local new = {}
    new.size_x = size_x
    new.size_y = size_y

    new.moving_objects = set()

    for k, v in pairs(self) do
        new[k] = v
    end

    return setmetatable(new, mt)
end



function Partition:clear()
    for key, val in pairs(self) do
        if type(key) == "number" then
            self[key] = nil
        end
    end
end





function Partition:update()
    for _, obj in ipairs(self.moving_objects.objects) do
        self:updateObj(obj)
    end
end



function Partition:updateObj(obj)
    -- ___rem and ___add functions have been inlined for performance.
    self:getSet(obj):remove(obj)   -- Same as self:___rem(obj)
    self[floor(obj.pos.x/self.size_x)][floor(obj.pos.y/self.size_y)]:add(obj) -- Same as self:___add(obj)
end



function Partition:___add(obj)
    self[floor(obj.pos.x/self.size_x)][floor(obj.pos.y/self.size_y)]:add(obj)
end



function Partition:___rem(obj)
    self:getSet(obj):remove(obj)
end


function Partition:setPosition(obj, x, y)
    --[[
        Note that the user must change the x,y fields independently,
        after this function has been called
    ]]
    self:___rem(obj)
    self[floor(x/self.size_x)][floor(y/self.size_y)]:add(obj)
end


function Partition:add(obj)
    self.moving_objects:add(obj)
    self:___add(obj)
end


function Partition:remove(obj)
    self.moving_objects:remove(obj)
    self:___rem(obj)
end


function Partition:frozenAdd(obj)
    -- This obj stays in a constant position.
    -- Much more efficient- use when possible
    self:___add(obj)
end


local er1 =
[[Object disappeared from recorded location in spacial partitioner.
Ensure that your spacial hasher has a cell-size that is greater than the maximum velocity of any hashed object.

]]


function Partition:getSet(obj)
    local x, y = floor(obj.pos.x/self.size_x), floor(obj.pos.y/self.size_y)
    
    if (x ~= x) or (y ~= y) then -- Checking for nasty NaNs.
        Tools.dump(obj, "NaN found in entity position component. Good luck mate.. youll need it\n")
        error("Not a number (NaN) found in obj " .. tostring(obj) .. ". Ensure objects don't have NaN as their x or y fields.", 2)
    end

    local set_ = self[x][y]
    -- Try for easy way out: Assume the object hasn't moved out of it's cell
    if set_:has(obj) then
        return set_, x, y
    end
    -- This is what unnessesary performance squeezing looks like. (Used to be a loop)
    -- Horizontal and vertical cells are checked first as they are the most likely case.
    set_ = self[x-1][y]
    if set_:has(obj) then
        return set_, x-1, y
    end
    set_ = self[x+1][y] 
    if set_:has(obj) then
        return set_, x+1, y
    end
    set_ = self[x][y-1]
    if set_:has(obj) then
        return set_, x, y-1
    end
    set_ = self[x][y+1]
    if set_:has(obj) then
        return set_, x, y+1
    end
    set_ = self[x-1][y-1]
    if set_:has(obj) then
        return set_, x-1, y-1
    end
    set_ = self[x-1][y+1]
    if set_:has(obj) then
        return set_, x-1, y+1
    end
    set_ = self[x+1][y-1]
    if set_:has(obj) then
        return set_, x+1, y-1
    end
    set_ = self[x+1][y+1]
    if set_:has(obj) then
        return set_, x+1, y+1
    end
    --[[
    Old code::: This is functionally equivalent to above, above is slightly quicker tho
    (Just because we can directly examine the most likely changed positions of obj first)

    for X = x-1, x+1 do
        for Y = y-1, y+1 do
            set_ = self[X][Y]
            if set_:has(obj) then
                return set_, X, Y
            end
        end
    end]]
    
    -- THIS IS UNIQUE TO PUSH_GAME!!! 
    -- AGAIN, DOOOO NOOOOT push this to github as a standalone!!!!!!!!!
    Tools.dump(obj, "object disappeared from partition:  \n")

    -- Object has moved further than it's cell neighbourhood boundary.
    -- Throw err
    error(er1)
end



-- An extra function that will override Partition:getSet if a call to Partition:setGetters is made.
function Partition:moddedGetSet(obj)
    local x, y = floor(self.___getx(obj)/self.size_x), floor(self.___gety(obj)/self.size_y)
    local set_ = self[x][y]
    -- Try for easy way out: Assume the object hasn't moved out of it's cell
    if set_:has(obj) then
        return set_, x, y
    end
     -- This is what unnessesary performance squeezing looks like. (Used to be a loop)
    -- Horizontal and vertical cells are checked first as they are the most likely case.
    set_ = self[x-1][y]
    if set_:has(obj) then
        return set_, x-1, y
    end
    set_ = self[x+1][y] 
    if set_:has(obj) then
        return set_, x+1, y
    end
    set_ = self[x][y-1]
    if set_:has(obj) then
        return set_, x, y-1
    end
    set_ = self[x][y+1]
    if set_:has(obj) then
        return set_, x, y+1
    end
    set_ = self[x-1][y-1]
    if set_:has(obj) then
        return set_, x-1, y-1
    end
    set_ = self[x-1][y+1]
    if set_:has(obj) then
        return set_, x-1, y+1
    end
    set_ = self[x+1][y-1]
    if set_:has(obj) then
        return set_, x+1, y-1
    end
    set_ = self[x+1][y+1]
    if set_:has(obj) then
        return set_, x+1, y+1
    end
    --[[
    Old code::: This is functionally equivalent to above, above is slightly quicker tho
    (Just because we can directly examine the most likely changed positions of obj first)

    for X = x-1, x+1 do
        for Y = y-1, y+1 do
            set_ = self[X][Y]
            if set_:has(obj) then
                return set_, X, Y
            end
        end
    end]]
    -- Object has moved further than it's cell neighbourhood boundary.
    -- Throw err
    error(er1)
end

-- An extra function that will override Partition:___add if a call to Partition:setGetters is made.
function Partition:modded____add(obj)
    self[floor(self.___getx(obj)/self.size_x)][floor(self.___gety(obj)/self.size_y)]:add(obj)
end
-- An extra function that will override Partition:update_object if a call to Partition:setGetters is made.
function Partition:moddedUpdateObj(obj)
    -- ___rem and ___add functions have been inlined for performance.
    self:getSet(obj):remove(obj)                                     -- Same as self:___rem(obj)
    self[floor(self.___getx(obj)/self.size_x)][floor(self.___gety(obj)/self.size_y)]:add(obj) -- Same as self:___add(obj)
end



function Partition:setGetters( x_getter, y_getter )
    assert(type(x_getter) == "function", "expected type function, got type:  " .. tostring(type(x_getter)))
    assert(type(y_getter) == "function", "expected type function, got type:  " .. tostring(type(y_getter)))
    self.___getx = x_getter
    self.___gety = y_getter

    error("Why/where is this code running")
    self.getSet = self.moddedGetSet
    self.___add = self.modded____add
    self.updateObj = self.moddedUpdateObj
end




-- Iteration handling... here we go
do
    -- local x, y, set_, current, X, Y, sel  <OLD VARS>
    local _ -- (tells _G we arent making globals)

    local closure_caches = { }
    -- holds a table that keeps track of the instances of loops that are currently
     -- running. This way, we can have nested loops.

    local iter
    iter = function( )
        -- `inst` is a reference to this loop instances closure environment.
        -- again, this is done so nested loops are possible.
        local inst = closure_caches[#closure_caches]

        -- If we are at end of set:
        if inst.set_.size < inst.current + 1 then
            if (inst.X-inst.x) < 1 then -- (X-x) will vary from -1 to 1. Same for (Y-y).
                inst.X = inst.X + 1
                inst.set_ = inst.sel[inst.X][inst.Y] -- change sets.
                inst.current = 0 -- reset counter
                return iter()  -- try again; iteration failed
            else
                if (inst.Y-inst.y) < 1 then
                    inst.Y = inst.Y + 1
                    inst.X = inst.x - 1 -- revert X to base case.
                    inst.set_ = inst.sel[inst.X][inst.Y] -- change sets.
                    inst.current = 0 -- reset counter
                    return iter() -- try again; iteration failed

                else -- Else, we have ended iteration, as Y and X have reached above the cell boundaries.
                    inst.set_=nil
                    inst.sel=nil -- (incase Partition is deleted, we dont want a memory leak)
                    closure_caches[#closure_caches] = nil -- pop this iteration state from stack
                    return nil
                end
            end
        else
            inst.current = inst.current + 1
            return inst.set_.objects[inst.current]
        end
    end


    -- Iterates over spacial Partition that `obj_or_x` is in. (including `obj`)
    -- If `x` and `y` are numbers, will iterate over that spacial positioning Partition.
    
    function Partition:iter(obj_or_x ,y_)
        local inst = { } -- The state of this iteration.
                         -- We can't use closures, because locals are shared
        table.insert(closure_caches, inst)

        if y_ then
            -- obj is a number in this scenario; equivalent to  x.
            inst.x = floor(obj_or_x/self.size_x)
            inst.y = floor(y_/self.size_y)
            inst.set_ = self[inst.x-1][inst.y-1]
            assert(inst.set_, "Problem in spacial partitioner. `set_` is nil")
        else
            _, inst.x, inst.y = self:getSet(obj_or_x)
            inst.set_ = self[inst.x-1][inst.y-1]
            assert(inst.set_, "Problem in spacial partitioner. `set_` is nil")
        end

        inst.X = inst.x-1
        inst.Y = inst.y-1
        inst.current = 0
        inst.sel = self

        return iter
    end


    --    local lx, ly, l_set_, lcurrent, lX, lY, lsel
     -- holds a table that keeps track of the instances of loops that are currently
     -- running. This way, we can have nested loops.
    local l_closure_caches = { }

    local longiter
    longiter = function( )
        local inst = l_closure_caches[#l_closure_caches]
        -- If we are at end of set:
        if inst.l_set_.size < inst.lcurrent + 1 then
            if (inst.lX-inst.lx) < 2 then -- (lX-lx) will varly from -1 to 1. Same for (lY-ly).
                inst.lX = inst.lX + 1
                inst.l_set_ = inst.lsel[inst.lX][inst.lY] -- change sets.
                inst.lcurrent = 0 -- reset counter
                return longiter()  -- try again; iteration failed
            else
                if (inst.lY-inst.ly) < 2 then
                    inst.lY = inst.lY + 1
                    inst.lX = inst.lx - 2 -- revert lX to base case.
                    inst.l_set_ = inst.lsel[inst.lX][inst.lY] -- change sets.
                    inst.lcurrent = 0 -- reset counter
                    return longiter() -- trly again; iteration failed

                else -- Else, we have ended iteration, as lY and lX have reached above the cell boundaries.
                    inst.l_set_=nil
                    inst.lsel=nil -- (incase Partition is deleted, we dont want a memorly leak)
                    l_closure_caches[#l_closure_caches]=nil --pop from stack
                    return nil
                end
            end
        else
            inst.lcurrent = inst.lcurrent + 1
            return inst.l_set_.objects[inst.lcurrent]
        end
    end


    function Partition:longiter(obj_or_x, y_)
        local inst = {} -- The state of this iteration.
                        -- We can't use closures, because locals are shared
        table.insert(l_closure_caches, inst)

        if y_ then
            -- obj is a number in this scenario; equivalent to  lx.
            inst.lx = floor(obj_or_x/self.size_x)
            inst.ly = floor(y_/self.size_y)
            inst.l_set_ = self[inst.lx-1][inst.ly-1]
        else
            _, inst.lx, inst.ly = self:getSet(obj_or_x)
            inst.l_set_ = self[inst.lx-1][inst.ly-1]
        end

        inst.lX = inst.lx-2
        inst.lY = inst.ly-2
        inst.lcurrent = 0
        inst.lsel = self

        return longiter
    end

    -- Aliases
    Partition.each = Partition.iter
    Partition.foreach = Partition.iter
    Partition.loop = Partition.iter

    Partition.longeach = Partition.longiter
    Partition.longforeach = Partition.longiter
    Partition.longloop = Partition.longiter
end



return function(size_x, size_y)
    size_x = size_x or error("A cell-size is needed to make spacial partitioner")
    size_y = size_y or size_x

    return Partition:new(size_x, size_y)
end


