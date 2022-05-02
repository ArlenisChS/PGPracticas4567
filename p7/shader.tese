#version 420 core

$GLMatrices

layout (quads, equal_spacing, ccw) in;

uniform	sampler2D texUnitHeightMap;

in TESC_OUT {
	vec2 textureCoord;
} from_tesc[];

out TESE_OUT {
	float textureCoord;
};
void main() {
	vec2 t1 = mix(from_tesc[0].textureCoord, from_tesc[1].textureCoord, gl_TessCoord.x);
	vec2 t2 = mix(from_tesc[3].textureCoord, from_tesc[2].textureCoord, gl_TessCoord.x);

	vec2 inTextureCoord = mix(t1, t2, gl_TessCoord.y);

	// Calculamos la posición del vértice teselado como una interpolación bilineal
	vec4 p1 = mix(gl_in[0].gl_Position, gl_in[1].gl_Position, gl_TessCoord.x);
	vec4 p2 = mix(gl_in[3].gl_Position, gl_in[2].gl_Position, gl_TessCoord.x);

	vec4 color = texture(texUnitHeightMap, inTextureCoord);
	textureCoord = color.x;

	gl_Position = mix(p1, p2, gl_TessCoord.y);
	gl_Position.y += color.x * 2;
	gl_Position = projMatrix*gl_Position;
}
