/**
 *
 */

// Menu Toggle Script
var mm = undefined;

if(window.innerWidth < 768){
    document.getElementById('menu-toggle').innerHTML = '<i class="fa fa-arrow-circle-o-right"> Open Menu</i>';
    mm = true;
} else{
    mm = false;
}

$("#menu-toggle").click(function (e) {
    if(mm === undefined)
        return;

    e.preventDefault();
    $("#wrapper").toggleClass("toggled");

    if (mm)
        document.getElementById('menu-toggle').innerHTML = '<i class="fa fa-arrow-circle-o-left"> Close Menu</i>';
    else
        document.getElementById('menu-toggle').innerHTML = '<i class="fa fa-arrow-circle-o-right"> Open Menu</i>';

    mm = !mm;
});

//jQuery for page scrolling feature - requires jQuery Easing plugin
$(function () {
    $('a.page-scroll').bind('click', function (event) {
        var $anchor = $(this);
        $('html, body').stop().animate({
            scrollTop: $($anchor.attr('href')).offset().top
        }, 1500, 'easeInOutExpo');
        event.preventDefault();
    });
});

/**
 * Fetch for files
 * @medhod #fetchHTTP
 *
 * @param {string} url - filepath
 * @param {string} methood - Http Request method
 */
function fetchHTTP(url, methood) {
    var request = new XMLHttpRequest(),
        response;

    request.onreadystatechange = function () {
        if (request.readyState === 4 && request.status === 200) {
            response = request.responseText;
        }
    }
    request.open(methood ? methood : 'GET', url, false);
    request.overrideMimeType("text/plain");
    request.send(null);
    return response;
}

/**
 * hash generator
 * @medhod #randomString
 *
 * @param {number} length - hash length
 * @param {string} chars - hash chars
 */
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

/**
 * Check if DOM element is visible in viewport
 * @medhod #elementInViewport
 *
 * @param {object} el - DOM element
 */
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


/**
 * Append canvas to DOM
 * @medhod #AppendCanvas
 *
 * @param {Array<object>} attributes - canvas's attributes
 * @attribute {string} name - attribute's name
 * @attribute {string} value - attribute's value
 * @param {number} width - canvas's width
 * @param {number} height - canvas's height
 * @param {string} parent - canvas's parent
 * @param {object} Frag - Fragment Shader
 * @attribute {string} isPath - indicates if string is a path to the shader or the shader itself
 * @attribute {string} src - source
 * @param {object} Vert - Vertex Shader
 * @attribute {string} isPath - indicates if string is a path to the shader or the shader itself
 * @attribute {string} src - source
 */
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

/**
 * Returns a random number between min (inclusive) and max (exclusive)
 */
function getRandomArbitrary(min, max) {
    return Math.random() * (max - min) + min;
}

/**
 * Returns a random integer between min (inclusive) and max (inclusive)
 * Using Math.round() will give you a non-uniform distribution!
 */
function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}
