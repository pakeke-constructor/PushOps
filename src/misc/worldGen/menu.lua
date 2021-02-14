
local s = [[
##################
#................#
#................#
#................#
#................#
#................#
#................#
#^..............^#
#...........^....#
#..^l............#
#.l..l....^..l...#
#..l..^^.........#
####.^^^^^..######
#..l.^..l..^^^...#
#...^l.^..^.^.l..#
#.l..^l^.@..^..^.#
#...l.^.^l^.l.^..#
##################
]]

local k = {}

for line in s:gmatch("[^\n]+") do
    local n = {}
    for i=1,line:len() do
        table.insert(n, line:sub(i,i))
    end
    table.insert(k,n)
end




return k