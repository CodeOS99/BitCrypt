shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(0.2, 1.0, 0.2, 1.0); // Eerie green
uniform float pulse_speed : hint_range(0.1, 10.0) = 2.0;
uniform float glow_strength : hint_range(0.0, 1.0) = 0.6;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.15;

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec4 base = texture(TEXTURE, UV);

    // Flickering pulse
    float pulse = 0.8 + 0.2 * sin(TIME * pulse_speed + UV.y * 10.0);

    // Grainy corruption effect
    float noise = rand(UV + vec2(TIME * 0.1, 0.0));

    vec3 glow = glow_color.rgb * glow_strength * pulse;
    glow = mix(glow, vec3(0.0), step(1.0 - noise_strength, noise));

    vec3 final_color = base.rgb + glow;

    COLOR = vec4(final_color, base.a);
}
