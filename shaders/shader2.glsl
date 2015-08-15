#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159
uniform float u_time;
uniform vec2 u_mouse;
uniform vec2 u_resolution;
vec2 eyePosition=vec2(0.0,20.0);

bool inCircle(vec2 circleCenter, float radius)
{
	vec2 temp = gl_FragCoord.xy - circleCenter.xy;
	if(temp.x*temp.x+temp.y*temp.y<radius*radius) return true;
	return false;
}

bool inBorder(vec2 circleCenter, float radius,float PIxelWidth)
{
	vec2 temp = gl_FragCoord.xy - circleCenter.xy;
	if((temp.x*temp.x+temp.y*temp.y>radius*radius-PIxelWidth)&&(temp.x*temp.x+temp.y*temp.y<radius*radius)) return true;
	return false;
}

bool inMouth(vec2 circleCenter, float radius,float maxAngle)
{
	vec2 temp = gl_FragCoord.xy - circleCenter.xy;
	if(((temp.y>temp.x*sin(maxAngle))&&(temp.y<temp.x*sin(-maxAngle)))&&(temp.x*temp.x+temp.y*temp.y<radius*radius)) return true;
	return false;
}

bool inEye(vec2 circleCenter, vec2 eyePos,float eyeRadius)
{
	vec2 temp = gl_FragCoord.xy - circleCenter.xy- eyePos;
	if((temp.x*temp.x+temp.y*temp.y<eyeRadius*eyeRadius)) return true;
	return false;
}

void main( void ) {
	vec2 center = u_resolution/2.0;
	float radius = 50.0;
	vec3 color = vec3(0.0);
    vec3 pacman = vec3(0.0);
    center.x= mod(u_time*100.0,u_resolution.x);  
	
	if(inCircle(center, radius)){
        if(!inMouth(center, radius,mod(u_time*4.0,-PI)))
            pacman = vec3(1.0,1.0,-0.0);
        else 
            pacman = vec3(0.0);   
    }
	else{
   		pacman = vec3(0.0);     
    }
	
    if(inEye(center, eyePosition,6.0)||inBorder(center, radius,100.0)&&!inMouth(center, radius,mod(u_time*4.0,-PI))) 
    	pacman = vec3(0.0);
    
    if(center.x <= 140.0 && inCircle(vec2(150.0,center.y), radius/5.0))
        color += vec3(1.0,1.0,-0.0);

    if(center.x <= 215.0 && inCircle(vec2(225.0,center.y), radius/5.0))
        color += vec3(1.0,1.0,-0.0);

    if(center.x <= 290.0 && inCircle(vec2(300.0,center.y), radius/4.0))
        color += vec3(1.0,1.0,-0.0); 
       
    if(center.x <= 365.0 && inCircle(vec2(375.0,center.y), radius/5.0))
        color += vec3(1.0,1.0,-0.0);  
    
    if(center.x <= 440.0 && inCircle(vec2(450.0,center.y), radius/5.0))
        color += vec3(1.0,1.0,-0.0); 
    

	gl_FragColor= vec4(color + pacman,1.0);
}