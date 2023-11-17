shader_type spatial; 
uniform vec4 color: source_color;
uniform sampler2D alpha_tex;
uniform vec2 subdivisions = vec2(100,100);

void fragment() {
	float alpha = step(0.1, texture(alpha_tex, UV*subdivisions).a);
	ALBEDO = color.rgb;
	ALPHA = alpha * smoothstep(0,1, UV.y*2.0);
}
