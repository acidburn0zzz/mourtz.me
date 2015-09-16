#ifdef GL_ES
precision mediump float;
#endif

uniform float u_amount;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture;
varying vec2 v_texcoord;

void main( void ) {     
    vec4 color = texture2D(u_texture,v_texcoord);
    float r = color.r;
    float g = color.g;
    float b = color.b;

    color.r = (r * (1.0 - (0.607 * u_amount))) + (g * (0.769 * u_amount)) + (b * (0.189 * u_amount));
    color.g = (r * 0.349 * u_amount) + (g * (1.0 - (0.314 * u_amount))) + (b * 0.168 * u_amount);
    color.b = (r * 0.272 * u_amount) + (g * 0.534 * u_amount) + (b * (1.0 - (0.869 * u_amount)));
    
    gl_FragColor = color;
}
