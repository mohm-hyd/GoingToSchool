shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
//uniform bool is_grayscale = true;
uniform float fade_amount : hint_range(0.0, 1.0) = 0.0; 

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	    vec4 screen_color = texture(screen_texture, SCREEN_UV);
    
    // Calculate the grayscale version
    float luminance = dot(screen_color.rgb, vec3(0.299, 0.587, 0.114));
    vec4 grayscale_color = vec4(vec3(luminance), screen_color.a);
    
    // Smoothly mix between the original color and grayscale based on fade_amount
    COLOR = mix(screen_color, grayscale_color, fade_amount);
   // if (is_grayscale) {
     
     //   float luminance = dot(screen_color.rgb, vec3(0.299, 0.587, 0.114));
     //   COLOR = vec4(vec3(luminance), screen_color.a);
    //} else {
      //  COLOR = screen_color;
    //}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
