shader_type canvas_item;

uniform bool invert = false;
uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    vec4 screen_col = texture(screen_texture, SCREEN_UV);
    if (invert) {
        screen_col.rgb = vec3(1.0) - screen_col.rgb;
    }
    COLOR = screen_col;
}
