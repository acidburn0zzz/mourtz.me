/**
 * Sobel Edge Detection
 */
 
#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture;
varying vec2 v_texcoord;

vec3 sobel(float stepx, float stepy, vec2 center){

    float tleft   = length(texture2D(u_texture,center + vec2(-stepx,stepy)).xyz);
    float left    = length(texture2D(u_texture,center + vec2(-stepx,0)).xyz);
    float bleft   = length(texture2D(u_texture,center + vec2(-stepx,-stepy)).xyz);
    float top     = length(texture2D(u_texture,center + vec2(0,stepy)).xyz);
    float bottom  = length(texture2D(u_texture,center + vec2(0,-stepy)).xyz);
    float tright  = length(texture2D(u_texture,center + vec2(stepx,stepy)).xyz);
    float right   = length(texture2D(u_texture,center + vec2(stepx,0)).xyz);
    float bright  = length(texture2D(u_texture,center + vec2(stepx,-stepy)).xyz);
 
    float x =  tleft + 2.0 * left + bleft  - tright - 2.0 * right  - bright;
    float y = -tleft - 2.0 * top  - tright + bleft  + 2.0 * bottom + bright;

    return vec3(length(vec2(x,y)));
}  
 
void main() {   
    gl_FragColor = vec4(sobel(1./u_resolution.x, 1./u_resolution.y, v_texcoord),1.0);
}