// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;


float length2( in vec2 p ) { return dot(p,p); }

const vec2 va = vec2(  0.0, 1.73-0.85 );
const vec2 vb = vec2(  1.0, 0.00-0.85 );
const vec2 vc = vec2( -1.0, 0.00-0.85 );

// return distance and address
vec2 map( vec2 p )
{
	float a = 0.0;
	vec2 c;
	float dist, d, t;
	for( int i=0; i<7; i++ )
	{
		d = length2(p-va);                 c = va; dist=d; t=0.0;
        d = length2(p-vb); if (d < dist) { c = vb; dist=d; t=1.0; }
        d = length2(p-vc); if (d < dist) { c = vc; dist=d; t=2.0; }
		p = c + 2.0*(p - c);
		a = t + a*3.0;
	}
	
	return vec2( length(p)/pow(2.0, 7.0), a/pow(3.0,7.0) );
}


void main()
{
	vec2 uv = (2.0*gl_FragCoord.xy - u_resolution.xy)/u_resolution.y;
	vec2 r = map( uv );
	
	vec3 col = 0.5 + 0.5*sin( 3.1416*r.y + vec3(0.0,5.0,5.0) );
	col *= 1.0 - smoothstep( 0.0, 0.02, r.x );
	
	gl_FragColor = vec4( col, 1.0 );
}