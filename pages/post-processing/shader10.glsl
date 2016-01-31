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
    
    // 1st way
    col = smoothstep(u_amount, u_amount+0.001, col);
    
    // 2nd way
    //if(col > u_amount)
    //    col = 1.0;
    //else
    //    col = 0.0;
    
    gl_FragColor = vec4(vec3(col) ,1.0);
}