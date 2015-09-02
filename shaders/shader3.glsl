#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;
uniform sampler2D backbuffer;

#define SAMPLE 50.0

bool isPixelated = false;
vec4 color = vec4(1.0);

void magic (inout vec4 c){
	vec2 position = gl_FragCoord.xy;
	vec2 l = u_resolution/vec2(SAMPLE);
	vec4 tt = c, cc = c;
	float h1 = 0.,h2 = 0.;
	
	for(float i = 1.0; i <= SAMPLE; i++){
		if(mod(gl_FragCoord.x,l.x*i) < 1.0){			
			cc = texture2D(backbuffer, vec2( l.x * i - h1, l.y * i -h1));
			h1++;
		}
		else{
			h1 = 0.0;
		}
		
		if(mod(gl_FragCoord.y,l.y*i) < 1.0){			
			cc = texture2D(backbuffer, vec2( l.x * i - h2, l.y * i -h2));
			h2++;
		}
		else{
			h2 = 0.0;
		}
	}

	c /= pow(cc,vec4(10.0));
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / u_resolution.xy );
	float amnt = 70.0;
	float nd = 0.0;
	vec4 cbuff = vec4(0.0);

	for(float i=0.0; i<5.0;i++){
	nd =sin(3.14*0.8*position.x + (i*0.1+sin(+u_time)*0.4) + u_time)*0.4+0.1 + position.x;
	amnt = 1.0/abs(nd-position.y)*0.01; 
	
	cbuff += vec4(amnt, amnt*0.3 , amnt*position.y, 09.0);
	}
	
	for(float i=0.0; i<1.0;i++){
	nd =sin(3.14*2.0*position.y + i*40.5 + u_time)*90.3*(position.y+80.3)+0.5;
	amnt = 1.0/abs(nd-position.x)*0.015;
	
	cbuff += vec4(amnt*0.2, amnt*0.2 , amnt*position.x, 1.0);
	}
	
	if(mod(u_time/5.,2.)<1.0)
		magic(cbuff);
	
	gl_FragColor =  cbuff;
}