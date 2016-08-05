#ifdef GL_ES
  precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform bool u_mouse_down;
uniform int u_piano_tiles [32];

const vec3 bg_color = vec3(0.5,0.9,1.0);
const vec3 black_tile_color = vec3(0.0);
const vec3 start_tile_color = vec3(0.0,0.5,0.7);

#define tile_height u_resolution.y/4.0
#define tile_width u_resolution.x/4.0
    
vec2 tiles_pivots[32];
int id = -1;

int getTileWhereMouse(){
    for(int i = 0; i < 16; i++){
        if (u_mouse.x >= tiles_pivots[i].x && u_mouse.x < tiles_pivots[i].x + tile_width &&
            u_mouse.y >= tiles_pivots[i].y && u_mouse.y < tiles_pivots[i].y + tile_height)
            return i;
    }     
    return -1;
}

void main( void ) {
    
    for(int x = 0; x < 4; x++){
        for(int y = 0; y < 4; y++){
            tiles_pivots[x*4+y] = vec2(x*int(tile_width), y*int(tile_height));

            if(id == -1){
                if(gl_FragCoord.x >= tiles_pivots[x*4+y].x && gl_FragCoord.x < tiles_pivots[x*4+y].x + tile_width &&
                    gl_FragCoord.y >= tiles_pivots[x*4+y].y && gl_FragCoord.y < tiles_pivots[x*4+y].y + tile_height)
                    id = x*4+y;
            }
        }
    }

    vec3 color = bg_color;
        
    // fist tile
    if(id == 8)
        color = start_tile_color;

    // tiles
    for(int i = 0; i < 4; i++){
        if(id == i*4+u_piano_tiles[i])
            color = black_tile_color;
    }

    int isMouseOver = getTileWhereMouse();
    if(id == isMouseOver && u_mouse_down)
        color = vec3(0.0,0.0,0.5);
        
    // grid
    for(int i = 0; i < 4; i++){
        if(gl_FragCoord.x > float(i)*tile_width - 2.0 && gl_FragCoord.x < float(i)*tile_width)
            color = vec3(0.0);
        if(gl_FragCoord.y > float(i)*tile_height - 2.0 && gl_FragCoord.y < float(i)*tile_height)
            color = vec3(0.0);
    }

    gl_FragColor = vec4(color,1.0);
}
