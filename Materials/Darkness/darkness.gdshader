shader_type spatial;
render_mode unshaded, fog_disabled, blend_mix, depth_draw_never;

uniform sampler2D depth_texture : hint_depth_texture;
uniform vec3 color : source_color = vec3(0);
uniform float z_begin = 0.0;
uniform float z_end = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float depth = texture(depth_texture, SCREEN_UV).x;
	#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
	vec3 ndc = vec3(SCREEN_UV, depth) * 2.0 - 1.0;
	#else
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	#endif
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	vec4 world = INV_VIEW_MATRIX * INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	vec3 world_position = world.xyz / world.w;
	
	ALBEDO = color;
	ALPHA = clamp((world_position.z - z_begin) / (z_end - z_begin), 0.0, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
