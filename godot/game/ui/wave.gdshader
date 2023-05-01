shader_type canvas_item;

uniform float height = 5.0;
uniform float curve = 0.3;
uniform float speed = 2.0;

void vertex() {
    VERTEX.y += height*sin(VERTEX.x*curve+TIME*speed);
}
