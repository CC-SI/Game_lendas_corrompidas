shader_type canvas_item;

uniform bool flash = false;
uniform float flash_strength = 1.0;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	if (flash) {
		COLOR = mix(tex_color, vec4(1.0, 1.0, 1.0, tex_color.a), flash_strength);
	} else {
		COLOR = tex_color;
	}
}