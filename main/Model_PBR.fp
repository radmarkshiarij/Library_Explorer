#version 140

in highp vec4 var_position;
in mediump vec3 var_normal;
in mediump vec3 var_tangent;
in mediump vec3 var_bitangent;
in mediump vec2 var_texcoord0;
in mediump vec4 var_light;

out vec4 out_fragColor;

uniform mediump sampler2D tex0;
uniform mediump sampler2D tex_normal;
uniform mediump sampler2D tex_rough;

uniform fs_uniforms
{
	mediump vec4 tint;
};

void main()
{
	vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
	vec4 color = texture(tex0, var_texcoord0.xy) * tint_pm;

	mat3 TBN = mat3(normalize(var_tangent), normalize(var_bitangent), normalize(var_normal));
	vec3 mapped_normal = texture(tex_normal, var_texcoord0.xy).xyz * 2.0 - 1.0;
	mapped_normal.y = -mapped_normal.y;
	vec3 N = normalize(TBN * mapped_normal);

	float roughness = texture(tex_rough, var_texcoord0.xy).r;

	vec3 ambient_light = vec3(0.2);
	vec3 light_dir = normalize(var_light.xyz - var_position.xyz);
	float diffuse = max(dot(N, light_dir), 0.0);
	vec3 diff_light = clamp(vec3(diffuse) + ambient_light, 0.0, 1.0);

	vec3 view_dir = normalize(-var_position.xyz);
	vec3 half_dir = normalize(light_dir + view_dir);
	float shininess = mix(64.0, 4.0, roughness);
	float spec = pow(max(dot(N, half_dir), 0.0), shininess) * (1.0 - roughness);

	vec3 final_color = color.rgb * diff_light + vec3(spec);
	
	out_fragColor = vec4(final_color, 1.0);
}