// Include standard headers
#include <stdio.h>
#include <string>
#include <vector>
#include <iostream>
#include <fstream>
#include <algorithm>
#include <stdlib.h>
#include <sstream>
#include <string.h>
using namespace std;
// Include GLEW
#include <GL/glew.h>
// Include GLFW
#include <glfw3.h>
GLFWwindow* window;
// Include GLM
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
using namespace glm;
// LoadShaders function taken from https://github.com/opengl-tutorials/ogl/blob/master/common/shader.cpp
#include <shader.hpp>
// LoadOBJ function taken from https://github.com/opengl-tutorials/ogl/blob/master/common/objloader.cpp
#include <objloader.hpp>

// window size in pixels
int window_width = 1024, window_height = 768;
float aspect_ratio = window_width / window_height;
float fov = 45.0f;
float zfar = 1024.0f, znear = 0.1f;

mat4 CreateViewMatrix(vec3 position, vec3 direction, vec3 up) {
	vec3 f = direction;
	float len = sqrt(f[0] * f[0] + f[1] * f[1] + f[2] * f[2]);
	f = vec3(f[0] / len, f[1] / len, f[2] / len);

	vec3 s = vec3(up[1] * f[2] - up[2] * f[1],
		up[2] * f[0] - up[0] * f[2],
		up[0] * f[1] - up[1] * f[0]);

	len = sqrt(s[0] * s[0] + s[1] * s[1] + s[2] * s[2]);

	vec3 s_norm = vec3(s[0] / len,
		s[1] / len,
		s[2] / len);

	vec3 u = vec3(f[1] * s_norm[2] - f[2] * s_norm[1],
		f[2] * s_norm[0] - f[0] * s_norm[2],
		f[0] * s_norm[1] - f[1] * s_norm[0]);

	vec3 p = vec3(-position[0] * s_norm[0] - position[1] * s_norm[1] - position[2] * s_norm[2],
		-position[0] * u[0] - position[1] * u[1] - position[2] * u[2],
		-position[0] * f[0] - position[1] * f[1] - position[2] * f[2]);

	return mat4(s_norm[0], u[0], f[0], 0.0,
		s_norm[1], u[1], f[1], 0.0,
		s_norm[2], u[2], f[2], 0.0,
		p[0], p[1], p[2], 1.0);
}

mat4 CreatePerspectiveMatrix() {
	float f = tan(3.141592f * 0.5 - 0.5 * fov);
	float range = 1.0 / (znear - zfar);
	return mat4(f / aspect_ratio, 0.0, 0.0, 0.0,
		0.0, f, 0.0, 0.0,
		0.0, 0.0, (znear + zfar) * range, -1.0,
		0.0, 0.0, znear * zfar * range * 2, 0.0);
}


static const mat4 viewMatrix = CreateViewMatrix(vec3(0.0, 0.0, 0.0), vec3(0.0, 0.0, 1.0), vec3(0.0, 1.0, 0.0));

//static const mat4 perspectiveMatrix = perspective(fov, aspect_ratio, znear, zfar);
static const mat4 perspectiveMatrix = CreatePerspectiveMatrix();

static const GLfloat modelMatrix[] = {
	0.5, 0.0,  0.0 ,  0.0,
	0.0,  0.5, 0.0 ,  0.0,
	0.0,  0.0 , 0.5,  0.0,
	0.0,  0.0 , -2.0 ,  1.0,
};
// on window resize callback
void windowSizeCallback(GLFWwindow* window, int width, int height)
{
	window_width = width;
	window_height = height;
	glViewport(0, 0, width, height);
}

int main( void )
{
	// Initialise GLFW
	if( !glfwInit() )
	{
		fprintf( stderr, "Failed to initialize GLFW\n" );
		getchar();
		return -1;
	}

	glfwWindowHint(GLFW_SAMPLES, 4);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 2);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 1);

	// Open a window and create its OpenGL context
	window = glfwCreateWindow(window_width, window_height, "GL Viewport", NULL, NULL);
	if( window == NULL ){
		fprintf( stderr, "Failed to open GLFW window.\n" );
		getchar();
		glfwTerminate();
		return -1;
	}
	glfwMakeContextCurrent(window);

	// Initialize GLEW
	if (glewInit() != GLEW_OK) {
		fprintf(stderr, "Failed to initialize GLEW\n");
		getchar();
		glfwTerminate();
		return -1;
	}

	// Ensure we can capture the escape key being pressed below
	glfwSetInputMode(window, GLFW_STICKY_KEYS, GL_TRUE);

	// Dark blue background
	glClearColor(0.0f, 0.0f, 0.4f, 0.0f);

	// Enable depth test
	glEnable(GL_DEPTH_TEST);
	// Accept fragment if it closer to the camera than the former one
	glDepthFunc(GL_LESS);
	// Cull triangles which normal is not towards the camera
	glEnable(GL_CULL_FACE);

	// Create and compile our GLSL program from the shaders
	GLuint programID = LoadShaders("SimpleVertexShader.vertexshader", "SimpleFragmentShader.fragmentshader");

	// Uniform Locations
	GLuint perspectiveMatrixID = glGetUniformLocation(programID, "perspective");
	GLuint modelMatrixID = glGetUniformLocation(programID, "model");
	GLuint viewMatrixID = glGetUniformLocation(programID, "view");
	GLuint timeID = glGetUniformLocation(programID, "u_time");
	GLuint resolutionID = glGetUniformLocation(programID, "u_resolution");

	// Read our .obj file
	vector<vec3> vertices;
	vector<vec2> uvs;
	vector<vec3> normals;
	loadOBJ("../../../assets/models/suzanne_high-res.obj", vertices, uvs, normals);


	//////////////////////////////
	// Vertex Array Buffers
	//////////////////////////////
	GLuint vertexbuffer;
	glGenBuffers(1, &vertexbuffer);
	glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
	glBufferData(GL_ARRAY_BUFFER, vertices.size() * sizeof(glm::vec3), &vertices[0], GL_STATIC_DRAW);

	GLuint uvbuffer;
	glGenBuffers(1, &uvbuffer);
	glBindBuffer(GL_ARRAY_BUFFER, uvbuffer);
	glBufferData(GL_ARRAY_BUFFER, uvs.size() * sizeof(glm::vec2), &uvs[0], GL_STATIC_DRAW);

	GLuint normalbuffer;
	glGenBuffers(1, &normalbuffer);
	glBindBuffer(GL_ARRAY_BUFFER, normalbuffer);
	glBufferData(GL_ARRAY_BUFFER, normals.size() * sizeof(glm::vec3), &normals[0], GL_STATIC_DRAW);

	// Get a handle for our buffers
	GLuint a_PostionID = glGetAttribLocation(programID, "position");
	GLuint a_UVID = glGetAttribLocation(programID, "uv");
	GLuint a_NormalID = glGetAttribLocation(programID, "normal");

	// set on resize callback function
	glfwSetWindowSizeCallback(window, windowSizeCallback);

	double lastTime = glfwGetTime();
	int nbFrames = 0;

	do{

		// Measure speed
		double currentTime = glfwGetTime();
		nbFrames++;
		if (currentTime - lastTime >= 1.0) { // If last prinf() was more than 1 sec ago
				// printf and reset timer
				printf("%f ms/frame\n", 1000.0 / double(nbFrames));
				nbFrames = 0;
				lastTime += 1.0;
		}

		// Clear the screen
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		// Use our shader
		glUseProgram(programID);

		// 1st attribute buffer : vertices
		glEnableVertexAttribArray(a_PostionID);
		glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
		glVertexAttribPointer(
			a_PostionID,        // attribute 0. No particular reason for 0, but must match the layout in the shader.
			3,                  // size
			GL_FLOAT,           // type
			GL_FALSE,           // normalized?
			0,                  // stride
			(void*)0            // array buffer offset
		);

		// 2nd attribute buffer : UVs
		glEnableVertexAttribArray(a_UVID);
		glBindBuffer(GL_ARRAY_BUFFER, uvbuffer);
		glVertexAttribPointer(
			a_UVID,                           // attribute
			2,                                // size
			GL_FLOAT,                         // type
			GL_FALSE,                         // normalized?
			0,                                // stride
			(void*)0                          // array buffer offset
		);

		// 3rd attribute buffer : normals
		glEnableVertexAttribArray(a_NormalID);
		glBindBuffer(GL_ARRAY_BUFFER, normalbuffer);
		glVertexAttribPointer(
			a_NormalID,                       // attribute
			3,                                // size
			GL_FLOAT,                         // type
			GL_FALSE,                         // normalized?
			0,                                // stride
			(void*)0                          // array buffer offset
		);

		//  Window Resolution Uniform
		glUniform2f(resolutionID, (float)window_width, (float)window_height);
		// Time Uniform
		glUniform1f(timeID, currentTime);
		// Perspective Matrix Uniform
		glUniformMatrix4fv(perspectiveMatrixID, 1, GL_FALSE, &perspectiveMatrix[0][0]);
		// View Matrix Uniform
		glUniformMatrix4fv(viewMatrixID, 1, GL_FALSE, &viewMatrix[0][0]);
		// Model Matrix Uniform
		glUniformMatrix4fv(modelMatrixID, 1, GL_FALSE, modelMatrix);

		// Draw the triangle !
		glDrawArrays(GL_TRIANGLES, 0, vertices.size());

		glDisableVertexAttribArray(a_PostionID);
		glDisableVertexAttribArray(a_UVID);
		glDisableVertexAttribArray(a_NormalID);

		// Swap buffers
		glfwSwapBuffers(window);
		glfwPollEvents();

	} // Check if the ESC key was pressed or the window was closed
	while( glfwGetKey(window, GLFW_KEY_ESCAPE ) != GLFW_PRESS &&
		   glfwWindowShouldClose(window) == 0 );

	// Cleanup VBO
	glDeleteBuffers(1, &vertexbuffer);
	glDeleteBuffers(1, &uvbuffer);
	glDeleteBuffers(1, &normalbuffer);
	glDeleteProgram(programID);

	// Close OpenGL window and terminate GLFW
	glfwTerminate();

	return 0;
}
