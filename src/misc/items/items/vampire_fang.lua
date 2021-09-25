

-- Lifesteal

return {
    kill = function(player,ent)
        if ent.pos and ent.targetID=="enemy" then
            EH.Ents.lifetok(ent.pos.x,ent.pos.y)
        end
    end;

    description = "Strong lifesteal"
}




