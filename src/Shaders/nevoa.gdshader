shader_type canvas_item;

uniform float fog_intensity : hint_range(0.0, 1.0);
uniform vec4 fog_color;
uniform float speed = 1.0;
uniform float scale = 100.0;

void fragment() {
    float wave = sin((UV.x + TIME * speed) * scale) * 0.5 +
                 cos((UV.y + TIME * speed * 0.8) * scale) * 0.5;

    float animated_intensity = clamp(fog_intensity + wave * 0.1, 0.0, 1.0);

    COLOR = vec4(fog_color.rgb, animated_intensity);
}