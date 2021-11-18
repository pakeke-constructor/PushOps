
// main shader ==>

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


vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords)
{

    // filmgrain :::
    vec2 sc;
    sc.x = screen_coords.x;
    sc.y = screen_coords.y;

    sc.x = floor(sc.x/period);
    sc.y = floor(sc.y/period);

    float r = 0.9 + amount * rand(sc);
    float g = 0.9 + amount * rand(sc + 91);
    float b = 0.9 + amount * rand(sc + 213);

    colour *= vec4(r,g,b,1);
    vec4 final = Texel(texture, texture_coords) * colour;

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

