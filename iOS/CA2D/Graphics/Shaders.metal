#include <metal_stdlib>

using namespace metal;

struct Vertex {
    float2 position;
    float3 color;
};

struct Uniforms {
    float2 viewportSize;
};

struct RasterizerData {
    float4 position [[position]];
    float4 color;
};

vertex RasterizerData vertexShader(uint vertexID [[vertex_id]],
                                   constant Vertex *vertices [[buffer(0)]],
                                   constant Uniforms &uniforms [[buffer(1)]]) {
    RasterizerData out;

    float2 pixelSpacePosition = vertices[vertexID].position.xy;

    out.position = float4(0, 0, 0, 1);
    out.position.xy = pixelSpacePosition * float2(1, -1) / (uniforms.viewportSize / 2);
    out.color = float4(vertices[vertexID].color, 1);

    return out;
}

fragment float4 fragmentShader(RasterizerData in [[stage_in]]) {
    return in.color;
}
