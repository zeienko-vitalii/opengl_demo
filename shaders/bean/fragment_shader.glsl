#version 410 core

out vec4 flagColor;

uniform vec2 resolution;
uniform float time;

vec2 rotate2D(vec2 uv, float a){
    float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c) * uv;
}

vec2 hash12(float t){
    float x = fract(sin(t * 3453.329));
    float y = fract(sin(t + x) * 3453.329);
    return vec2(x, y);
}

vec3 hash13(float t){
    float x = fract(sin(t * 5625.246));
    float y = fract(sin(t + x) * 2216.486);
    float z = fract(sin(t + y) * 8276.352);
    return vec3(x, y, z);
}

void main(){
    vec2 uv = (gl_FragCoord.xy - 1 * resolution.xy) / resolution.y;
    vec3 col = vec3(0.0);
    
    // x	=	a*cost(sin^3t+cos^3t)	
    // y	=	a*sint(sin^3t+cos^3t).
    // x = (1+t2)/(t4+t2+1), y = (t+t3)/(t4+t2+1)
    // uv = rotate2D(uv, 3.14 / 2.0);

    float r = .1;
    for(float i=0.0; i < 3.14; i+=0.1){

        float factor = (sin(time) * 0.5 + 0.5) + 0.3;
        i += factor;

        float a = i / 3;
        // float a = i / 3;
        //  t=\tan(\theta /3)}t=\tan(\theta /3)
//         x=3a(3-t^{2})
// y=at(3-t^{2})}y=at(3-t^{2})
        float t = tan(a);
        float dx = 3 * r * (3 - t * 2.0);
        float dy = r * t * (3 - t * 2.0);
        // float dx = pow(sin(a), 3.0);
        // float dy = dx + pow(cos(a), 3.0);
        // float dy = (a + pow(cos(a), 3.0)) / (pow(sin(a), 4.0) + pow(a, 2.0) + 1);

        // float dx = (1 + pow(sin(a), 2.0)) / (pow(cos(a), 4.0) + pow(a, 2.0) + 1);
        // float dy = (a + pow(cos(a), 3.0)) / (pow(sin(a), 4.0) + pow(a, 2.0) + 1);

        col += 0.001 / length(uv - vec2(dx, dy));// - 0.02 * hash12(i));
        // col += 0.001 * factor / length(uv - vec2(dx + 0.1, dy));// - 0.02 * hash12(i));
    }
    // col *= sin(vec3(0.2, 0.8, 0.9) * time) * 0.15 + 0.25;
    flagColor = vec4(col, 1.0);
}
