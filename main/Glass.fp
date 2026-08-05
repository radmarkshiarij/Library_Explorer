#version 140

out vec4 color_out;

uniform fs_uniforms
{
	lowp vec4 tint;
};

void main()
{
	lowp vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
	color_out = tint_pm;
}