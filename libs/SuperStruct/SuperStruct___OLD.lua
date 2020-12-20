



local remove = function(tabl, item)
    for i, v in ipairs(tabl) do
        if v == item then
            table.remove(tabl, i)
        end
    end
end

local is_in = function(tabl, item)
    for _, v in ipairs(tabl) do
        if v == item then
            return true
        end
    end
end

local add = table.insert



local f_name_upvalue = nil

local call_all = function(STRUCT, a,b,c)
    local funcs = STRUCT.___functions[f_name_upvalue]
    for i=1, #funcs do
        funcs[i](STRUCT, a,b,c)
    end
end








local PATH = (...):gsub('%.[^%.]+$', '')

local deepcopy = require(PATH .. ".deepcopy")



local SuperStruct = {}

local SuperStruct_mt = {
    __index = SuperStruct;
    __call = function(struct)
        return struct:___new()
    end;

    __newindex = function(t,k,v)
        t.___PROXY[k] = v
        for _, chil in ipairs(t.___children) do
            
        end
    end
}




local SuperStruct_obj_mt = {
    __index = function(table, key)
        -- Mutable state like this is screwy, I know. This will run quick tho
        f_name_upvalue = key
        return call_all
    end
    __newindex = function()
        error("you aren't allowed to add new fields to superStruct objects. \n Should I change this?")
    end
}



--[[
    Superclass is a struct module that works with classes in a unique way.
    It is designed to make inheritance intuitive and spagetti-free.


    PLANNING :::

    Construction is the hard bit. How do you construct something when it relies on
    8 layers of ctor funcs???? Do you just force constructers to have no arguments ???

    Maybe there is no constructor; instead, when you create a struct, you specify what fields the object has.
    i.e:  local Position  =  SuperStruct { x=0, y=0 }        <-- this is probably best idea.

    The only immutable part of classes will be the initial template object!!
    ALL other struct fields must be fully mutable
]]

local array_2d_index = function(t,k) t[k] = {} return t[k] end

local function newSuperStruct( template )
    --[[
        @param template The template object this struct will be based off
        @return SuperStruct The struct that
    ]]
    local struct = {}
    struct.___attached = { } -- list of attached classes (parents)
    struct.___mt       =  SuperStruct_obj_mt -- metatable for objects

    -- 2d Array holding references to all functions
    struct.___functions = setmetatable({}, {__index = array_2d_index})

    -- template struct object.
    template = template or {}

    struct.___template = setmetatable(template, struct.___mt) -- template object

    struct.___children = { } -- list of children structs

    --[[ This table holds all the actual fields of the struct. It needs to be a proxy table for __newindex. 
        For example, if this is done:
        function MyStruct:update()
        end
        .update will be put in the ___PROXY table, and the MyStruct.update will == nil.
        The reason this is done is so if the function is modified, i.e. myStruct.update is changed,
        a warning can be sent out to all children structs to inform them that a change has been made, and for them to respond responsibly.
    ]]
    struct.___PROXY = { }

    return setmetatable(struct, SuperStruct_mt)
end



function SuperStruct:___new()
    return deepcopy( self.___template )
end



function SuperStruct:___modify_template(otherStruct)
    local template = self.___template
    for k,v in pairs(otherStruct.___template) do
        if is_in(template, k) then
            error("This SuperStruct already has a key value called " .. k .. ". Duplicate keys are not allowed!")
        else
            template[k] = v
        end
    end
end



function SuperStruct:___demodify_template(otherStruct)
    local template = self.___template
    for k,_ in pairs(otherStruct.___template) do
        template[k] = nil
    end
end



function SuperStruct:___modify_functions(otherStruct)
    local funcs = self.___functions
    for k, v in pairs(otherStruct) do
        if type(v) == "function" and not is_in(funcs[k], v) then
            add(funcs[k], v)
        end
    end
end



function SuperStruct:___demodify_functions(otherStruct)
    for k,v in pairs(otherStruct) do
        if type(v) == "function" then
            remove(self.___functions[k], v)
        end
    end
end



function SuperStruct:attach( otherStruct )
    if self == otherStruct then
        error "No... this won't work... sorry"
    end
    if is_in(otherStruct.___attached, self) then
        error "Attempted to add SuperStruct that had `self` attached to it.\nNo circular references sorry!"
    end

    add(self.___attached, otherStruct)
    add(otherStruct.___children, self)

    -- Modifying functions
    self:___modify_functions(otherStruct)

    -- Modifying template.
    self:___modify_template(otherStruct)
    return self
end






function SuperStruct:detach( otherStruct )
    remove(self.___attached, otherStruct)
    remove(otherStruct.___children, self)

    self:___demodify_template(otherStruct)
    return self
end




return newSuperStruct

