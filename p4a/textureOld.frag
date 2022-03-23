#version 420 core

uniform sampler2D texUnit;

in vec2 texCoordFrag;
out vec4 fragColor;

void main() { 
  vec4 color = texture(texUnit, texCoordFrag);
  float x = (color.x*0.3) + (color.y*0.59) + (color.z*0.11);

  switch (int(gl_FragCoord.y) % 4) {
    case 0:
        x = x*0.2;
        break;
    case 1:
        x = x*0.2;
        break;
    case 2:
        x = x*0.8;
        break;
  }

  fragColor = vec4(x, x, x, 1);
}
