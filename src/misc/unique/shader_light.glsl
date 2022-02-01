
// Light shader ==>


// lights
#define NUM_LIGHTS 12
uniform vec4  light_colours[NUM_LIGHTS]; // max NUM_LIGHTS lights at once
uniform vec2  light_positions[NUM_LIGHTS];
uniform int   light_distances[NUM_LIGHTS]; // this distance a light can be bright
uniform float light_heights[NUM_LIGHTS];

uniform int  num_lights;
uniform float max_light_strength; // the max light strength (good number is like 0.2 or something)
uniform vec4 base_lighting; // base_lighting will be something like <0.7, 0.7, 0.7>
uniform float brightness_modifier;



float hillfunc(int radius, float x, float height) {
    float u = (max(0.0,(-abs(x)/float(radius)) + height));
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

    light.w = 1.0;
    
    light = max(light, base_lighting);
    return colour * light;
}




