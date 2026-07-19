shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

const mat4 dither_matrix = mat4(
vec4(0.0, 8.0, 2.0, 10.0),
vec4(12.0, 4.0, 14.0, 6.0),
vec4(3.0, 11.0, 1.0, 9.0),
vec4(15.0, 7.0, 13.0, 5.0)
) / 16.0;

void fragment() {
vec3 screen_color = texture(screen_texture, SCREEN_UV).rgb;

int x = int(FRAGCOORD.x) % 4;
int y = int(FRAGCOORD.y) % 4;
float dither_offset = dither_matrix[x][y] / 31.0;

vec3 quantized_color = floor((screen_color + dither_offset) * 255.0 / 8.0) / 31.0;

COLOR = vec4(quantized_color, 1.0);
}