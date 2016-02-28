"use strict";

var canvas = document.createElement('canvas');
canvas.width = 1024;
canvas.height = 768;
document.body.appendChild(canvas);

var gl = canvas.getContext('experimental-webgl');

var vertexShader = gl.createShader(gl.VERTEX_SHADER);
gl.shaderSource(vertexShader, fetchHTTP("../shaders/vertexshader.glsl"));
gl.compileShader(vertexShader);

var fragmentShader = gl.createShader(gl.FRAGMENT_SHADER);
gl.shaderSource(fragmentShader, fetchHTTP("../shaders/test2.glsl"));
gl.compileShader(fragmentShader);

var program = gl.createProgram();
gl.attachShader(program, vertexShader);
gl.attachShader(program, fragmentShader);
gl.linkProgram(program);

var vertices = new Float32Array([
  -1.0, -1.0,
  -1.0, 1.0,
   1.0, -1.0,
   1.0, 1.0,
  -1.0, 1.0,
   1.0, -1.0
]);

var buffer = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
gl.bufferData(gl.ARRAY_BUFFER, vertices, gl.STATIC_DRAW);

program.position = gl.getAttribLocation(program, 'position');
gl.enableVertexAttribArray(program.position);
gl.vertexAttribPointer(program.position, 2, gl.FLOAT, false, 0, 0);

var loadTime = Date.now();
var lastTime = loadTime;
var nbFrames = 0;

var animFrame = window.requestAnimationFrame ||
    window.webkitRequestAnimationFrame ||
    window.mozRequestAnimationFrame ||
    window.oRequestAnimationFrame ||
    window.msRequestAnimationFrame ||
    function (callback, element) {
        console.error("requestAnimationFrame is not supported by you browser!");
        return window.setTimeout(callback, 1000 / 60);
    };

function render() {

    let currentTime = Date.now();
    nbFrames++;
    if (currentTime - lastTime >= 1000.0) {
        console.log(1000.0 / nbFrames + " ms/frame");
        nbFrames = 0;
        lastTime += 1000.0;
    }

    gl.clearColor(1, 0, 1, 1);
    gl.clear(gl.COLOR_BUFFER_BIT);

    gl.useProgram(program);

    /// Resolution Uniform
    gl.uniform2f(gl.getUniformLocation(program, 'u_resolution'), canvas.width, canvas.height);

    // Time Uniform
    gl.uniform1f(gl.getUniformLocation(program, 'u_time'), (currentTime - loadTime) / 1000.0);

    gl.drawArrays(gl.TRIANGLES, 0, 6);

    animFrame(render);

}
render();
