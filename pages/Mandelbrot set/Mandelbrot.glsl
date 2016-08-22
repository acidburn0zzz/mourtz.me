#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

#define zoom 3.0
#define MAX_ITERATIONS 128.0
#define MAX_DISTANCE 2.0

void main( void ) {
	// resize view matrix to imitate a 16:9 screen
	vec2 position = gl_FragCoord.xy * zoom / u_resolution;

	// Calculate starting values for Mandelbrot set for the pixel
	vec2 p0 = vec2(-zoom/2.0 - 1.0,-zoom/2.0) + position;

	float shade = 0.0;

	// Mandelbrot loop.
	vec2 p = vec2(0.0, 0.0);
	for (float i = 0.0; i < MAX_ITERATIONS ; i ++) {
		// The famous Mandelbrot equation (p = p0+p^2)
		p = p0 + vec2(p.x*p.x - p.y*p.y, 2.*p.x*p.y);

		// break if point becomes greater than 2.0
		if (distance(p.x, p.y) > MAX_DISTANCE) break;

		shade++;
	}

	shade = 0.03*(shade - log2(log2(dot(p,p)))); 
	gl_FragColor = vec4(shade, shade, shade, 1.0);
}