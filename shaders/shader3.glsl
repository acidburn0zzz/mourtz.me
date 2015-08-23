/**
 * original: https://www.shadertoy.com/view/Xds3zN   colored
 * Created by inigo quilez - iq/2013
 * License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
 * A list of usefull distance function to simple primitives (animated), and an example 
 * on how to / do some interesting boolean operations, repetition and displacement.
 * More info here: http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
 **/

#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;

#define DOMINOS 5
#define flag true

float Plane( vec3 p )
{
  return p.y;
}

float Sphere( vec3 p, float radius )
{
  return length(p) - radius;
}

float Box( vec3 p, vec3 b )
{
  vec3 d = abs(p) - b;
  d += vec3(0.15,-0.2,0.0);
  return min(max(d.x, max(d.y, d.z)), 0.0) + length(max(d, 0.0));
}

vec3 rotateX(vec3 p, float a)
{
  float sa = sin(a);
  float ca = cos(a);
  return vec3(p.x, ca * p.y - sa * p.z, sa * p.y + ca * p.z);
}
vec3 rotateY(vec3 p, float a)
{
  float sa = sin(a);
  float ca = cos(a);
  return vec3(ca * p.x + sa * p.z, p.y, -sa * p.x + ca * p.z);
}
vec3 rotateZ(vec3 p, float a)
{
  float sa = sin(a);
  float ca = cos(a);
  return vec3(ca * p.x - sa * p.y, sa * p.x + ca * p.y, p.z);
}

float opS( float d1, float d2 )
{
  return max(-d2, d1);
}

vec2 opU( vec2 d1, vec2 d2 )
{
  return (d1.x < d2.x) ? d1 : d2;
}

vec2 map( in vec3 pos )
{
  vec3 r1, r2;
  float t = abs(sin(u_time/float(DOMINOS/2)))*float(DOMINOS)/1.5 - 2.0;
    
  vec3 sp = pos - vec3( t, 0.25, 0.5);
  vec2 res = vec2( Plane(pos), 104.8 ); 
    
  float angleZ;
    
  // Base color of dominos  
  float domino_color = 5.0;
  
  float dot_baseX = 0.0;  
  float dot_baseY = 0.7;  
  float dot_offsetX = 0.085;
  float dot_offsetY = 0.11;
  float dot_radius = 0.06;
  res = opU( res, vec2( Sphere(    sp, 0.25 ), 77.9 ) );
    for(int i =0; i<DOMINOS; i++){
        float x = opS(Box(pos - vec3(0.5*float(i), 0.4, 0.0), vec3(0.2) ),  Sphere(pos - vec3(0.5*float(i)+0.05,dot_baseY,dot_baseX-dot_offsetX), dot_radius ));
        x = opS(x, Sphere(pos - vec3(0.5*float(i)+0.05,dot_baseY,dot_baseX+dot_offsetX), dot_radius ));
        x = opS(x, Sphere(pos - vec3(0.5*float(i)+0.05,dot_baseY - dot_offsetY,dot_baseX), dot_radius ));
        x = opS(x, Sphere(pos - vec3(0.5*float(i)+0.05,dot_baseY - dot_offsetY*2.0,dot_baseX+dot_offsetX), dot_radius ));
       	x = opS(x, Sphere(pos - vec3(0.5*float(i)+0.05,dot_baseY - dot_offsetY*2.0,dot_baseX-dot_offsetX), dot_radius )); 
        
        x = opS(x, Sphere(pos - vec3(0.5*float(i)+0.05,dot_baseY - dot_offsetY*3.5,dot_baseX-dot_offsetX), dot_radius ));
        x = opS(x, Sphere(pos - vec3(0.5*float(i)+0.05,dot_baseY - dot_offsetY*4.5,dot_baseX), dot_radius )); 
        x = opS(x, Sphere(pos - vec3(0.5*float(i)+0.05,dot_baseY - dot_offsetY*5.5,dot_baseX+dot_offsetX), dot_radius )); 
        res = opU( res, vec2(x,domino_color));

    }
      
    dot_baseX = 1.0;  
    for(int i =0; i<DOMINOS; i++){
        float x = opS(Box(pos - vec3(0.5*float(i), 0.4, 1.0), vec3(0.2) ),  Sphere(pos - vec3(0.5*float(i)+0.05,dot_baseY,dot_baseX-dot_offsetX), dot_radius ));
        x = opS(x, Sphere(pos - vec3(0.5*float(i)+0.05,dot_baseY,dot_baseX+dot_offsetX), dot_radius ));
        x = opS(x, Sphere(pos - vec3(0.5*float(i)+0.05,dot_baseY - dot_offsetY,dot_baseX), dot_radius ));
        x = opS(x, Sphere(pos - vec3(0.5*float(i)+0.05,dot_baseY - dot_offsetY*2.0,dot_baseX+dot_offsetX), dot_radius ));
       	x = opS(x, Sphere(pos - vec3(0.5*float(i)+0.05,dot_baseY - dot_offsetY*2.0,dot_baseX-dot_offsetX), dot_radius )); 
        
        x = opS(x, Sphere(pos - vec3(0.5*float(i)+0.05,dot_baseY - dot_offsetY*3.5,dot_baseX-dot_offsetX), dot_radius ));
        x = opS(x, Sphere(pos - vec3(0.5*float(i)+0.05,dot_baseY - dot_offsetY*4.5,dot_baseX), dot_radius )); 
        x = opS(x, Sphere(pos - vec3(0.5*float(i)+0.05,dot_baseY - dot_offsetY*5.5,dot_baseX+dot_offsetX), dot_radius )); 
        res = opU( res, vec2(x,domino_color));
    }
    
    dot_baseX = 0.98;  
    r1 = rotateY (pos - vec3(0.5*float(DOMINOS), 0.4, 1.0), -0.4); 
    float x = opS(Box(r1, vec3(0.2)), Sphere(pos-vec3(0.5*float(DOMINOS)+0.07,dot_baseY,dot_baseX+dot_offsetX), dot_radius ) ); 
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.01,dot_baseY,dot_baseX-dot_offsetX), dot_radius ) );
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.03, dot_baseY - dot_offsetY,dot_baseX), dot_radius ));
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.07, dot_baseY - dot_offsetY*2.0,dot_baseX+dot_offsetX), dot_radius ));
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.01, dot_baseY - dot_offsetY*2.0,dot_baseX-dot_offsetX), dot_radius )); 
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.01, dot_baseY - dot_offsetY*3.5,dot_baseX-dot_offsetX), dot_radius ));
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.03, dot_baseY - dot_offsetY*4.5,dot_baseX), dot_radius )); 
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.07, dot_baseY - dot_offsetY*5.5,dot_baseX+dot_offsetX), dot_radius )); 
    res = opU( res, vec2(x,domino_color));
       
    dot_baseX = 0.7; 
    r1 = rotateY (pos - vec3(0.5*float(DOMINOS)+0.4, 0.4, 0.7), -1.1); 
    x = opS(Box(r1, vec3(0.2)), Sphere(pos-vec3(0.5*float(DOMINOS)+0.5,dot_baseY,dot_baseX+dot_offsetX - 0.1), dot_radius ) ); 
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.35,dot_baseY,dot_baseX-dot_offsetX), dot_radius ) );
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.42, dot_baseY - dot_offsetY,dot_baseX - 0.04), dot_radius));
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.5, dot_baseY - dot_offsetY*2.0,dot_baseX+dot_offsetX - 0.1), dot_radius ));
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.35, dot_baseY - dot_offsetY*2.0,dot_baseX-dot_offsetX), dot_radius )); 
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.35, dot_baseY - dot_offsetY*3.5,dot_baseX-dot_offsetX), dot_radius ));
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.42, dot_baseY - dot_offsetY*4.5,dot_baseX - 0.04), dot_radius )); 
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.5, dot_baseY - dot_offsetY*5.5,dot_baseX+dot_offsetX - 0.1), dot_radius )); 
    res = opU( res, vec2(x,domino_color));
    
    dot_baseX = 0.02;  
    r1 = rotateY (pos - vec3(0.5*float(DOMINOS), 0.4, 0.0), 0.4); 
    x = opS(Box(r1, vec3(0.2)), Sphere(pos-vec3(0.5*float(DOMINOS)+0.03,dot_baseY,dot_baseX+dot_offsetX), dot_radius ) ); 
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.09,dot_baseY,dot_baseX-dot_offsetX), dot_radius ) );
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.05, dot_baseY - dot_offsetY,dot_baseX), dot_radius));
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.03, dot_baseY - dot_offsetY*2.0,dot_baseX+dot_offsetX), dot_radius ));
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.09, dot_baseY - dot_offsetY*2.0,dot_baseX-dot_offsetX), dot_radius )); 
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.09, dot_baseY - dot_offsetY*3.5,dot_baseX-dot_offsetX), dot_radius ));
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.05, dot_baseY - dot_offsetY*4.5,dot_baseX), dot_radius )); 
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.03, dot_baseY - dot_offsetY*5.5,dot_baseX+dot_offsetX), dot_radius )); 
    res = opU( res, vec2(x,domino_color));


    dot_baseX = 0.3;  
    r1 = rotateY (pos - vec3(0.5*float(DOMINOS)+0.4, 0.4, 0.3), 1.1); 
    x = opS(Box(r1, vec3(0.2)), Sphere(pos-vec3(0.5*float(DOMINOS)+0.35,dot_baseY,dot_baseX+dot_offsetX), dot_radius ) ); 
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.5,dot_baseY,dot_baseX-dot_offsetX + 0.1), dot_radius ) );
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.42, dot_baseY - dot_offsetY,dot_baseX + 0.04), dot_radius));
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.35, dot_baseY - dot_offsetY*2.0,dot_baseX+dot_offsetX), dot_radius ));
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.5, dot_baseY - dot_offsetY*2.0,dot_baseX-dot_offsetX + 0.1), dot_radius )); 
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.5, dot_baseY - dot_offsetY*3.5,dot_baseX-dot_offsetX + 0.1), dot_radius ));
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.42, dot_baseY - dot_offsetY*4.5,dot_baseX + 0.04), dot_radius )); 
    x = opS(x, Sphere(pos - vec3(0.5*float(DOMINOS)+0.35, dot_baseY - dot_offsetY*5.5,dot_baseX+dot_offsetX), dot_radius )); 
    res = opU( res, vec2(x,domino_color));
    
    
  return res;
}

vec2 castRay( in vec3 ro, in vec3 rd )
{
  float tmin = 1.0;
  float tmax = 20.0;

  #if 0
    float tp1 = (0.0-ro.y) / rd.y; 
    if ( tp1>0.0 ) 
	  tmax = min( tmax, tp1 );
    float tp2 = (1.6-ro.y)/rd.y; 
    if ( tp2>0.0 ) 
    { 
      if ( ro.y>1.6 ) tmin = max( tmin, tp2 );
      else            tmax = min( tmax, tp2 );
    }
  #endif

  float precis = 0.002;
  float t = tmin;
  float m = -1.0;
  for ( int i=0; i<50; i++ )
  {
    vec2 res = map( ro+rd*t );
    if ( res.x<precis || t>tmax ) break;
    t += res.x;
    m = res.y;
  }

  if ( t>tmax ) m=-1.0;
  return vec2( t, m );
}

vec3 calcNormal( in vec3 pos )
{
  vec3 eps = vec3( 0.001, 0.0, 0.0 );
  vec3 nor = vec3(
  map(pos+eps.xyy).x - map(pos-eps.xyy).x, 
  map(pos+eps.yxy).x - map(pos-eps.yxy).x, 
  map(pos+eps.yyx).x - map(pos-eps.yyx).x );
  return normalize(nor);
}

vec3 render( in vec3 ro, in vec3 rd )
{ 
  vec3 col = vec3(0.8, 0.9, 1.0);
  vec2 res = castRay(ro, rd);
  float t = res.x;
  float m = res.y;
  if ( m>-0.5 )
  {
    vec3 pos = ro + t*rd;
    vec3 nor = calcNormal( pos );
    vec3 ref = reflect( rd, nor );

    // material        
    col = 0.25 + 0.3*sin( vec3(0.05, 0.08, 0.10)*(m-1.0) );

    if ( m<1.5 )
    {
      float f = mod( floor(5.0*pos.z) + floor(5.0*pos.x), 2.0);
      col = 0.4 + 0.1*f*vec3(1.0);
    }

    // lighting       
    vec3  lig = normalize( vec3(sin(u_time/20.0), 0.7, cos(u_time/20.0)) );
    float amb = clamp( 0.5+0.5*nor.y, 0.0, 1.0 );
    float dif = clamp( dot( nor, lig ), 0.0, 1.0 );
    float bac = clamp( dot( nor, normalize(vec3(-lig.x, 0.0, -lig.z))), 0.0, 1.0 )*clamp( 1.0-pos.y, 0.0, 1.0);
    float dom = smoothstep( -0.1, 0.1, ref.y );
    float fre = pow( clamp(1.0+dot(nor, rd), 0.0, 1.0), 2.0 );
    float spe = pow(clamp( dot( ref, lig ), 0.0, 1.0 ), 16.0);

    vec3 brdf = vec3(0.0);
    brdf += 1.20*dif*vec3(1.00, 0.90, 0.60);
    brdf += 1.20*spe*vec3(1.00, 0.90, 0.60)*dif;
    brdf += 0.30*amb*vec3(0.50, 0.70, 1.00);
    brdf += 0.40*dom*vec3(0.50, 0.70, 1.00);
    brdf += 0.30*bac*vec3(0.25, 0.25, 0.25);
    brdf += 0.40*fre*vec3(1.00, 1.00, 1.00);
    brdf += 0.02;
    col = col*brdf;
    col = mix( col, vec3(0.8, 0.9, 1.0), 1.0-exp( -0.005*t*t ) );
  }
  return vec3( clamp(col, 0.0, 1.0) );
}

void main( void )
{
  vec2 p = 2.0*(gl_FragCoord.xy / u_resolution.xy) - 1.0;
  p.x *= u_resolution.x / u_resolution.y;
  vec2 mo = vec2(sin(u_time/30.0),0.5);

  // camera  
  float rx = -0.5 + 3.2*cos(6.0*mo.x);
  float rz =  0.5 + 3.2*sin(6.0*mo.x);
  vec3 ro = vec3( rx+float(DOMINOS)/1.5, 2.0 + 2.0*mo.y, rz );
  vec3 ta = vec3( 1.0, 0.0, 0.5 );

  // camera tx
  vec3 cw = normalize( ta-ro );
  vec3 cp = vec3( 0.0, 1.0, 0.0 );
  vec3 cu = normalize( cross(cw, cp) );
  vec3 cv = normalize( cross(cu, cw) );
  vec3 rd = normalize( p.x*cu + p.y*cv + 2.5*cw );

  // pixel color
  vec3 col = render( ro, rd );
  col = pow( col, vec3(0.4545) );
  gl_FragColor=vec4( col, 1.0 );
}
