

-- Lifesteal

return {
    kill = function(player,ent)
        if ent.pos then
            EH.Ents.lifetok(ent.pos.x,ent.pos.y)
        end
    end
}


