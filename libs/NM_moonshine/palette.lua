


return function(moonshine)
    local shader = love.graphics.newShader[[
      uniform vec3 fromColour[8];
      uniform vec3 toColour[8];

      vec4 effect(vec4 color, Image texture, vec2 tc, vec2 sc) {
        vec4 colour = Texel(texture, tc);
        float r = colour[0];
        float g = colour[1];
        float b = colour[2];

        vec3 given;
        given[0] = r;
        given[1] = g;
        given[2] = b;

        for (int i; i<8; i++){
            if (given == fromColour[i]) {
                return (vec4(toColour[i],1));
            }
        }
    }]]
    local r = love.math.random

    local setters = {}
  
    return moonshine.Effect{
      name = "palette",
      shader = shader,
      setters = {
      fromColour = function(v)
        shader:send("fromColour", (table.unpack or unpack)(v))
      end,
      toColour = function(v)
        shader:send("toColour", (table.unpack or unpack)(v))  
      end},
      defaults = {
          fromColour = {
              {0,0,0};
              {0,0,1};
              {0,1,0};
              {0,1,1};
              {1,0,0};
              {1,0,1};
              {1,1,0};
              {1,1,1}
          };
          toColour = {
              --[[
                    0 0 0   Black/outline
                    0 0 1   Special item colour (coin, shop, artefact)
                    0 1 0   Grass green
                    0 1 1   Dark green
                    1 0 0   Enemy/damage colour
                    1 0 1   Dark Enemy/damage colour
                    1 1 0   Grey
                    1 1 1   White (player colour)
              ]]
              {0,0,0};
              {0.1,0.1, 0.8};
              {0.3,0.8,0.3};
              {0.1, 1, 0.1};
              {0.8,0.2,0.2};
              {0.6,0,0};
              {0.5,0.5,0.5};
              {1,1,1}
          }
      }
    }
end




