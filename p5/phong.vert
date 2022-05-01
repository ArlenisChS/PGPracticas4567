#version 420

$GLMatrices

in vec4 position;
in vec3 normal;

out vec3 eposition;
out vec3 enormal;

void main() {
  // Normal en el espacio de la c�mara
  enormal = normalize(normalMatrix * normal);
  // V�rtice en el espacio de la c�mara
  eposition = vec3(modelviewMatrix * position);
  gl_Position = modelviewprojMatrix * position;
}
