#version 420

$GLMatrices

layout (triangles) in;
layout (triangle_strip, max_vertices = 3) out;

// Cylinder
uniform float cylinderRadius; // radio del cilindro
uniform float cylinderHeight; // altura del cilindro
uniform vec3 cylinderAxis; // dirección del eje (vector unitario)
uniform vec3 cylinderPos; // centro de la base del cilindro en el espacio de la camara

in vec4 color[3];
out vec4 fragColor;

void main() {
	int count = 0;
	vec3 p1 = cylinderPos;
	vec3 p2 = p1 + normalize(normalMatrix*cylinderAxis)*cylinderHeight;

	for (int i = 0; i < gl_in.length(); i++) {
		vec3 q = gl_in[i].gl_Position.xyz;
		float check_over_p1 = dot(q - p1, p2 - p1);
		float check_under_p2 = dot(q - p2, p2 - p1);
		double check_inside_r = length(cross(q - p1, p2 - p1))/length(p2 - p1);
		if (check_over_p1 >= 0 && check_under_p2 <= 0 && check_inside_r <= cylinderRadius) {
			count += 1;
		}
	}

	if (count < 3) {
		for (int i = 0; i < gl_in.length(); i++) {
			gl_Position = projMatrix * gl_in[i].gl_Position;
			if (count == 1) {
				fragColor = vec4(0, 1, 0, 1);
			}
			else if (count == 2) {
				fragColor = vec4(1, 0, 0, 1);
			}
			else {
				fragColor = color[i];
			}
			EmitVertex();
		}
		EndPrimitive();
	}
}