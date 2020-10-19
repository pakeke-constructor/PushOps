

local Array

Array = {
    __newindex = function(t, _, v)
        local len = t.len + 1
        table.insert(t,v)
        t.len = len
    end
    ;
    add = function(t, v)
        local len = t.len + 1
        table.insert(t,v)
        t.len = len
    end
}
Array.__index = Array

return function()
    return setmetatable({len = 0}, Array)
end



