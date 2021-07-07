

return function (x, y, height)
    local swall = EH.Ents.wall(x,y,height)
    swall.hp.hp = math.huge
    swall.hp.max_hp = math.huge
end


