

local s = [[
##########################
##########################
##########################
###########l##ll##########
#######l%%%%%%%%%%%#######
######l%%         %%l#####
#####l%%     ^     %%l####
######%    ^ ^ ^    %l####
######%    ^ ^ ^    %l####
######%  ^   ^   ^  %#####
######%    ^^!^^    %#####
######%  ^   ^   ^  %l####
######%    ^ ^ ^    %l####
######%    ^ ^ ^    %l####
#####l%%     ^     %%l####
######l%%         %%l#####
#######l%%%%   %%%l#######
###########%   %##l#######
###########% @ %##########
###########%   %##########
###########%%%%%##########
 #########################
#########################
]]




local map = {}
    
for line in s:gmatch("[^\n]+") do
    local n = {}
    for i=1,line:len() do
        table.insert(n, line:sub(i,i))
    end
    table.insert(map, n)
end
    
return map
    
    
