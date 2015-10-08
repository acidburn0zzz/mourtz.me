/**
 * Bulge/Pinch
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture;
uniform float u_radius;
uniform float u_strength;

varying vec2 v_texcoord;

#define center u_mouse/u_resolution

vec2 FX(vec2 coord){
    coord -= center;
    float distance = length(coord);
    if (distance < u_radius) {
        float percent = distance / u_radius;
        if (u_strength > 0.0) {
            coord *= mix(1.0, smoothstep(0.0, u_radius / distance, percent), u_strength * 0.75);
        } else {
            coord *= mix(1.0, pow(percent, 1.0 + u_strength * 0.75) * u_radius / distance, 1.0 - percent);
        }
    }
    coord += center;
    return coord;
}

void main( void ) {    
    vec2 TexCoords = FX(v_texcoord); 
    vec2 clampedCoord = clamp(TexCoords, vec2(0.0), vec2(1.0));
    
    if (TexCoords == clampedCoord) {
       gl_FragColor = texture2D(u_texture,TexCoords);
    }
    else{
        gl_FragColor = texture2D(u_texture,vec2(1.0));
    }
}
