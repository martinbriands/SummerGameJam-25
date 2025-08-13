shader_type spatial;

uniform sampler2D noise;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    
    vec3 texture = texture(noise, UV + vec2(TIME * 0.01, 0.0)).rgb;
    
	// Called for every pixel the material is visible on.
    ALBEDO = texture;
    
    if (texture.r > 0.5)
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
