"uses strict";

function fetchHTTP(url) {
  var request = new XMLHttpRequest(),
    response;
  request.onreadystatechange = function () {
    if (request.readyState === 4 && request.status === 200) {
      response = request.responseText;
    }
  }
  request.open('GET', url, false);
  request.overrideMimeType("text/plain");
  request.send(null);
  return response;
};

function elementInViewport(el) {
  var top = el.offsetTop;
  var left = el.offsetLeft;
  var width = el.offsetWidth;
  var height = el.offsetHeight;
  while (el.offsetParent) {
    el = el.offsetParent;
    top += el.offsetTop;
    left += el.offsetLeft;
  }
  return (
    top < (window.pageYOffset + window.innerHeight) &&
    left < (window.pageXOffset + window.innerWidth) &&
    (top + height) > window.pageYOffset &&
    (left + width) > window.pageXOffset
  );
}

window.requestAnimFrame =
  window.requestAnimationFrame ||
  window.webkitRequestAnimationFrame ||
  window.mozRequestAnimationFrame ||
  window.oRequestAnimationFrame ||
  window.msRequestAnimationFrame ||
  function (callback) {
    window.setTimeout(callback, 1e3 / 60);
  };

function create3DContext(canvas, optAttribs) {
  let names = ['webgl', 'experimental-webgl'];
  let context;
  for (var ii = 0; ii < names.length; ++ii) {
    try {
      context = canvas.getContext(names[ii], optAttribs);
    } catch (e) {
      if (context) {
        break;
      }
    }
  }

  return context;
}

function createTarget(gl, width, height) {
  var target = {};
  target.framebuffer = gl.createFramebuffer();
  target.texture = gl.createTexture();
  // set up framebuffer
  gl.bindTexture(gl.TEXTURE_2D, target.texture);
  gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
  gl.bindFramebuffer(gl.FRAMEBUFFER, target.framebuffer);
  gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, target.texture, 0);
  // clean up
  gl.bindTexture(gl.TEXTURE_2D, null);
  gl.bindFramebuffer(gl.FRAMEBUFFER, null);
  return target;
}

class GlslViewport {
  constructor(canvas, opts) {
    opts = opts || {};
    this.canvas = canvas || document.createElement('canvas'); // canvas element
    this.canvas.width = opts.width || 600; // canvas width
    this.canvas.height = opts.height || 600; // canvas height
    this.canvas.style.backgroundColor = opts.backgroundColor || 'rgba(1,1,1,1)';
    this.gl = undefined; // gl context

    let gl = create3DContext(this.canvas, opts);

    if (!gl) {
      return;
    }

    this.gl = gl;
    this.loadTime = this.lastTime = Date.now(); // load time
    this.frontTarget = createTarget(gl, this.canvas.width, this.canvas.height); // front render target
    this.backTarget = createTarget(gl, this.canvas.width, this.canvas.height); // back render target
    this.paused = opts.paused || false; // is render loop paused
    this.vertexbuffer = gl.createBuffer(); // vertex buffer
    this.passes = 0; // current passes
    this.max_passes = opts.max_passes || Infinity;
    this.key = -1; // most recent keystroke keycode

    let vertices = new Float32Array([-1.0, -1.0, 1.0, -1.0, -1.0, 1.0, -1.0, 1.0, 1.0, -1.0, 1.0, 1.0]);
    gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexbuffer);
    gl.bufferData(gl.ARRAY_BUFFER, vertices, gl.STATIC_DRAW);

    let vertexShader = gl.createShader(gl.VERTEX_SHADER);
    gl.shaderSource(vertexShader, opts.vertexString || `
#ifdef GL_ES
  precision mediump float;
#endif

attribute vec2 a_position;

void main() {
    gl_Position = vec4(a_position, 0.0, 1.0);
}
`);
    gl.compileShader(vertexShader);
    if (!gl.getShaderParameter(vertexShader, gl.COMPILE_STATUS)) throw ("could not compile shader: " + gl.getShaderInfoLog(vertexShader));

    let fragmentShader = gl.createShader(gl.FRAGMENT_SHADER);
    gl.shaderSource(fragmentShader, opts.fragmentString || `
#ifdef GL_ES
  precision mediump float;
#endif

uniform sampler2D u_backbuffer;

void main(){
    gl_FragColor = vec4(0.0,0.0,0.0,1.0);
}
`);
    gl.compileShader(fragmentShader);
    if (!gl.getShaderParameter(fragmentShader, gl.COMPILE_STATUS)) throw ("could not compile shader: " + gl.getShaderInfoLog(fragmentShader));

    this.frontTarget.program = gl.createProgram();
    gl.attachShader(this.frontTarget.program, vertexShader);
    gl.attachShader(this.frontTarget.program, fragmentShader);
    gl.linkProgram(this.frontTarget.program);
    gl.useProgram(this.frontTarget.program);

    this.frontTarget.timeID = gl.getUniformLocation(this.frontTarget.program, "u_time");
    this.frontTarget.backbufferID = gl.getUniformLocation(this.frontTarget.program, "u_backbuffer");
    this.frontTarget.resolutionID = gl.getUniformLocation(this.frontTarget.program, "u_resolution");
    this.frontTarget.keyboardID = gl.getUniformLocation(this.frontTarget.program, "u_keyboard");
    this.frontTarget.mouseID = gl.getAttribLocation(this.frontTarget.program, "u_mouse");
    this.frontTarget.mouse_downID = gl.getAttribLocation(this.frontTarget.program, "u_mouse_down");
    this.frontTarget.passID = gl.getUniformLocation(this.frontTarget.program, "u_frame");
    this.frontTarget.a_PostionID = gl.getAttribLocation(this.frontTarget.program, "a_position");
    gl.enableVertexAttribArray(this.frontTarget.a_PostionID);

    fragmentShader = gl.createShader(gl.FRAGMENT_SHADER);
    gl.shaderSource(fragmentShader, `
#ifdef GL_ES
  precision mediump float;
#endif

uniform sampler2D u_tex;
uniform vec2 u_resolution;

void main(){
  vec2 uv = gl_FragCoord.xy / u_resolution.xy;
  gl_FragColor = texture2D( u_tex, uv );
}
`);
    gl.compileShader(fragmentShader);
    if (!gl.getShaderParameter(fragmentShader, gl.COMPILE_STATUS)) throw ("could not compile shader: " + gl.getShaderInfoLog(fragmentShader));

    this.backTarget.program = gl.createProgram();
    gl.attachShader(this.backTarget.program, vertexShader);
    gl.attachShader(this.backTarget.program, fragmentShader);
    gl.linkProgram(this.backTarget.program);

    this.backTarget.timeID = gl.getUniformLocation(this.backTarget.program, "u_time");
    this.backTarget.texID = gl.getUniformLocation(this.backTarget.program, "u_tex");
    this.backTarget.resolutionID = gl.getUniformLocation(this.backTarget.program, "u_resolution");
    this.backTarget.a_PostionID = gl.getAttribLocation(this.backTarget.program, "a_position");
    gl.enableVertexAttribArray(this.backTarget.a_PostionID);

    // ========================== EVENTS
    let mouse = {
      x: 0,
      y: 0
    };

    document.addEventListener('mousemove', (e) => {
      mouse.x = e.clientX || e.pageX;
      mouse.y = e.clientY || e.pageY;
    }, false);

    document.addEventListener("keypress", function (evt) {
      this.key = evt.keyCode;
    });

    document.addEventListener("keyup", function (evt) {
      this.key = -1;
    });

    this.canvas.onmouseup = function () {
      this.gl.uniform1i(this.frontTarget.mouse_downID, 0);
    };

    this.canvas.onmousedown = function () {
      this.gl.uniform1i(this.frontTarget.mouse_downID, 0);
    };

    let sandbox = this;

    function RenderLoop() {
      if(elementInViewport(sandbox.canvas)) sandbox.render();

      if (!sandbox.paused && sandbox.passes++ < sandbox.max_passes)
        window.requestAnimFrame(RenderLoop);
      else
        console.warn("Stopped");
    }

    this.setMouse({
      x: 0,
      y: 0
    });
    RenderLoop();
    return this;
  }

  setUniform(callback, pos, ...value) {
    callback(pos, value);
  }

  setMouse(mouse) {
    let rect = this.canvas.getBoundingClientRect();
    if (mouse &&
      mouse.x && mouse.x >= rect.left && mouse.x <= rect.right &&
      mouse.y && mouse.y >= rect.top && mouse.y <= rect.bottom) {

      this.gl.uniform2f(this.frontTarget.mouseID, mouse.x - rect.left, this.canvas.height - (mouse.y - rect.top));
    }
  }

  render() {
    let time = (Date.now() - this.loadTime) / 1000;
    let gl = this.gl;

    gl.useProgram(this.frontTarget.program);

    gl.uniform1f(this.frontTarget.timeID, time);
    gl.uniform2f(this.frontTarget.resolutionID, this.canvas.width, this.canvas.height);
    gl.uniform1i(this.frontTarget.backbufferID, 0);
    gl.uniform1i(this.frontTarget.keyboardID, this.key);
    gl.uniform1i(this.frontTarget.passID, this.passes);

    gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexbuffer);
    gl.vertexAttribPointer(this.frontTarget.a_PostionID, 2, gl.FLOAT, false, 0, 0);

    gl.activeTexture(gl.TEXTURE0);
    gl.bindTexture(gl.TEXTURE_2D, this.backTarget.texture);

    // Render custom shader to front buffer
    gl.bindFramebuffer(gl.FRAMEBUFFER, this.frontTarget.framebuffer);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    gl.drawArrays(gl.TRIANGLES, 0, 6);

    // Set uniforms for screen shader
    gl.useProgram(this.backTarget.program);

    gl.uniform2f(this.backTarget.resolutionID, this.canvas.width, this.canvas.height);
    gl.uniform1i(this.backTarget.texID, 1);

    gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexbuffer);
    gl.vertexAttribPointer(this.backTarget.a_PostionID, 2, gl.FLOAT, false, 0, 0);

    gl.activeTexture(gl.TEXTURE1);
    gl.bindTexture(gl.TEXTURE_2D, this.frontTarget.texture);

    // Render front buffer to screen

    gl.bindFramebuffer(gl.FRAMEBUFFER, null);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    gl.drawArrays(gl.TRIANGLES, 0, 6);

    // Swap buffers

    var tmp = this.frontTarget;
    this.frontTarget = this.backTarget;
    this.backTarget = tmp;
  }
}
