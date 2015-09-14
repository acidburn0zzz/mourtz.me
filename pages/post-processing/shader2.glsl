/**
 * HSV
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform vec3 u_vHSV;
uniform float u_time;
uniform vec2 u_resolution;
uniform sampler2D u_texture;
varying vec2 v_texcoord;

vec3 convertRGBtoHSV(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 convertHSVtoRGB(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main( void ) {   
    vec4 textureColor = texture2D(u_texture, v_texcoord);  
    
    textureColor.rgb = convertRGBtoHSV(textureColor.rgb);
    textureColor.rgb *= u_vHSV;
    textureColor.rgb = convertHSVtoRGB(textureColor.rgb);
    
    gl_FragColor = textureColor;
}