

--[[
    returns a function that returns
    a weighted selection from a table.

    Table must be of the form ::

    {
        [foo] = weight_1,
        [bar] = weight_2,
        [kek] = weight_3
    }

    And the returned function will choose a weight from
    that table appropriately.
]]

return function(tab)
    --[[
        tab : {
            ["foo"] = 0.1;  20% chance to pick "foo"
            ["bar"] = 0.4;  80% chance to pick "bar"
        }
    ]]

    local r
    if love then
        r = love.math.random
    else
        r = math.random
    end

    local k_order = { }
    local v_order = { }

    local SUM = 0
    for value, prob in pairs(tab) do
        SUM = SUM + prob
        table.insert(k_order, SUM)
        table.insert(v_order, value)
    end

    -- Okay, now keys should be uniformly distributed about 0 -> SUM.
    -- Return function to get a random value

    assert(#k_order > 0, "Need more options for weighted_selection!")
    assert(#v_order > 0, "Need more options for weighted_selection!")

    return function()
        local R = r() -- get random val (uniformly made double: 0 -> 1 )

        for i = 1, #k_order do
            local ke = k_order[i] / SUM
            if ke >= R then
                return v_order[i]
            end
        end

        return error("somehow, the weighted selection did not get a value. fix pls")
    end
end

