#version 420 core

$GLMatrices

in vec3 position;
in vec2 texCoord;

out VS_OUT {
	vec2 textureCoord;
} vs_out;

void main()
{
	int x = gl_InstanceID & 63;
	int y = gl_InstanceID >> 6;

	vec3 newpos = position - vec3(float(x) - 32.0 + 0.5, 0.0, float(y) - 32.0 + 0.5);
	gl_Position = modelviewMatrix * vec4(newpos, 1.0);
	vs_out.textureCoord = vec2(float(y + texCoord.y)/64.0, float(x + texCoord.x)/64.0);
}
