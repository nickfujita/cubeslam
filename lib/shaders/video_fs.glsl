#ifdef GL_ES
precision mediump float;
#endif

varying vec3 vWorldPosition;
varying vec2 vUv;
uniform vec3 arenaColor;
uniform float time;
uniform float noiseAmount;
uniform sampler2D tVideo;
uniform sampler2D tBroken;
uniform vec2 resolution;

float frac(float x) { return mod(x,1.0); }
float noise(vec2 x,float t) { return frac(sin(dot(x,vec2(1.38984*sin(t),1.13233*cos(t))))*653758.5453); }

//float rand(vec2 co){ return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }

void main(void)
{

    float xs = floor(gl_FragCoord.x / 4.0);
    float ys = floor(gl_FragCoord.y / 4.0);

    float noise = noise(vec2(xs,ys),time)-0.5;//rand(vec2(xs * time,ys * time))-0.5;

    vec2 tempUv = vUv;
    tempUv.x += sin(vUv.y*10.0)*0.01+cos(vUv.y*40.0)*0.005;
    tempUv.y = mix(vUv.y,fract(vUv.y-time*0.3),noiseAmount);

    vec3 videoOrg = texture2D(tVideo, vUv).rgb;

    vec2 offset = vec2(0.05*noiseAmount,0.0);
    float cr = texture2D(tVideo, tempUv + offset).r;
    float cga = texture2D(tVideo, tempUv).g;
    float cb = texture2D(tVideo, tempUv - offset).b;
    vec3 videoDistort = vec3(cr, cga, cb) + noise*.4;

    //rbg offset

    float brokenColor = texture2D(tBroken,vUv).r;
    vec3 color = mix( videoOrg, videoDistort,noiseAmount+0.1);
    vec3 finalColor = mix(color,vec3(noise*0.2),brokenColor);

    finalColor = mix( finalColor, arenaColor, clamp((vWorldPosition.y+100.0)/-resolution.y,0.0,1.0));

    //scanlines
    finalColor += vec3(0.01) * sin( (vUv.y) * 360.0 );

    gl_FragColor=vec4(finalColor,1.0);

}

