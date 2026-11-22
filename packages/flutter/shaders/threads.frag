#include <flutter/runtime_effect.glsl>
uniform vec2 uSize;
uniform vec2 uPointer;
uniform float uPhase;
uniform vec3 uColor;
out vec4 fragColor;
void main() {
  vec2 p = FlutterFragCoord().xy / uSize;
  float y = p.y + 0.035 * sin(p.x * 8.0 + uPhase) + uPointer.y * 0.07;
  float s = (y + p.x * .18) * 22.0;
  float line = 1.0 - smoothstep(0.015, 0.12, abs(fract(s) - 0.5));
  float focus = 1.0 - smoothstep(0.0, 0.6, distance(p, vec2(0.5) + uPointer * 0.45));
  float a = line * (0.10 + 0.26 * focus) * smoothstep(0.0, 0.12, p.y) * (1.0 - smoothstep(0.84, 1.0, p.y));
  fragColor = vec4(uColor * a, a);
}
