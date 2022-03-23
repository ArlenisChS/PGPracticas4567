#version 420 core

uniform sampler2D texUnit;
uniform int nSphere;

uniform vec3 thresh1;
uniform vec3 thresh2;
uniform vec3 thresh3;

in vec2 texCoordFrag;
out vec4 fragColor;

void main() { 
  vec3 thresh;
  switch (nSphere) {
    case 0:
        thresh = thresh1;
        break;
    case 1:
        thresh = thresh2;
        break;
    case 2:
        thresh = thresh3;
        break;
  }

  fragColor = texture(texUnit, texCoordFrag); 
  if ( fragColor.x < thresh.x && 
    fragColor.y < thresh.y &&
    fragColor.z < thresh.z ) {
      discard;
    }
}