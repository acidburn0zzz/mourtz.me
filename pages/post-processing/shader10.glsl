/**
 * Colors Threshold
 */
 
#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture;
uniform float u_amount;
varying vec2 v_texcoord;

void main() {
    vec4 tex = texture2D(u_texture,v_texcoord);
    
    float col = (tex.x + tex.y + tex.z)/3.0;
    col = smoothstep(u_amount, u_amount+0.001, col);
    gl_FragColor = vec4(vec3(col) ,1.0);
}