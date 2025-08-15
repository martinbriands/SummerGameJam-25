shader_type spatial;

uniform sampler2D noise;
uniform sampler2D noise2;

void vertex() {
	// Called for every vertex the material is visible on.
    //VERTEX += NORMAL * sin(TIME + UV.x * UV.y) / 100.0;
    
    VERTEX += NORMAL * (texture(noise2, UV + vec2(0.0, TIME * 0.01)).rgb.r) / 10.0;
}

void fragment() {
    
    vec3 texture = texture(noise, UV + vec2(TIME * 0.01, 0.0)).rgb;
    
	// Called for every pixel the material is visible on.
    ALBEDO = texture;
    
    if (texture.r > 0.6 + sin(TIME) / 100.0)
    {
        ALPHA = texture.r / 4.0;
    }
    else
    {
        ALPHA = 0.0f;
    }
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
