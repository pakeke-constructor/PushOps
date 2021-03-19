

local s = [[
##################..............
#...l..p.^^..^..^#...........l..
#^w.pp...p..^..^.#..............
#..^...p......^p.#..........l...
#..p....^l..^..^^#..............
#...p.l^^^pp.^l..#....l.........
#..l.^p^p^p^....^#..l..l.l......
#.....^pp^p.^.^..#.l..^l.....l..
#l.^lp..^....^.l.#..l.l.l.^.....
#..^.l.p.&^..^..^#.^l..^.l..^...
#.pl...^..p..^^..#.ll.^...^.^...
#.p.^.p^^..^...^.###############
#..l.^..l.p^^....#.............#
#####..^...^.#####..^.^.^.^.^..#
#....^.^.@..^..^.#.....^.^..^..#
#.^^..^.^.^...^..#..^...X......#
##################.....^^^.....#
.................#.p.^^....^.^.#
.................#......^...^..#
.................###############
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


