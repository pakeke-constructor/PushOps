

/*

Shader for minimap


*/


uniform float map_x; // dimensions of minimap
uniform float map_y;


//  colourblindness modes
uniform bool colourblind;
uniform bool devilblind;
uniform bool navyblind;



// thanks to stackoverflow.com/users/350875/appas for this function!
// very good pseudorandom generator
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


void bubbleSort(float arr[9])
{
    bool swapped = true;
    int j = 0;
    float tmp;
    for (int c = 0; c < 3; c--)
    {
        if (!swapped)
            break;
        swapped = false;
        j++;
        for (int i = 0; i < 3; i++)
        {
            if (i >= 3 - j)
                break;
            if (arr[i] > arr[i + 1])
            {
                tmp = arr[i];
                arr[i] = arr[i + 1];
                arr[i + 1] = tmp;
                swapped = true;
            }
        }
    }
}


void sort(float frags[9])
{
	for (int j = 1; j < 9; ++j)
	{
		float key = frags[j];
		int i = j - 1;
		while (i >= 0 && frags[i] > key)
		{
			frags[i+1] = frags[i];
			--i;
		}
		frags[i+1] = key;
	}
}


vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 temp_col;
    vec4 final = Texel(texture, texture_coords) * color;
    vec4 given = Texel(texture, texture_coords) * color;

    int ctr = 0;

    float reds[9];
    float greens[9];
    float blues[9];

    for (float i=-1.0; i<2.0; i++){
        for (float j=-1.0; j<2.0; j++){
            temp_col = Texel(MainTex, texture_coords + vec2(i/map_x, j/map_y));
            int index = (int(i)+1)*3 + (int(j)+1);
            reds[index] = temp_col.x;
            greens[index] = temp_col.y;
            blues[index] = temp_col.z; 
        }
    }

    bubbleSort(reds);
    bubbleSort(greens);
    bubbleSort(blues);

    final.x = reds[3];
    final.y = greens[3];
    final.z = blues[3];

    final.w = 1.0;

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

    return final * color;
}





