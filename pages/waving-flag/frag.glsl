#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D u_iChannel0;
uniform vec2 u_resolution;
uniform float u_time;

varying vec2 v_uv_position;
varying vec3 v_position, v_normal;

void main()
{
    gl_FragColor = texture2D(u_iChannel0, v_uv_position);
}
