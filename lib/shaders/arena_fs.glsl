#ifdef GL_ES
precision mediump float;
#endif

varying vec2 vUv;
uniform sampler2D tGrid;
uniform sampler2D tDigits;
uniform vec2 scale; 
uniform vec2 points; 




float thing(vec2 pos) 
{
    float a = clamp(sin(pos.y / 70.) + sqrt(15.+tan(pos.x)), 0.0, 22.);
    float b = clamp(cos(pos.x / 70.) + sqrt(25.+tan(pos.y)), 0.3, 10.);
    return (a + b);
}

void main(void) 
{
    vec3 lineColor = vec3(0.89453125,0.89453125,0.7734375);

    vec2 position = vUv;
    float color = texture2D( tGrid, vUv*scale ).x*0.5;

    float color2 = smoothstep( vUv.y,vUv.y+0.007,0.508);
    color2 -= smoothstep(vUv.y,vUv.y+0.007,0.498);

    if( vUv.y < 0.5 ) {
        //color2 += texture2D(tDigits,vec2(vUv.x/7.1 + 1.0/7.1*points.x,1.0-(0.5-vUv.y)/4.9)).x;
        color2 += texture2D(tDigits,vec2(vUv.x/3.55 - 1.0/3.55 + 1.0/3.55*points.x,1.0-(0.5-vUv.y)/2.45)).x;
    }
    else {
        //color2 += texture2D(tDigits,vec2((1.0-vUv.x)/7.1 + 1.0/7.1*points.y,1.0-(0.5-(1.0-vUv.y))/4.9)).x;
        color2 += texture2D(tDigits,vec2((1.0-vUv.x)/3.55 - 1.0/3.55 + 1.0/3.55*points.y,1.0-(0.5-(1.0-vUv.y))/2.45)).x;
    }

    vec2 circleCenter = vec2(0.5,0.5);
    float circleRadius = 0.1;
    float dist = length(position - circleCenter );
    float circle = 0.0;//smoothstep(circleRadius,circleRadius - 0.004,dist) - smoothstep(circleRadius*0.93,(circleRadius*.93) - 0.004,dist);

    vec3 gridColor = vec3(color, color, color);

    vec3 centerColor = vec3(color2)*lineColor;
    

    gl_FragColor = vec4( gridColor*lineColor , step(gridColor.x,0.99) )*0.2 + vec4( centerColor+circle , color2);
    
}
