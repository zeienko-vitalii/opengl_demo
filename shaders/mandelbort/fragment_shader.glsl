#version 410 core

const float MAX_ITER = 128.0;

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

float mandelbort(vec2 uv){
    vec2 c = 4.0 * uv - vec2(0.7, 0.0);
    c = c / pow(time, 4.0) - vec2(0.65, 0.45);


    vec2 z = vec2(0.0);
    float iter = 0.0;

    for(float i = 0.0; i < MAX_ITER; i++){
        z = vec2(z.x * z.x - z.y * z.y,
                2.0 * z.x * z.y) + c;
        if(dot(z, z) > 4.0) return iter / MAX_ITER;
        iter++;
    }
    return 0.0;
}

void main(){
    vec2 uv = (gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.y;
    vec3 col = vec3(0.0);
    
    float m = mandelbort(uv);
    col += hash13(m);

    flagColor = vec4(col, 1.0);
}
