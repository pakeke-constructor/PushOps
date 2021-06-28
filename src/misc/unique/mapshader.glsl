

/*

Shader for minimap





*/


// thanks to stackoverflow.com/users/350875/appas for this function!
// very good pseudorandom generator
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    color[0] = sqrt(color[0]);
    color[1] = sqrt(color[1]);
    color[2] = sqrt(color[2]);

    if (length(color) < 0.1){
        color[3] = 0;
    }

    return color
}





