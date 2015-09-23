#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_mouse;
uniform vec2 u_resolution;

float julia(vec2 pos, vec2 a)
{
	const int iter = 100;
	const float pp = 0.01;
	float ret;
	vec2 ps;
	vec2 nps;
	
	ps = pos;
	ret = 0.0;
	
	for (int i = 0; i < iter; i++) {
		nps.x = ps.x * ps.x - ps.y * ps.y;
		nps.y = ps.x * ps.y + ps.x * ps.y;
		nps += a;
		ps = nps;
		if (sqrt(ps.x * ps.x + ps.y * ps.y) < 2.0) {
			ret += pp;
		}
	}
	return ret;
}

void main() {
	vec2 pos = (gl_FragCoord.xy*2.0 -u_resolution) / (2.0 * u_resolution.y);
	vec4 gs = vec4(vec3(julia(pos + vec2(-0.15, 0.5), vec2(0.38, 0.3))), 1.0);
	gl_FragColor = gs;
}
