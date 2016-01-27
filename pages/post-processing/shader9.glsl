/**
 * Old TV screen effect
 */
 
#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture;
varying vec2 v_texcoord;

void main() {
    // screen curve
    vec2 uv = v_texcoord;
    uv 		= (uv - 0.5) * 2.0;
    uv     *= 1.1;	
    uv.x   *= 1.0 + pow((abs(uv.y) * 0.2), 2.0);
    uv.y   *= 1.0 + pow((abs(uv.x) * 0.25), 2.0);
    uv 	 	= uv / 2.0 + 0.5;
    uv 		=  uv *0.92 + 0.04;
    uv      = clamp(uv, 0.0, 1.0);
    
    vec4 tex = texture2D(u_texture,vec2(uv.x,uv.y));
    
    // brightness
    float bright = - 0.05;
    
    vec3 col = tex.xyz + bright;
    col = clamp(col * 0.6 + 0.4 * col * col, 0.0, 1.0);
    
    // vignette effect
    float vig = (0.0 + 16.0 * uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y));
    col *= pow(vig, 0.3) * vec3(2.66, 2.94, 2.66);
    
    // scanline effect
    float scans = 0.35 + 0.35 * sin(3.5 + uv.y * u_resolution.y * 1.5);
    col = col*(0.3 + 0.7 * pow(scans, 1.7));
    
    gl_FragColor = vec4(col,1.0);
}