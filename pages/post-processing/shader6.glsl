/**
 * Gaussian noise
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform float u_amount;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture;
varying vec2 v_texcoord;

float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {        
    gl_FragColor = vec4(texture2D(u_texture,v_texcoord).rgb + vec3(rand(v_texcoord) - 0.5)*u_amount, 1.0);
}
