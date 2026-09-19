#version 140

in highp vec3 var_world_pos;
in highp vec3 var_world_normal;
in highp vec3 var_camera_pos;

out vec4 color_out;

uniform fs_uniforms
{
	lowp vec4 tint;
	lowp vec4 fresnel_power;
};

uniform samplerCube env_cubemap;

void main()
{
	vec3 normal = normalize(var_world_normal);
	vec3 view_dir = normalize(var_camera_pos - var_world_pos);

	if (dot(normal, view_dir) < 0.0) {
		normal = -normal;
	}

	float fresnel = pow(1.0 - clamp(dot(normal, view_dir), 0.0, 1.0), fresnel_power.x);

	vec3 reflect_dir = reflect(-view_dir, normal);
	vec3 env_color = texture(env_cubemap, reflect_dir).rgb;

	vec3 final_color = mix(tint.rgb, env_color, fresnel);
	float final_alpha = mix(tint.a, 1.0, fresnel);

	color_out = vec4(final_color * final_alpha, final_alpha);
}