shader_type canvas_item;

uniform sampler2D noise;
uniform float dissolve_value;

void fragment(){
	vec4 noise_texture = texture(noise, UV);
	vec4 mainTex = texture(TEXTURE, UV);
	float noise_value = texture(noise, UV).r;
	mainTex.a *= floor(dissolve_value + min(0.99, noise_value));
	COLOR = mainTex;
}
