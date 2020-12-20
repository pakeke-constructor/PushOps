



local tostring = tostring


local mutstr = {}

function mutstr:len()
    return self.length
end


mutstr.sub = table.concat


function mutstr:lower()
    for i = 1, self:len() do
        self[i] = self[i]:lower()
    end
    return self
end


function mutstr:reverse()
    local len = self.length
    for i = 1, self.length do
        self[i], self[len - i] = self[len - 1], self[i]
    end
    return self
end


function mutstr:rep( num )
    for i = 1, num-1 do
        
    end
end


local mutstr_mt = {}


mutstr_mt.__call = function(_, str)
    local new = setmetatable({
        length = 0;
    }, mutstr_mt)

    for i = 1, str:len() do
        new[i] = str:sub(i,i)
        new.length = new.length + 1;
    end

    return new
end


mutstr_mt.__eq = function(self, oth)
    if type(oth) == "string" then
        if self:len() ~= oth:len() then
            return false
        end

        for i = 1, self:len() do
            if self[i] ~= oth:sub(i,i) then
                return false
            end
        end
        return true
    else -- must be a table.
        if self:len() ~= oth:len() then
            return false
        end

        for i = 1, self:len() do
            if self[i] ~= oth[i] then
                return false
            end
        end
        return true
    end
end


mutstr_mt.__concat = function(self, str)
    if type(str) == "string" then
        for i = 1, str:len() do
            self[i] = str:sub(i,i)
            self.length = self.length + 1;
        end
    else -- is table (mutstr)
        for i = 1, str:len() do
            self[i] = str[i]
            self.length = self.length + 1;
        end
    end
end


mutstr_mt.__tostring = function(tabl)
    return table.concat( tabl )
end


