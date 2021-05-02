

// main shader ==>

// lights
uniform vec4 light_colours[20]; // max 20 lights at once
uniform vec2 light_positions[20];
uniform int  light_distances[20]; // this distance a light can be bright

uniform int  num_lights;
uniform float max_light_strength; // the max light strength (good number is like 0.2 or something)
uniform vec4 base_lighting; // base_lighting will be something like <0.7, 0.7, 0.7>
uniform float brightness_modifier;

// noise
uniform float amount;
uniform float period;


//  colourblindness mode
uniform bool colourblind;
uniform bool devilblind;
uniform bool navyblind;




// thanks to stackoverflow.com/users/350875/appas for this function!
// very good pseudorandom generator
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    // Lighting :::
    vec4 light_mod = base_lighting;
    //vec2 middle_of_screen = love_ScreenSize.xy/2;
    vec4 adding_light;

    for(int i=0; i<num_lights; i++){
        //adding_light = vec4(0,0,0,1);
        float dist_to_light = length(screen_coords - light_positions[i]);
        //if (dist_to_light < light_distances[i]){
        
        adding_light = ((light_colours[i]*light_distances[i]))
                        / (sqrt(dist_to_light) * brightness_modifier);
        // Cap the light brightness so it cannot be too bright
        adding_light.x = max(min(max_light_strength, adding_light.x), -max_light_strength);
        adding_light.y = max(min(max_light_strength, adding_light.y), -max_light_strength);;
        adding_light.z = max(min(max_light_strength, adding_light.z), -max_light_strength);;
        
        //}
        light_mod += adding_light;
    }
    light_mod.w = 1;


    // filmgrain :::
    vec2 sc;
    sc.x = screen_coords.x;
    sc.y = screen_coords.y;

    sc.x = floor(sc.x/period);
    sc.y = floor(sc.y/period);

    float r = 0.9 + amount * rand(sc);
    float g = 0.9 + amount * rand(sc + 91);
    float b = 0.9 + amount * rand(sc + 213);

    // ORIGINAL ::
    // float am = 0.9 + amount * rand(sc);
   
    //color = Texel(texture, tc);
    //return  (color*am);

    vec4 colour = Texel(texture, texture_coords);

    for (int n=0;n<4;n++){
        light_mod[n] = min(1, light_mod[n]);
    }

    color[0] *= r;
    color[1] *= g;
    color[2] *= b;

    vec4 final;
    final = colour * color * light_mod; // originally  colour * color * light_mod

    if (colourblind){
        // switch blue and green
        float b_temp;
        b_temp = final[2];
        final[2] = final[1];
        final[1] = b_temp;
    }

    if (devilblind){
        // switch red and green! oooo
        float r_temp;
        r_temp = final[0];
        final[0] = final[1];
        final[1] = r_temp;
    }

    if (navyblind){
        // switch blue and red
        float n_temp;
        n_temp = final[2];
        final[2] = final[0];
        final[0] = n_temp;
    }

    return final;
}





