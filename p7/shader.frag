#version 420 core

in TESE_OUT {
	float textureCoord;
};

uniform	sampler1D texUnitScaleMap;
out vec4 finalColor;

void main() {
	finalColor = texture(texUnitScaleMap, textureCoord); 
}