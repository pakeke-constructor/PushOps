


local CB = { }
local CB_mt = { __index = CB }


local array_2d_index = function(t,k) t[k] = {} return t[k] end


local Callbacks = setmetatable({}, {__index = array_2d_index})




function CB.new()
    local CB_Manager = { }

                    -- 2d array.
    CB_Manager.Callbacks = setmetatable({}, {__index = array_2d_index})

    return setmetatable(CB_Manager, CB_mt)
end



function CB:on(callback_name, func)
    table.insert(self.Callbacks[callback_name], func)
    return self --method chain
end



function CB:call(callback_name, a,b,c,d,e,f)
    for _,each in ipairs(self.Callbacks[callback_name]) do
        each(a,b,c,d,e,f)
    end
    return self -- method chain
end



return CB.new

