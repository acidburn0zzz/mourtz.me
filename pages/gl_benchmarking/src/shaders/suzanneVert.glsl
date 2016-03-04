#extension GL_ARB_gpu_shader5: enable

attribute vec3 position;
attribute vec3 normal;
attribute vec2 uv;

uniform mat4 perspective;
uniform mat4 view;
uniform mat4 model;

varying vec3 v_position;
varying vec3 v_normal;

void main(){
	mat4 modelview = view * model;
	v_normal = mat3(modelview) * normal;

    gl_Position = perspective * modelview * vec4(position,1.0);
	v_position = gl_Position.xyz/gl_Position.w;
}
