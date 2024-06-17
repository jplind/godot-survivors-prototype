shader_type canvas_item;

uniform sampler2D burn_gradient;
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
	
	float d = (2.0 * dissolve_value + noise_value) - 1.0;
	float d_clamped = clamp(d, 0.0, 1.0);
	vec4 burn = texture(burn_gradient, vec2( d_clamped, 0.5));
	
	COLOR = color * burn;
}

   //fixed d = (2.0 * _DissolveValue + noiseVal) - 1.0;
   //fixed overOne = saturate(d * _GradientAdjust);
   //fixed4 burn = tex2D(_BurnGradient, float2( overOne, 0.5));
   //return mainTex * burn;