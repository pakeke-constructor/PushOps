

// main shader ==>

// lights
uniform vec4 light_colours[20]; // max 20 lights at once
uniform vec2 light_positions[20];
uniform int  num_lights;
uniform float max_light_strength // the max light strength (good number is like 0.2 or something)
uniform vec4 base_lighting; // base_lighting will be something like <0.7, 0.7, 0.7>


// noise
uniform float amount;
uniform float period;


float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    int dist_modifier = length(screen_coords) / 10;


    // Lighting :::
    vec4 light_mod = base_lighting;
    vec2 middle_of_screen = love_ScreenSize.xy/2;
    vec4 adding_light;

    for(int i=1; i++; i<=num_lights){
        adding_light = (light_colours[i] * dist_modifier)/sqrt(length(screen_coords - middle_of_screen));
        // Cap the light brightness so it cannot be too bright
        adding_light.x = min(max_light_strength, adding_light.x);
        adding_light.y = min(max_light_strength, adding_light.y);
        adding_light.z = min(max_light_strength, adding_light.z);
        light_mod += adding_light;
    }


    // filmgrain :::
    vec2 sc;
    sc.x = screen_coords.x;
    sc.y = screen_coords.y;

    sc.x = floor(sc.x/period);
    sc.y = floor(sc.y/period);

    float r = 0.95 + amount * rand(sc);
    float g = 0.95 + amount * rand(sc + 100);
    float b = 0.95 + amount * rand(sc + 200);
    
    // ORIGINAL ::
    // float am = 0.9 + amount * rand(sc);
        
    //color = Texel(texture, tc);
    //return  (color*am);

    color = Texel(texture, texture_coords);

    color[0] *= r;
    color[1] *= g;
    color[2] *= b;
    return color * light_mod;
}





