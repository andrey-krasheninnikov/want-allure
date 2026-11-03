#include <flutter/runtime_effect.glsl>
precision mediump float;
uniform vec2 uSize;
uniform float uPhase;
uniform float uWave;
uniform vec4 uColor;
uniform vec4 uHighlight;
out vec4 fragColor;
void main() {
  float shortest = max(1.0, min(uSize.x, uSize.y));
  float angle = uPhase * 6.2831853;
  vec2 center = uSize * vec2(0.5 + 0.16 * sin(angle), 0.5 + 0.24 * cos(angle));
  vec2 p = (FlutterFragCoord().xy - center) / (shortest * 0.68);
  float radius = length(p);
  float halo = exp(-radius * radius * 2.1) * 0.20;
  float sphere = (1.0 - smoothstep(0.87, 1.02, radius));
  float z = sqrt(max(0.0, 1.0 - radius * radius));
  vec3 normal = normalize(vec3(p, z + 0.001));
  float light = max(0.0, dot(normal, normalize(vec3(-0.55, -0.65, 1.0))));
  float rim = pow(1.0 - z, 3.0) * sphere;
  float ribbon = 0.5 + 0.5 * sin(p.x * 3.5 + p.y * 2.0 + angle + z * 4.0);
  float body = sphere * (0.055 + light * 0.13 + ribbon * 0.035) + rim * 0.10;
  float waveRadius = uWave * (max(uSize.x, uSize.y) / shortest * 1.5);
  float wave = exp(-pow((radius - waveRadius) * 12.0, 2.0)) * sin(uWave * 3.1415927) * 0.20;
  float alpha = clamp((halo + body + wave) * uColor.a, 0.0, 0.62);
  vec3 color = mix(uColor.rgb, uHighlight.rgb, light * sphere * 0.16);
  fragColor = vec4(color * alpha, alpha);
}
