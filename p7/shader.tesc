#version 420 core

$GLMatrices

layout (vertices = 4) out;

in VS_OUT {
	vec2 textureCoord;
} from_vs[];

out TESC_OUT {
	vec2 textureCoord;
} to_tese[];

float get_level (vec4 pos) {
	return 1000 * (1.0 / exp(length(pos)));
}

void main() {
	// Propagamos la posición y la coordenada de textura al shader de evaluación
	gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;
	to_tese[gl_InvocationID].textureCoord = from_vs[gl_InvocationID].textureCoord;

	if (gl_InvocationID == 0) {
		gl_TessLevelOuter[0] = get_level((gl_in[0].gl_Position + gl_in[3].gl_Position) / 2);
		gl_TessLevelOuter[1] = get_level((gl_in[1].gl_Position + gl_in[0].gl_Position) / 2);
		gl_TessLevelOuter[2] = get_level((gl_in[2].gl_Position + gl_in[1].gl_Position) / 2);
		gl_TessLevelOuter[3] = get_level((gl_in[3].gl_Position + gl_in[2].gl_Position) / 2);
		
		gl_TessLevelInner[0] = get_level(gl_out[gl_InvocationID].gl_Position);
		gl_TessLevelInner[1] = get_level(gl_out[gl_InvocationID].gl_Position);
	}
}
