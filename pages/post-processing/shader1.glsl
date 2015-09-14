/**
 * Gaussian Blur
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform float u_blur;
uniform float u_time;
uniform vec2 u_resolution;
uniform sampler2D u_texture;
varying vec2 v_texcoord;

void magic(inout vec4 c){
    float offset[3];
    offset[0] = 0.0; 
    offset[1] = 1.3846153846*u_blur; 
    offset[2] = 3.2307692308*u_blur; 
    
    float weight[3];
    weight[0] = 0.2270270270;
    weight[1] = 0.3162162162;
    weight[2] = 0.0702702703;

    c = texture2D(u_texture, v_texcoord) * weight[0];
    for (int i=1; i<3; i++) {
        c += texture2D(u_texture, v_texcoord + vec2(offset[i])/u_resolution.x, 0.0) * weight[i];
        c += texture2D(u_texture, v_texcoord - vec2(offset[i])/u_resolution.x, 0.0) * weight[i];
    }
}

void main( void ) {   
    float z = gl_FragCoord.x/u_resolution.x > 0.5 ? 0.75 : 0.35;
    vec4 color = vec4(z, 1.0-z, 0.0,1.0);
    magic(color);
    gl_FragColor = color;
}