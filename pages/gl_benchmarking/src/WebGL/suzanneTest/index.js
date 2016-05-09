"uses strict";

var iterations = 15;

var window_width = 1024,
    window_height = 768;
var aspect_ratio = window_width / window_height;
var fov = 45.0;
var zfar = 1024.0,
    znear = 0.1;

var canvas = document.createElement('canvas');
canvas.width = 1024;
canvas.height = 768;
document.body.appendChild(canvas);

var gl = undefined;
try {
    gl = canvas.getContext('webgl');

    var EXT = gl.getExtension("OES_element_index_uint") ||
        gl.getExtension("MOZ_OES_element_index_uint") ||
        gl.getExtension("WEBKIT_OES_element_index_uint");

    gl.clearColor(0.0, 0.0, 0.0, 0.0);
    gl.enable(gl.DEPTH_TEST);
    gl.depthFunc(gl.LESS);
    gl.enable(gl.CULL_FACE);
    //    gl.clearDepth(1.0);
} catch (e) {
    console.error("It does not appear your computer can support WebGL.");
}

function CreateViewMatrix(position, direction, up) {
    let f = direction;
    let len = Math.sqrt(f[0] * f[0] + f[1] * f[1] + f[2] * f[2]);
    f = [f[0] / len, f[1] / len, f[2] / len];

    let s = [
        up[1] * f[2] - up[2] * f[1],
        up[2] * f[0] - up[0] * f[2],
        up[0] * f[1] - up[1] * f[0]
    ];

    len = Math.sqrt(s[0] * s[0] + s[1] * s[1] + s[2] * s[2]);

    let s_norm = [
        s[0] / len,
        s[1] / len,
        s[2] / len
    ];

    let u = [
        f[1] * s_norm[2] - f[2] * s_norm[1],
        f[2] * s_norm[0] - f[0] * s_norm[2],
        f[0] * s_norm[1] - f[1] * s_norm[0]
    ];

    let p = [
        -position[0] * s_norm[0] - position[1] * s_norm[1] - position[2] * s_norm[2],
        -position[0] * u[0] - position[1] * u[1] - position[2] * u[2],
        -position[0] * f[0] - position[1] * f[1] - position[2] * f[2]
    ];

    return [
        s_norm[0], u[0], f[0], 0.0,
        s_norm[1], u[1], f[1], 0.0,
        s_norm[2], u[2], f[2], 0.0,
        p[0], p[1], p[2], 1.0
    ];
}

function CreatePerspectiveMatrix() {
    let f = Math.tan(Math.PI * 0.5 - 0.5 * fov);
    let range = 1.0 / (znear - zfar);
    return [
        f / aspect_ratio, 0.0, 0.0, 0.0,
        0.0, f, 0.0, 0.0,
        0.0, 0.0, (znear + zfar) * range, -1.0,
        0.0, 0.0, znear * zfar * range * 2, 0.0
    ];
}

var viewMatrix = CreateViewMatrix([0.0, 0.0, 0.0], [0.0, 0.0, 1.0], [0.0, 1.0, 0.0]);
var perspectiveMatrix = CreatePerspectiveMatrix();

var vertexShader = gl.createShader(gl.VERTEX_SHADER);
gl.shaderSource(vertexShader, fetchHTTP("../shaders/suzanneVert.glsl"));
gl.compileShader(vertexShader);

var fragmentShader = gl.createShader(gl.FRAGMENT_SHADER);
gl.shaderSource(fragmentShader, fetchHTTP("../shaders/suzanneFrag.glsl"));
gl.compileShader(fragmentShader);

var program = gl.createProgram();
gl.attachShader(program, vertexShader);
gl.attachShader(program, fragmentShader);
gl.linkProgram(program);

var perspectiveMatrixID = gl.getUniformLocation(program, "perspective");
var modelMatrixID = gl.getUniformLocation(program, "model");
var viewMatrixID = gl.getUniformLocation(program, "view");
var timeID = gl.getUniformLocation(program, "u_time");
var resolutionID = gl.getUniformLocation(program, "u_resolution");

var a_PostionID = gl.getAttribLocation(program, "position");
var a_NormalID = gl.getAttribLocation(program, "normal");

var model = JSON.parse(fetchHTTP('../../assets/models/suzanne_high-res.json'));
var vertices = new Float32Array(model.vertexPositions);
var normals = new Float32Array(model.vertexNormals);
var indices = new Uint32Array(model.indices);

var vertexbuffer = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, vertexbuffer);
gl.bufferData(gl.ARRAY_BUFFER, vertices, gl.STATIC_DRAW);

var normalbuffer = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, normalbuffer);
gl.bufferData(gl.ARRAY_BUFFER, normals, gl.STATIC_DRAW);

var indicesbuffer = gl.createBuffer();
gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indicesbuffer);
gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, indices, gl.STATIC_DRAW);

// 1st attribute buffer : vertices
gl.enableVertexAttribArray(a_PostionID);
gl.bindBuffer(gl.ARRAY_BUFFER, vertexbuffer);
gl.vertexAttribPointer(a_PostionID, 3, gl.FLOAT, false, 0, 0);
// 2nd attribute buffer : normals
gl.enableVertexAttribArray(a_NormalID);
gl.bindBuffer(gl.ARRAY_BUFFER, normalbuffer);
gl.vertexAttribPointer(a_NormalID, 3, gl.FLOAT, false, 0, 0);

gl.useProgram(program);
var loadTime = Date.now();
var lastTime = loadTime;
var nbFrames = 0;

function render() {

    let currentTime = Date.now();
    nbFrames++;
    if (currentTime - lastTime >= 1000.0) {
        console.log(1000.0 / nbFrames + " ms/frame");
        nbFrames = 0;
        lastTime += 1000.0;
    }

    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

    for (let x = 0; x < iterations; x++) {
        let size = 60 / iterations * 0.01;
        let _step = iterations / 2;
        let posX = -0.9 + x / _step;
        let posY = 1;
        let posZ = -2;

        for (let y = 0; y < iterations; y++) {
            posY = 0.9 - y / _step;

            for (let z = 0; z < iterations; z++) {
                posZ = -2 - z / _step;

                /// Resolution Uniform
                gl.uniform2f(gl.getUniformLocation(program, 'u_resolution'), canvas.width, canvas.height);
                // Time Uniform
                gl.uniform1f(gl.getUniformLocation(program, 'u_time'), (currentTime - loadTime) / 1000.0);
                // Perspective Matrix Uniform
                gl.uniformMatrix4fv(perspectiveMatrixID, false, perspectiveMatrix);
                // View Matrix Uniform
                gl.uniformMatrix4fv(viewMatrixID, false, viewMatrix);
                // Model Matrix Uniform
                gl.uniformMatrix4fv(modelMatrixID, false, [
                    size, 0.0, 0.0, 0.0,
                    0.0, size, 0.0, 0.0,
                    0.0, 0.0, size, 0.0,
                    posX, posY, posZ, 1.0
                ]);
                // Draw suzanne !
                gl.drawElements(gl.TRIANGLES, indices.length, gl.UNSIGNED_INT, 0);
            }
        }

        //viewMatrix[14] += 0.01;
    }

    //gl.flush();
    animFrame(render);
}
render();
