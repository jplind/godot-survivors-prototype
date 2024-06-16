shader_type canvas_item;

uniform float flash_opacity = 0;
uniform vec4 flash_color;

uniform sampler2D noise;
uniform float dissolve_value = 1.0;

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec3 mixed_color = mix(texture_color.rgb, flash_color.rgb, flash_opacity);
	float noise_value = texture(noise, UV).r;
	vec4 color = vec4(mixed_color, texture_color.a);
	color.a *= floor(dissolve_value + min(0.99, noise_value));
	
	COLOR = color;
}
