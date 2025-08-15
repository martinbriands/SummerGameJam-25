shader_type spatial;

uniform sampler2D SCREEN_TEXTURE;
uniform vec2 texture_scale = vec2(1.0, 1.0);

uniform vec3 center_3D = vec3(0.0,0.0,0.0);
uniform float intensity = 0.0;
uniform float time = 0.0;
uniform float wave_height = 0.2;

uniform sampler2D curve_texture;
uniform vec2 scroll_speed;

varying float height;

uniform vec3 oil_spills[10];
uniform float oil_spill_timers[10];
varying float oil;

uniform float oil_time = 5.0;

//0.41132998395924 0.34367026670768
//uniform vec2 center = vec2(0.58867001604076, 0.65632973329232);
//0.91663348633318 0.25392402266552


void vertex() {
	// Called for every vertex the material is visible on.
    float scalar = 0.0;

    vec3 dist = center_3D - VERTEX;
    float magnitude = sqrt(pow(dist.x, 2) + pow(dist.y, 2) + pow(dist.z, 2));

    if (magnitude <= 0.2)
    {
        scalar = texture(curve_texture, vec2(time - magnitude * 5.0, 0.0)).y * wave_height * (1.0 -(magnitude / 0.2)) * intensity;
    }

    height = scalar;

    VERTEX += NORMAL * scalar;
    
    for (int i = 0; i < oil_spills.length(); i++)
    {
        if (oil_spill_timers[i] >= 0.0)
        {
            vec3 dist = oil_spills[i] - VERTEX;
            float magnitude = sqrt(pow(dist.x, 2) + pow(dist.y, 2) + pow(dist.z, 2));
            
            if (magnitude < 0.2 * (1.0 - oil_spill_timers[i] / oil_time)) 
            {
                oil = max(oil, (1.0 - magnitude * 5.0));
            }
        }
    }
}

void fragment() {
	// Called for every pixel the material is visible on.

    ALBEDO = texture(SCREEN_TEXTURE, UV * texture_scale + vec2(TIME * scroll_speed.x, TIME * scroll_speed.y)).rgb;

    if (oil > 0.0)
    {
        //ALBEDO = vec3(.0, .0, .0);
        ALBEDO = mix(ALBEDO, vec3(0.0, 0.0, 0.0), oil);
        //ALBEDO = vec3(.0, .0, .0);
    }
    
    if (height > 0.0)
    {
        ALBEDO += vec3(height, height, height) * 10.0;
    }

    //
    //float threshold = 0.1f;
    //vec2 uv = UV.xy;
    //uv.x *= 1.0;
    //uv.y *= 1.0;
    //
    //uv.x = 1.0 - uv.x;
        //
    //vec2 dist = center - uv.xy;
    //float magnitude = sqrt(pow(dist.x, 2) + pow(dist.y, 2));
    //
    ////if ((UV.x >= center.x - threshold && UV.x <= center.x + threshold)
    ////&& (UV.y >= center.y - threshold && UV.y <= center.y + threshold))
    //if (magnitude < threshold)
    //{
        //ALBEDO.r = 255.0;
    //}
    //
    //if (
        //UV.x < 0.5
        //&& UV.x > 0.1
        ////&& UV.y > 0.5
        ////&& UV.y < 0.6
         //)
    //{
        //ALBEDO.b = 255.0;
    //}
    //
    //vec3 dist3D = center_3D - VERTEX;
    //float magnitude3D = sqrt(pow(dist3D.x, 2) + pow(dist3D.y, 2) + pow(dist3D.z, 2));
    //
    //if (magnitude <= 0.1)
    //{
        //ALBEDO.r = 255.0;
        //ALBEDO.g = 255.0;
        //ALBEDO.b = 255.0;
    //}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
