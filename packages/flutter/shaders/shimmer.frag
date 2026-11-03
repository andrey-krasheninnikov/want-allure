#include <flutter/runtime_effect.glsl>
precision mediump float;
uniform vec2 uSize;
uniform float uPhase;
uniform float uWave;
uniform vec4 uColor;
uniform vec4 uHighlight;
out vec4 fragColor;
void main() {
  vec2 p = FlutterFragCoord().xy / max(uSize, vec2(1.0));
  float center = mix(-0.55, 1.55, uPhase);
  float distance = (p.x + p.y * 0.18) - center;
  float band = exp(-distance * distance * 24.0);
  vec4 color = mix(uColor, uHighlight, band * (0.90 + uWave * 0.1));
  fragColor = vec4(color.rgb * color.a, color.a);
}
