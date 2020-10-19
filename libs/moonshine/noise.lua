

return function(moonshine)
    local shader = love.graphics.newShader[[
      uniform float amount;
      uniform float period;

      float rand(vec2 co){
        return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
      }

      vec4 effect(vec4 color, Image texture, vec2 tc, vec2 sc) {

        sc.x = floor(sc.x/period);
        sc.y = floor(sc.y/period);

        float r = 0.9 + amount * rand(sc);
        float g = 0.9 + amount * rand(sc + 100);
        float b = 0.9 + amount * rand(sc + 200);
        
        // ORIGINAL ::
        // float am = 0.9 + amount * rand(sc);
        
        //color = Texel(texture, tc);
        //return  (color*am);

        color = Texel(texture, tc);
        
        color[0] *=r;
        color[1] *=g;
        color[2] *=b;
        return color;

    }]]
    local r = love.math.random

    local setters = {}
  
    return moonshine.Effect{
      name = "noise",
      shader = shader,
      setters = {amount = function(v)
        shader:send("amount", v)
      end,
      period = function(v)
        shader:send("period", v)  
      end},
      defaults = {amount = 0.2, period=2}
    }
end




