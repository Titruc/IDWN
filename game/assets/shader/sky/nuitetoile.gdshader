shader_type sky;
#include "res://addons/ShaderLib/Artistic/Artistic.gdshaderinc"


uniform float star_height = 1;
uniform float star_blend : hint_range(0.0,1.0,0.01) = 0.1;
uniform float depth_blend : hint_range(0.0, 1.0, 0.01)= 0.1;
uniform float star_size = 5.0;
uniform float flare_ratio : hint_range(0.0, 1.0, 0.01) = 0.1;
uniform int star_layers = 3;

vec2 randomvec2(vec2 seed)
{
	seed = fract(seed * vec2(567.45, 42.69));
	seed *= dot(seed, seed + 267.69);
	float x = fract(seed.x * 56.31415);
	float y = fract(seed.y * 98.2);
	return vec2(x,y) - 0.5;
}
float star(vec2 uv, float flare)
{
	float star = 0.01/length(uv);
	float rays = max(0, 1.0 - abs(uv.x * uv.y) * 1000.0) * star;
	star += rays * flare;
	return pow(star,3);
}

vec3 star_layer(vec2 uv)
{
	
	vec2 grid_uv = fract(uv) - 0.5;
	vec2 grid_id = floor(uv);
	vec3 stars = vec3(0.0);
	for(float y = -1.0 ; y <= 1.0 ; y++){
		for(float x = -1.0; x <= 1.0; x++){
			vec2 offset = vec2(x, y);
			vec2 rv = randomvec2(grid_id + offset);
			float size = (rv.x + 0.5)/star_size;
			float animated_size = size * (abs(sin(TIME * rv.y)) + 0.1);
			float flare = abs(rv.x) * 3.0 * smoothstep((1.0 - flare_ratio) - 0.5 ,rv.x , 1);
			vec3 star_color = hue(vec3(1,0,0), rv.y, 1);
			star_color = vec3(star_color.r, star_color.r, star_color.r);
			star_color *= vec3(0.06 * (size), 1.0, 0.08 * size);
			if(size < 10.)
			{
				star_color = vec3(star_color.r, star_color.b, star_color.r);
			}
			
			stars += star(grid_uv - offset - rv,flare) * animated_size * star_color;
		}
		}
		return stars;
}

void sky() {
	COLOR = vec3(0,0,0);
	vec3 star = vec3(0.0);
	float blend = smoothstep(star_blend, 1, abs(EYEDIR.y));
	float depth_curve = pow(abs(EYEDIR.y), depth_blend);
	for(float i = 1.0; i <= float(star_layers);i++)
	{
		float blend = smoothstep(star_blend, 1, abs(EYEDIR.y));
		vec2 uv = EYEDIR.xz / depth_curve * star_height * i;
		uv += randomvec2(vec2(i, i + 42.0)) * i * 16.9;
		if(EYEDIR.y < 0.0)
		{
			uv += 30.0;
		}
		COLOR += star_layer(uv) * blend;
		
	}
	}

