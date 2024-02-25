// Based on this: https://www.shadertoy.com/view/wtlSWX

varying vec2 vTextureCoord;
uniform sampler2D uSampler;
uniform sampler2D noise;
uniform float time;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

// Distance function.
// Just calculates the height (z) from x,y plane with really simple length
// check. Its not exact as there could be shorter distances.
vec2 dist(vec3 p)
{
    float id = floor(p.x) + floor(p.y);
    id = mod(id, 2.);
    float h = texture2D(noise, vec2(p.x, p.y) * 0.1).r * 1.1;
    float h2 = texture2D(uSampler, vTextureCoord).r;
    return vec2(h + h2 - p.z, id);
}

// Light calculation.
vec3 calclight(vec3 p, vec3 rd)
{
    vec2 eps = vec2(0., 0.001);
    vec3 n = normalize(vec3(
                dist(p + eps.yxx).x - dist(p - eps.yxx).x,
                dist(p + eps.xyx).x - dist(p - eps.xyx).x,
                dist(p + eps.xxy).x - dist(p - eps.xxy).x
            ));

    return vec3(max(0., dot(-rd, n)));
}

void main()
{
    vec2 uv = vec2(vTextureCoord.x, 1. - vTextureCoord.y);
    uv *= 2.;
    uv -= 1.;

    vec3 cam = vec3(0., 2., -3.);
    vec3 target = vec3(sin(time) * 5., 0., 5.);
    float fov = 2.2;
    vec3 forward = normalize(target - cam);
    vec3 up = normalize(cross(forward, vec3(0., 1., 0.)));
    vec3 right = normalize(cross(up, forward));
    vec3 raydir = normalize(vec3(uv.x * up + uv.y * right + fov * forward));

    // Do the raymarch
    vec3 col = vec3(0.1);
    float t = 0.;
    for (int i = 0; i < 20; i++) {
        vec3 p = t * raydir + cam;
        vec2 d = dist(p);

        // Jump only half of the distance as height function used is not really
        // the best for heightmaps.
        t += d.x * 0.5;
        if (d.x < 0.001) {
            vec3 bc = vec3(0.4, 0.1, 0.1);
            col = calclight(p, raydir) * bc;
            break;
        }
        if (t > 1000.) {
            break;
        }
    }
    gl_FragColor = vec4(col, 2.4);
}
