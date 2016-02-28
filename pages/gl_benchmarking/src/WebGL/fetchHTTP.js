// Used for fetching files, such as shaders for our "glProgram"
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
}
