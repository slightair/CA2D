uniform vec2 resolution;
uniform vec2 blockSize;

void main()
{
    vec2 blockCoord = floor(gl_FragCoord.xy / blockSize) * blockSize;
    gl_FragColor = vec4(blockCoord.xy / resolution, 1.0, 1.0);
}
