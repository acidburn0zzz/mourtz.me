/**
 * Original: http://www.geeks3d.com/20110408/cross-stitching-post-processing-shader-glsl-filter-geexlab-pixel-bender/
 */
 
#ifdef GL_ES
precision mediump float;
#endif

#define stitching_size 8.0

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture;
varying vec2 v_texcoord;

void main( void ) {     
    int invert;
    if(mod(u_time/4.0,2.0)<1.0)
        invert =1 ;
    else 
        invert = 0;
        
    vec2 cPos = v_texcoord * u_resolution;
    vec2 tlPos = floor(cPos / vec2(stitching_size)) * stitching_size;
    
    int remX = int(mod(cPos.x, stitching_size));
    int remY = int(mod(cPos.y, stitching_size));
    
    if (remX == 0 && remY == 0)
        tlPos = cPos;
        
    vec2 blPos = tlPos;
    blPos.y += (stitching_size - 2.0);
    
    if ((remX == remY) || (int(cPos.x) - int(blPos.x)) == (int(blPos.y) - int(cPos.y)))
    {
        if (invert == 1)
          gl_FragColor = vec4(0.2, 0.15, 0.05, 1.0);
        else
          gl_FragColor = texture2D(u_texture, tlPos * vec2(1.0/u_resolution.x, 1.0/u_resolution.y)) * 1.4;
    }
    else
    {
        if (invert == 1)
          gl_FragColor = texture2D(u_texture, tlPos * vec2(1.0/u_resolution.x, 1.0/u_resolution.y)) * 1.4;
        else
          gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    } 
}
