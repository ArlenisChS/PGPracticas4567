
#include <glm/gtc/matrix_transform.hpp>

#include "PGUPV.h"
#include "GUI3.h"

using namespace PGUPV;

using glm::vec3;
using glm::vec4;
using glm::mat3;
using glm::mat4;
using std::vector;

/*

Muestra una esfera texturada con una foto de la Tierra.

*/

class MyRender : public Renderer {
public:
    MyRender() {};
    void setup(void);
    void render(void);
    void reshape(uint w, uint h);
    void update(uint ms);

private:
    std::shared_ptr<GLMatrices> mats;
    std::shared_ptr<Program> program;

    std::vector<std::shared_ptr<Texture2D>> textures;
    std::vector<Sphere> spheres;
    std::vector<vec3> rotdir;

    std::vector<float> angles;
    std::vector<float> speeds;
    GLint nsphereUnitLoc;

    void buildGUI();
    void setupModels();
};

void MyRender::setupModels() {
    spheres.push_back(Sphere(0.8));
    spheres.push_back(Sphere(1));
    spheres.push_back(Sphere(1.2));

    std::shared_ptr<Texture2D> sphere1Texture = std::make_shared<Texture2D>();
    sphere1Texture->loadImage("../recursos/imagenes/sphere1.jpg");

    std::shared_ptr<Texture2D> sphere2Texture = std::make_shared<Texture2D>();
    sphere2Texture->loadImage("../recursos/imagenes/sphere2.jpg");

    std::shared_ptr<Texture2D> sphere3Texture = std::make_shared<Texture2D>();
    sphere3Texture->loadImage("../recursos/imagenes/sphere3.jpg");

    textures = {
        sphere1Texture, 
        sphere2Texture, 
        sphere3Texture
    };

    rotdir = {
        vec3(0.0, 1.0, 0.0),
        vec3(1.0, 0.0, 0.0),
        vec3(-1.0, -1.0, 0.0)
    };

    angles = {0, 0, 0};

    speeds = {
        glm::radians(60.0f),
        glm::radians(45.0f),
        glm::radians(30.0f)
    };
}

void MyRender::setup() {
    glEnable(GL_DEPTH_TEST);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    setupModels();

    program = std::make_shared<Program>();
    program->addAttributeLocation(Mesh::VERTICES, "position");
    program->addAttributeLocation(Mesh::TEX_COORD0, "texCoord");

    mats = GLMatrices::build();
    program->connectUniformBlock(mats, UBO_GL_MATRICES_BINDING_INDEX);

    program->loadFiles("textureMagicOrb");
    program->compile();

    GLint texUnitLoc = program->getUniformLocation("texUnit");
    nsphereUnitLoc = program->getUniformLocation("nSphere");
    program->use();
    glUniform1i(texUnitLoc, 0);

    setCameraHandler(std::make_shared<OrbitCameraHandler>());

    buildGUI();
    App::getInstance().getWindow().showGUI(true);
}

void MyRender::render() {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    mats->setMatrix(GLMatrices::VIEW_MATRIX, getCamera().getViewMatrix());

    for (int i = 0; i < spheres.size(); ++i) {
        mats->setMatrix(GLMatrices::MODEL_MATRIX,
            glm::rotate(glm::mat4(1.0f), angles[i], rotdir[i]));

        textures[i]->bind(GL_TEXTURE0);
        glUniform1i(nsphereUnitLoc, i);
        spheres[i].render();
    }

    CHECK_GL();
}

void MyRender::reshape(uint w, uint h) {
    glViewport(0, 0, w, h);
    mats->setMatrix(GLMatrices::PROJ_MATRIX, getCamera().getProjMatrix());
}

void MyRender::update(uint ms) {
    for (int i = 0; i < angles.size(); ++i) {
        angles[i] += speeds[i] * ms / 1000.0f;
        if (angles[i] > TWOPIf)
            angles[i] -= TWOPIf;
    }
}

void MyRender::buildGUI() {
    auto panel = addPanel("Umbrales");

    panel->setPosition(5, 5);
    panel->setSize(250, 80);

    auto color1 = std::make_shared<RGBColorWidget>(
        "Threshhold 1", // Etiqueta
        vec3(0.7, 0.7, 0.7), // Valor inicial (gris)
        program,           // El programa que contiene el uniform
        "thresh1"); // El nombre del uniform en el shader
    panel->addWidget(color1);

    auto color2 = std::make_shared<RGBColorWidget>(
        "Threshhold 2", // Etiqueta
        vec3(0.7, 0.7, 0.7), // Valor inicial (gris)
        program,           // El programa que contiene el uniform
        "thresh2"); // El nombre del uniform en el shader
    panel->addWidget(color2);

    auto color3 = std::make_shared<RGBColorWidget>(
        "Threshhold 3", // Etiqueta
        vec3(0.7, 0.7, 0.7), // Valor inicial (gris)
        program,           // El programa que contiene el uniform
        "thresh3"); // El nombre del uniform en el shader
    panel->addWidget(color3);
}

int main(int argc, char* argv[]) {
    App& myApp = App::getInstance();
    myApp.initApp(argc, argv, PGUPV::DOUBLE_BUFFER | PGUPV::DEPTH_BUFFER |
        PGUPV::MULTISAMPLE);
    myApp.getWindow().setRenderer(std::make_shared<MyRender>());
    return myApp.run();
}
