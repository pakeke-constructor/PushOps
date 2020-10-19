
--[[
    @module spacial_partition
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
        self:update_obj(obj)
    end
end



function Partition:update_obj(obj)
    -- ___rem and ___add functions have been inlined for performance.
    self:get_set(obj):remove(obj)                                     -- Same as self:___rem(obj)
    self[floor(obj.pos.x/self.size_x)][floor(obj.pos.y/self.size_y)]:add(obj) -- Same as self:___add(obj)
end



function Partition:___add(obj)
    self[floor(obj.pos.x/self.size_x)][floor(obj.pos.y/self.size_y)]:add(obj)
end


function Partition:___rem(obj)
    self:get_set(obj):remove(obj)
end



function Partition:add(obj)
    self.moving_objects:add(obj)
    self:___add(obj)
end


function Partition:remove(obj)
    self.moving_object:remove(obj)
    self.___rem(obj)
end


function Partition:frozen_add(obj)
    -- This obj stays in a constant position.
    -- Much more efficient- use when possible
    self:___add(obj)
end


local er1 =
[[Object disappeared from recorded location in spacial partitioner.
Ensure that your spacial hasher has a cell-size that is greater than the maximum velocity of any hashed object.

]]


function Partition:get_set(obj)
    local x, y = floor(obj.pos.x/self.size_x), floor(obj.pos.y/self.size_y)
    
    if (x ~= x) or (y ~= y) then -- Checking for nasty NaNs.
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

    -- Object has moved further than it's cell neighbourhood boundary.
    -- Throw err
    error(er1)
end



-- An extra function that will override Partition:get_set if a call to Partition:setGetters is made.
function Partition:modded_get_set(obj)
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
function Partition:modded_update_obj(obj)
    -- ___rem and ___add functions have been inlined for performance.
    self:get_set(obj):remove(obj)                                     -- Same as self:___rem(obj)
    self[floor(self.___getx(obj)/self.size_x)][floor(self.___gety(obj)/self.size_y)]:add(obj) -- Same as self:___add(obj)
end



function Partition:setGetters( x_getter, y_getter )
    assert(type(x_getter) == "function", "expected type function, got type:  " .. tostring(type(x_getter)))
    assert(type(y_getter) == "function", "expected type function, got type:  " .. tostring(type(y_getter)))
    self.___getx = x_getter
    self.___gety = y_getter

    self.get_set = self.modded_get_set
    self.___add = self.modded____add
    self.update_obj = self.modded_update_obj
end




-- Iteration handling... here we go
do
    local x, y, _, set_, current, X, Y, sel

    local iter
    iter = function( )
        -- If we are at end of set:
        if set_.size < current + 1 then
            if (X-x) < 1 then -- (X-x) will vary from -1 to 1. Same for (Y-y).
                X = X + 1
                set_ = sel[X][Y] -- change sets.
                current = 0 -- reset counter
                return iter()  -- try again; iteration failed
            else
                if (Y-y) < 1 then
                    Y = Y + 1
                    X = x - 1 -- revert X to base case.
                    set_ = sel[X][Y] -- change sets.
                    current = 0 -- reset counter
                    return iter() -- try again; iteration failed

                else -- Else, we have ended iteration, as Y and X have reached above the cell boundaries.
                    set_=nil
                    sel=nil -- (incase Partition is deleted, we dont want a memory leak)
                    return nil
                end
            end
        else
            current = current + 1
            return set_.objects[current]
        end
    end


    -- Iterates over spacial Partition that `obj_or_x` is in. (including `obj`)
    -- If `x` and `y` are numbers, will iterate over that spacial positioning Partition.
    function Partition:iter(obj_or_x ,y_)
        if y_ then
            -- obj is a number in this scenario; equivalent to  x.
            x = floor(obj_or_x/self.size_x)
            y = floor(y_/self.size_y)
            set_ = self[x-1][y-1]
            assert(set_, "Problem in spacial partitioner. `set_` is nil")
        else
            _, x, y = self:get_set(obj_or_x)
            set_ = self[x-1][y-1]
            assert(set_, "Problem in spacial partitioner. `set_` is nil")
        end

        X = x-1
        Y = y-1
        current = 0
        sel = self

        return iter
    end


    local lx, ly, _, l_set_, lcurrent, lX, lY, lsel

    local longiter
    longiter = function( )
        -- If we are at end of set:
        if l_set_.size < lcurrent + 1 then
            if (lX-lx) < 2 then -- (lX-lx) will varly from -1 to 1. Same for (lY-lY).
                lX = lX + 1
                l_set_ = lsel[lX][lY] -- change sets.
                lcurrent = 0 -- reset counter
                return longiter()  -- trly again; iteration failed
            else
                if (lY-ly) < 2 then
                    lY = lY + 1
                    lX = lx - 2 -- revert lX to base case.
                    l_set_ = lsel[lX][lY] -- change sets.
                    lcurrent = 0 -- reset counter
                    return longiter() -- trly again; iteration failed

                else -- Else, we have ended iteration, as lY and lX have reached above the cell boundaries.
                    l_set_=nil
                    lsel=nil -- (incase Partition is deleted, we dont want a memorly leak)
                    return nil
                end
            end
        else
            lcurrent = lcurrent + 1
            return l_set_.objects[lcurrent]
        end
    end


    function Partition:longiter(obj_or_x, y_)
        if y_ then
            -- obj is a number in this scenario; equivalent to  lx.
            lx = floor(obj_or_x/self.size_x)
            ly = floor(y_/self.size_y)
            l_set_ = self[lx-1][ly-1]
        else
            _, lx, ly = self:get_set(obj_or_x)
            l_set_ = self[lx-1][ly-1]
        end

        lX = lx-2
        lY = ly-2
        lcurrent = 0
        lsel = self

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


