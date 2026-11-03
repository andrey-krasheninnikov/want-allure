#include <flutter/runtime_effect.glsl>
precision mediump float;
uniform vec2 uSize;
uniform float uTime;
uniform vec4 uPrimary;
uniform vec4 uWarning;
out vec4 fragColor;
float hash(float n) { return fract(sin(n * 127.1) * 43758.5453); }
float lineDistance(vec2 p, vec2 a, vec2 b) {
  vec2 d = b-a;
  return length(p-a-d*clamp(dot(p-a,d)/dot(d,d),0.0,1.0));
}
vec4 bolt(vec2 p, float center, float seed, float time, vec4 color) {
  float life = mod(time,9.0);
  float alpha = smoothstep(0.0,0.4,life)*(1.0-smoothstep(0.65,1.8,life));
  if (alpha <= 0.0) return vec4(0.0);
  float distance = 2.0;
  for (int i=0;i<12;i++) {
    float n=float(i);
    vec2 a=vec2(center+(hash(n+seed)-0.5)*0.19,n/11.0);
    vec2 b=vec2(center+(hash(n+1.0+seed)-0.5)*0.19,(n+1.0)/11.0);
    distance=min(distance,lineDistance(p,a,b));
    if (i==3 || i==7) {
      vec2 branch=a+vec2(center<0.5 ? 0.12 : -0.12,0.09);
      distance=min(distance,lineDistance(p,a,branch));
    }
  }
  float core=1.0-smoothstep(0.0008,0.0024,distance);
  float glow=exp(-distance*120.0)*0.3;
  float opacity=(core+glow)*alpha*color.a*0.65;
  return vec4(color.rgb*opacity,opacity);
}
void main() {
  vec2 p=FlutterFragCoord().xy/uSize;
  vec4 a=bolt(p,0.24,17.0,uTime,uPrimary);
  vec4 b=bolt(p,0.76,53.0,uTime+4.5,uWarning);
  fragColor=a+b*(1.0-a.a);
}
