
// main shader ==>

// lights
#define NUM_LIGHTS 7
uniform vec4  light_colours[NUM_LIGHTS]; // max NUM_LIGHTS lights at once
uniform vec2  light_positions[NUM_LIGHTS];
uniform int   light_distances[NUM_LIGHTS]; // this distance a light can be bright
uniform float light_heights[NUM_LIGHTS];

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


float hillfunc(int radius, float x, float height) {
    float u = (max(0,(-abs(x)/radius) + height));
    return u; 
}


vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords)
{

    vec4 light = base_lighting;

    for(int i=0; i<num_lights; i++){
        float dist_to_light = length(screen_coords - light_positions[i]);
        float strength = hillfunc(light_distances[i], dist_to_light, light_heights[i]);
        light += light_colours[i] * strength;
    }

    light.w = 1;

    // filmgrain :::
    vec2 sc;
    sc.x = screen_coords.x;
    sc.y = screen_coords.y;

    sc.x = floor(sc.x/period);
    sc.y = floor(sc.y/period);

    float r = 0.9 + amount * rand(sc);
    float g = 0.9 + amount * rand(sc + 91);
    float b = 0.9 + amount * rand(sc + 213);

    vec4 sprite_colour = Texel(texture, texture_coords);


    colour[0] *= r;
    colour[1] *= g;
    colour[2] *= b;


    vec4 addlight = vec4(light.xyz, 0);

    vec4 final;
    light = max(light, base_lighting);
    final = sprite_colour * colour * light;// + addlight/5;

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

