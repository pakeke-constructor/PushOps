




local PATH = (...):gsub('%.[^%.]+$', '')

local deepcopy = require(PATH .. ".deepcopy")




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




-- The function name that is currently being called. This is a really unstable way of doing it but it runs fast.
-- (ie better than creating a new anony func each call)
local f_name_upvalue = nil

local function index(STRUCT, a,b,c)
    -- index function for SuperStruct objects.
    -- This function does the main work in ensuring call depth is considered
    local structs = STRUCT.___parent.___attached
    local fval
    for i=1, #structs do
        fval = structs[i][f_name_upvalue]
        if fval then
            fval(STRUCT, a,b,c)
        end
    end
    if STRUCT.___parent[f_name_upvalue] then
        STRUCT.___parent[f_name_upvalue](STRUCT, a,b,c)
    end

    return STRUCT --[[ For method chaining:
    -myStruct:method1()
    :method2()
    :method3()    
    ]]
end







local SuperStruct = {  }
local SuperStruct_mt = {
    __index = SuperStruct;

    __newindex = function(t,k,v)
        assert(type(v) == "function", "Only functions can be added to SuperStructs")
        rawset(t,k,v)
    end
}

local Obj_mt = {
    __index = function(t,k)
        f_name_upvalue = k
        return index
        --[[
            VERY VERY IMPORTANT THING TO KNOW FOR THIS::::

            When accessing functions of structs, the function MUST be called instantly.
                Eg:
                func = struct.update
                struct:draw()
                func(struct) -- Will call struct:draw() again. To see why, see `index` implementation above.
        ]]
    end
}



function SuperStruct:___new()
    -- Creates a new object from the SuperStruct.
    local new = deepcopy(self.___template or {})
    new.___parent = self
    return new
end
SuperStruct_mt.__call = SuperStruct.___new



function SuperStruct:___modify_template(otherStruct)
    local template = self.___template

    if (#otherStruct.___attached > 1) then
        error "Not allowed to attach SuperStructs with other SuperStructs attached.\nRemember: inheritance is evil! Only composition"
    end

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




function SuperStruct:attach(SS)
    add(self.___attached, SS)
    self:___modify_template(SS)
    return self
end


function SuperStruct:detach(SS)
    remove(self.___attached, SS)
    self:___demodify_template(SS)
    return self
end





return function( template, SS ) -- `SS` is an optional argument. Basically is just syntax sugar.
    SS = SS or {}
    
    SS.___template = setmetatable(template or {}, Obj_mt)

    SS.___attached = {}

    SS.___template.___parent = SS
    
    return setmetatable(SS, SuperStruct_mt)
end



