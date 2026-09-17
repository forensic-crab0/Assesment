shader_type canvas_item;

uniform vec2 resolution = vec2(640.0, 360.0);
uniform float speed = 0.5;
uniform vec4 line_color : source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform vec4 grid_color : source_color = vec4(0.0, 0.2, 0.0, 1.0);
uniform float line_thickness = 0.005;
uniform float line_blur = 0.002;
uniform float dot_blur = 0.05;

vec4 draw_grid(vec2 uv) {
    vec2 grid_uv = fract(uv * 10.0);
    float grid_line = step(0.98, grid_uv.x) + step(0.98, grid_uv.y);
    return mix(vec4(0.0), grid_color, clamp(grid_line, 0.0, 1.0));
}

float segment_distance(vec2 p, vec2 a, vec2 b) {
    vec2 ba = b - a;
    vec2 pa = p - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

void fragment() {
    float aspect = resolution.x / resolution.y;
    vec2 uv = UV;
    uv.x *= aspect;

    // Base grid layout
    vec4 final_color = draw_grid(uv);

    vec2 points[8];
    points[0] = vec2(0.0 * aspect, 0.5);
    points[1] = vec2(0.3 * aspect, 0.5);
    points[2] = vec2(0.35 * aspect, 0.6);
    points[3] = vec2(0.4 * aspect, 0.2);
    points[4] = vec2(0.45 * aspect, 0.8);
    points[5] = vec2(0.5 * aspect, 0.45);
    points[6] = vec2(0.55 * aspect, 0.5);
    points[7] = vec2(1.0 * aspect, 0.5);

    float min_dist = 1.0;
    for (int i = 0; i < 7; i++) {
        float dist = segment_distance(uv, points[i], points[i + 1]);
        min_dist = min(min_dist, dist);
    }

    float progress = mod(TIME * speed, aspect);
    
    float trail = smoothstep(0.3, 0.0, progress - uv.x);
    if (uv.x > progress) {
        trail = 0.0;
    }

    float line_mask = smoothstep(line_thickness + line_blur, line_thickness, min_dist) * trail;
    
    float dot_x = progress;
    float dot_y = 0.5; 
    if (progress > 0.3 * aspect && progress < 0.55 * aspect) {
        dot_y = mix(0.5, 0.8, sin(progress * 10.0)); 
    }
    float dot_mask = smoothstep(0.02, 0.0, length(uv - vec2(dot_x, dot_y)));

    final_color += line_color * (line_mask + dot_mask);
    
    COLOR = final_color;
}
