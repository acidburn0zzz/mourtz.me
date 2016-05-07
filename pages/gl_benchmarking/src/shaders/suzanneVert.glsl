attribute vec3 position;
attribute vec3 normal;

uniform mat4 perspective;
uniform mat4 view;
uniform mat4 model;

varying vec3 v_position;
varying vec3 v_normal;

// https://github.com/Famous/engine/blob/master/webgl-shaders/chunks/transpose.glsl
mat3 transpose(mat3 m) {
    return mat3(m[0][0], m[1][0], m[2][0],
                m[0][1], m[1][1], m[2][1],
                m[0][2], m[1][2], m[2][2]);
}

// https://github.com/Famous/engine/blob/master/webgl-shaders/chunks/inverse.glsl
mat3 inverse(mat3 m) {
    float a00 = m[0][0], a01 = m[0][1], a02 = m[0][2];
    float a10 = m[1][0], a11 = m[1][1], a12 = m[1][2];
    float a20 = m[2][0], a21 = m[2][1], a22 = m[2][2];

    float b01 =  a22 * a11 - a12 * a21;
    float b11 = -a22 * a10 + a12 * a20;
    float b21 =  a21 * a10 - a11 * a20;

    float det = a00 * b01 + a01 * b11 + a02 * b21;

    return mat3(b01, (-a22 * a01 + a02 * a21), (a12 * a01 - a02 * a11),
                b11, (a22 * a00 - a02 * a20), (-a12 * a00 + a02 * a10),
                b21, (-a21 * a00 + a01 * a20), (a11 * a00 - a01 * a10)) / det;
}

void main(){
	mat4 modelview = view * model;
	v_normal = transpose(inverse(mat3(modelview))) * normal;

    gl_Position = perspective * modelview * vec4(position,1.0);
	v_position = gl_Position.xyz/gl_Position.w;
}

