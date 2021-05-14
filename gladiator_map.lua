

local s = [[
..#########..
.####l##ll##.
###l%%%%%l###
##l%%   %%l##
#l%%  ^  %%l#
##%  xMx  %##
##% ^^@^^ %##
##%  x^x  %l#
#l%%  ^  %%l#
##l%%   %%l##
###l%%%%%ll##
.###l#ll####.
..#########..
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
    
    
    