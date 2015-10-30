/**
 * Original: http://glslsandbox.com/e#28192.0
 * Enhanced version by @Mourtz
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_mouse;
uniform vec2 u_resolution;

float SCALE = 2.0;
vec2 SPR_SIZE = vec2(6, 8);

vec2 start = vec2(0,0);
vec2 tuv = vec2(0,0);
vec2 chp = vec2(0,0);
vec2 cur = vec2(0,0);
vec2 char = vec2(0,0);

#define A ch(vec2(0x7268BE, 0x8A2000));
#define B ch(vec2(0xF22F22, 0x8BC000));
#define C ch(vec2(0x722820, 0x89C000));
#define D ch(vec2(0xE248A2, 0x938000));
#define E ch(vec2(0xFA0E20, 0x83E000));
#define F ch(vec2(0xFA0E20, 0x820000));
#define G ch(vec2(0x72282E, 0x89C000));
#define H ch(vec2(0x8A2FA2, 0x8A2000));
#define I ch(vec2(0xF88208, 0x23E000));
#define J ch(vec2(0xF84104, 0x918000));
#define K ch(vec2(0x8A4A34, 0x8A2000));
#define L ch(vec2(0x820820, 0x83E000));
#define M ch(vec2(0x8B6AA2, 0x8A2000));
#define N ch(vec2(0x8B2AA6, 0x8A2000));
#define O ch(vec2(0x7228A2, 0x89C000));
#define P ch(vec2(0xF228BC, 0x820000));
#define Q ch(vec2(0x7228AA, 0x99E000));
#define R ch(vec2(0xF228BC, 0x8A2000));
#define S ch(vec2(0x7A0702, 0x0BC000));
#define T ch(vec2(0xF88208, 0x208000));
#define U ch(vec2(0x8A28A2, 0x89C000));
#define V ch(vec2(0x8A28A2, 0x508000));
#define W ch(vec2(0x8A28AA, 0xDA2000));
#define X ch(vec2(0x8A2722, 0x8A2000));
#define Y ch(vec2(0x8A2782, 0x89C000));
#define Z ch(vec2(0xF84210, 0x83E000));
#define ZERO    ch(vec2(0x732AA6, 0x89C000));
#define ONE     ch(vec2(0x218208, 0x23E000));
#define TWO     ch(vec2(0x722108, 0x43E000));
#define THREE   ch(vec2(0x722302, 0x89C000));
#define FOUR    ch(vec2(0x92491E, 0x104000));
#define FIVE    ch(vec2(0xFA0F02, 0x89C000));
#define SIX     ch(vec2(0x72283C, 0x89C000));
#define SEVEN   ch(vec2(0xF82108, 0x420000));
#define EIGHT   ch(vec2(0x722722, 0x89C000));
#define NINE    ch(vec2(0x722782, 0x89C000));
#define c_per ch(vec2(0x000000, 0x008000));
#define c_exc ch(vec2(0x208908, 0x008000));
#define c_com ch(vec2(0x000800, 0x008400));
#define c_col ch(vec2(0x008000, 0x008000));
#define c_sol ch(vec2(0x008000, 0x008400));
#define c_pls ch(vec2(0x00823E, 0x208000));
#define c_dsh ch(vec2(0x00003E, 0x000000));
#define c_div ch(vec2(0x002108, 0x420000));
#define c_ast ch(vec2(0x000508, 0x500000));
#define c_lbr ch(vec2(0x084104, 0x102000));
#define c_rbr ch(vec2(0x810410, 0x420000));
#define c_lsb ch(vec2(0x184104, 0x106000));
#define c_rsb ch(vec2(0xC10410, 0x430000));
#define c_lcb ch(vec2(0x184208, 0x106000));
#define c_rcb ch(vec2(0xC10208, 0x430000));
#define c_les ch(vec2(0x084208, 0x102000));
#define c_grt ch(vec2(0x408104, 0x210000));
#define c_sqo ch(vec2(0x208000, 0x000000));
#define c_dqo ch(vec2(0x514000, 0x000000));
#define c_que ch(vec2(0x72208C, 0x008000));
#define c_pct ch(vec2(0x022108, 0x422000));
#define c_dol ch(vec2(0x21EA1C, 0x2BC200));
#define c_num ch(vec2(0x53E514, 0xF94000));
#define c_ats ch(vec2(0x722BAA, 0xA9C000));
#define c_equ ch(vec2(0x000F80, 0xF80000));
#define c_tdl ch(vec2(0x42A100, 0x000000));
#define c_rsl ch(vec2(0x020408, 0x102000));
#define c_crt ch(vec2(0x214880, 0x000000));
#define c_amp ch(vec2(0x42842C, 0x99C000));
#define c_bar ch(vec2(0x208208, 0x208208));
#define c_blk ch(vec2(0xFFFFFF, 0xFFFFFF));
#define c_trd ch(vec2(0xFD5FD5, 0xFD5FD5));
#define c_hlf ch(vec2(0xA95A95, 0xA95A95));
#define c_qrt ch(vec2(0xA80A80, 0xA80A80));
#define c_spc ch(vec2(0x000000, 0x000000));

float sprite(vec2 ch,vec2 uv)
{
	uv = floor(uv);
	vec2 b = vec2((SPR_SIZE.x - uv.x - 1.0) + uv.y * SPR_SIZE.x) - vec2(24,0);
	vec2 p = mod(floor(ch / exp2(clamp(b,-1.0, 25.0))), 2.0);
	return dot(p,vec2(1)) * float(all(bvec4(greaterThanEqual(uv,vec2(0)), lessThan(uv,SPR_SIZE))));
}

void ch(vec2 ch)
{
	if(floor(chp) == floor(cur))
	{
		char = ch;
	}
	cur.x++;
}

void digit(float n)
{
	n = mod(floor(n),10.0);
	if(n == 0.0) ZERO ;
	if(n == 1.0) ONE ;
	if(n == 2.0) TWO ;
	if(n == 3.0) THREE ;
	if(n == 4.0) FOUR ;
	if(n == 5.0) FIVE ;
	if(n == 6.0) SIX ;
	if(n == 7.0) SEVEN ;
	if(n == 8.0) EIGHT ;
	if(n == 9.0) NINE ;
}

void number(float n)
{
	for(int i = 5;i > -3;i--)
	{
		float d = n/pow(10.0, float(i));
		if(i == -1){ c_per }
		if(d > 1.0 || i <= 0){ digit(d); }
	}
}

void start_print(vec2 uv)
{
	cur = uv;
	start = uv;
}

void spc()
{
	cur.x++;
}
void nl()
{
	cur.x = start.x;
	cur.y--;
}

vec2 str_size(vec2 cl)
{
	return SPR_SIZE * cl;
}

void main( void )
{
	vec2 aspect = u_resolution.xy / u_resolution.y;
	vec2 uv = ( gl_FragCoord.xy ) / SCALE;

	chp = floor(uv/SPR_SIZE);
	vec2 cuv = mod(uv,SPR_SIZE);

	tuv = floor(cuv);

	vec2 cen = (u_resolution / (SPR_SIZE * SCALE)) / 2.0;

	cen -= vec2(5,2)/2.0;

	cen.y += 1.0;

	cen = floor(cen);

	//////////////////////////////////////////////////////
	/// Here's where you start printing
	//////////////////////////////////////////////////////
	start_print(cen);

	W E B C A M c_spc N O T
	
    nl();
    
    C O M P A T I B L E

	gl_FragColor = vec4( vec3( sprite(char,cuv) ), 1.0 );
}
