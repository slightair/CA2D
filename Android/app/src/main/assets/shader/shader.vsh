attribute vec4 position;
attribute vec4 color;

varying vec4 vColor;

void main()
{
    vColor = color;
    gl_Position = position;
}
