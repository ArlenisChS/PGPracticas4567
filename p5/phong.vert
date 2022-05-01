#version 420

$GLMatrices

in vec4 position;
in vec3 normal;

out vec3 eposition;
out vec3 enormal;

void main() {
  // Normal en el espacio de la cámara
  enormal = normalize(normalMatrix * normal);
  // Vértice en el espacio de la cámara
  eposition = vec3(modelviewMatrix * position);
  gl_Position = modelviewprojMatrix * position;
}
