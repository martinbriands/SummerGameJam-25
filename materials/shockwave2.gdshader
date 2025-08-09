shader_type spatial;

uniform sampler2D SCREEN_TEXTURE;
uniform vec2 texture_scale = vec2(1.0, 1.0);

uniform sampler2D ring;

uniform vec2 center = vec2(0.91663348633318, 0.25392402266552);

uniform vec3 center_3D = vec3(-0.31, 0.179, 0.349);
//0.41132998395924 0.34367026670768
//uniform vec2 center = vec2(0.58867001604076, 0.65632973329232);
//0.91663348633318 0.25392402266552


void vertex() {
	// Called for every vertex the material is visible on.
    float scalar = 0.0;
    
    vec3 dist = center_3D - VERTEX; 
    float magnitude = sqrt(pow(dist.x, 2) + pow(dist.y, 2) + pow(dist.z, 2));
    
    if (magnitude <= 0.1)
    {
        scalar = (sin(TIME * 10.0) + 1.0) * 0.01;
    }
    
    VERTEX += NORMAL * scalar;
}

void fragment() {
	// Called for every pixel the material is visible on.
    
    ALBEDO = texture(SCREEN_TEXTURE, UV * texture_scale).rgb;
    
    float threshold = 0.1f;
    vec2 uv = UV.xy;
    uv.x *= 1.0;
    uv.y *= 1.0;
    
    uv.x = 1.0 - uv.x;
    
    vec2 dist = center - uv.xy;
    float magnitude = sqrt(pow(dist.x, 2) + pow(dist.y, 2));
    
    //if ((UV.x >= center.x - threshold && UV.x <= center.x + threshold)
    //&& (UV.y >= center.y - threshold && UV.y <= center.y + threshold))
    if (magnitude < threshold)
    {
        ALBEDO.r = 255.0;
    }
    
    if (
        UV.x < 0.5 
        && UV.x > 0.1
        //&& UV.y > 0.5 
        //&& UV.y < 0.6
         )
    {
        ALBEDO.b = 255.0;
    }
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
