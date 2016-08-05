function fetchHTTP(url, method) {
  var request = new XMLHttpRequest(),
    response;

  request.onreadystatechange = function () {
    if (request.readyState === 4 && request.status === 200) {
      response = request.responseText;
    }
  }
  request.open(method ? method : 'GET', url, false);
  request.overrideMimeType("text/plain");
  request.send(null);
  return response;
}

function randomString(length, chars) {
  var mask = '';
  if (chars.indexOf('a') > -1) mask += 'abcdefghijklmnopqrstuvwxyz';
  if (chars.indexOf('A') > -1) mask += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  if (chars.indexOf('#') > -1) mask += '0123456789';
  if (chars.indexOf('!') > -1) mask += '~`!@#$%^&*()_+-={}[]:";\'<>?,./|\\';
  var result = '';
  for (var i = length; i > 0; --i) result += mask[Math.round(Math.random() * (mask.length - 1))];
  return result;
}

function elementInViewport(el) {
  var top = el.offsetTop;
  var left = el.offsetLeft;
  var width = el.offsetWidth;
  var height = el.offsetHeight;
  while(el.offsetParent) {
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

function AppendCanvas(attributes, width, height, parent, Frag, Vert) {
  var canvas0 = document.createElement('canvas');
  canvas0.width = width;
  canvas0.height = height;

  if (Frag !== undefined) {
    if (Frag.isPath) {
      canvas0.setAttribute("data-fragment-url", Frag.src);
    } else {
      canvas0.setAttribute("data-fragment", Frag.src);
    }
  }


  if (Vert !== undefined) {
    if (Vert.isPath) {
      canvas0.setAttribute("data-fragment-url", Vert.src);
    } else {
      canvas0.setAttribute("data-fragment", Vert.src);
    }
  }

  if (attributes !== undefined) {
    var i = 0;
    for (; i < attributes.length; i++) {
      canvas0.setAttribute(attributes[i].name, attributes[i].value);
    }
  }

  document.getElementById(parent).appendChild(canvas0);
}

function getRandomArbitrary(min, max) {
  return Math.random() * (max - min) + min;
}

function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
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
