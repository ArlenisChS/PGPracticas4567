#version 420

$GLMatrices
$Lights
$Material

in vec4 position;
in vec3 normal;

out vec4 color;

vec4 iluminacion(vec3 pos, vec3 N, vec3 V) {
  // Componente emisiva del material
  vec4 color = emissive;

  for (int i = 0; i < lights.length(); i++) {
    // Si la fuente está apagada, no tenerla en cuenta
    if (lights[i].enabled == 0)
      continue;

    // Vector iluminación en fuente direccional
    vec3 L = normalize(vec3(lights[i].positionEye));
    if(lights[i].directional == 0){
        // Vector iluminación (desde vértice a la fuente)
        L = normalize(vec3(lights[i].positionEye) - pos);
    }

    // Multiplicador de la componente difusa
    float diffuseMult = max(dot(N, L), 0.0);
    float specularMult = 0.0;
    if (diffuseMult > 0.0) {
      // Multiplicador de la componente especular
      vec3 R = reflect(-L, N);
      specularMult = max(0.0, dot(R, V));
      specularMult = pow(specularMult, shininess);
    }

    float d = distance(pos, vec3(lights[i].positionEye));
    float kc = lights[i].attenuation.x;
    float kl = lights[i].attenuation.y;
    float kq = lights[i].attenuation.z;

    float attenuation_factor = 1;
    float focus_effect = 1;
    if(lights[i].directional == 0){
        // Factor de atenuacion para luz no direccional
        attenuation_factor = 1.0/max(1, kc + (kl*d) + (kq*d*d));

        float maxLD = max(dot(-L, lights[i].spotDirectionEye), 0);
        // Efecto foco para luz no direccional
        if(lights[i].spotCutoff == 180){
            focus_effect = 1;
        }
        else if(maxLD < lights[i].spotCosCutoff){
            focus_effect = 0;
        }
        else{
            focus_effect = pow(maxLD, lights[i].spotExponent);
        }
    }   

    color += attenuation_factor * focus_effect * 
            (lights[i].ambient * ambient +
             lights[i].diffuse * diffuse * diffuseMult +
             lights[i].specular * specular * specularMult);
  }

  return color;
}

void main() {
  // Normal en el espacio de la cámara
  vec3 eN = normalize(normalMatrix * normal);
  // Vértice en el espacio de la cámara
  vec3 eposition = vec3(modelviewMatrix * position);
  // Vector vista (desde vértice a la cámara)
  vec3 V = normalize(-eposition.xyz);
  // Cálculo de la iluminación
  color = iluminacion(eposition, eN, V);
  gl_Position = modelviewprojMatrix * position;
}
