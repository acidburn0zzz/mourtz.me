#ifdef GL_ES
precision mediump float;
#endif

#define SAMPLE 10.0

uniform float u_time;
uniform vec2 u_resolution;
uniform sampler2D u_texture;
varying vec2 v_texcoord;

void main( void ) {
    float dx = SAMPLE * (1./u_resolution.x);
    float dy = SAMPLE * (1./u_resolution.y);
    vec2 texCoords = vec2(dx*floor(v_texcoord.x/dx), dy*floor(v_texcoord.y/dy));
	
	gl_FragColor =  texture2D(u_texture, texCoords);
}