#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

#define zoom 3.0
#define MAX_ITERATIONS 100.0
#define MAX_DISTANCE 2.0

void main( void ) {
    // resize view matrix to imitate a 16:9 screen
    vec2 position = ( gl_FragCoord.xy * zoom / vec2(u_resolution.x, u_resolution.y));

    // Calculate starting values for Mandelbrot set for the pixel
    vec2 p0 = vec2(-zoom/2.0 - 1.0,-zoom/2.0) + position;

    float shade = 0.0;

    // Mandelbrot loop.
    vec2 p = vec2(0.0, 0.0);
    for (float i = 0.0; i < MAX_ITERATIONS ; i ++) {
        // break if point becomes greater than 2.0
        if (distance(p.x, p.y) > MAX_DISTANCE) break;

        // The famous Mandelbrot equation (p = p0+p^2)
        p = p0 + vec2(p.x*p.x - p.y*p.y, 2.*p.x*p.y);
        
        shade += 1.0/MAX_ITERATIONS;
    }

    gl_FragColor = vec4(vec3(shade),1.0);
}
