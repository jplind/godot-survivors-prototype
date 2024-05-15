shader_type canvas_item;

uniform float flash_opacity = 0;
uniform vec4 flash_color;

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec3 mixed_color = mix(texture_color.rgb, flash_color.rgb, flash_opacity);
	
	COLOR.rgb = mixed_color;
	COLOR.a = texture_color.a;
}
