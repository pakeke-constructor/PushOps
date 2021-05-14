

local gladiator_colour = {255, 243, 176}

for i,v in ipairs(gladiator_colour) do-- to normalized
    gladiator_colour[i] = v/255
end



return {

    entities = {

        ['M'] = {
            max
        }
        
        ['^'] = {
            max = 0xFFFFFFF;
            function(x,y)
                local grass = Ents.grass
                for i=1, rand(8,9) do
                    grass(x + rand(-50, 50), y + rand(-50, 50))
                end
            end
        };

        ['x'] = {
            max=0xff;
            function(x,y)
                local e =  Ents.pillar(x,y)
                e.colour = gladiator_colour
            end
        }

        ["#"] = {
            max=0xff;
            function(x,y)
                local grass = Ents.grass
                for i=1, rand(1,3) do
                    grass(x + rand(-50, 50), y + rand(-50, 50))
                end
            end
        }

        ["%"] = {
            max=0xfffff;
            function(x,y)
                Ents.inviswall(x,y)
                local pillar = Ents.pillar(x,y)
                pillar.colour = 
            end
        }
    
    
        ['l'] = {
            max = 100;
            function (x, y)
                Ents.pine(x+(rand()-.5)*20,y+(rand()-.5)*20)
            end
        }
    }
}

