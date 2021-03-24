#ifndef NF_EASING_INCLUDED
#define NF_EASING_INCLUDED

// ref: https://github.com/glslify/glsl-easings

namespace NFEasing
{
    // PI, HALF_PI also is defined in `com.unity.render-pipelines.core/ShaderLibrary/Macros.hlsl`
#ifndef PI
#define PI 3.14159265358979323846      // glsl-easings : 3.141592653589793
#endif

#ifndef HALF_PI
#define HALF_PI 1.57079632679489661923 // glsl-easings : 1.5707963267948966
#endif
    
    /// Back
    float BackIn(float t)
    {
        return pow(t, 3.0) - t * sin(t * PI);
    }

    float BackInOut(float t)
    {
        float f = t < 0.5
                ? 2.0 * t
                : 1.0 - (2.0 * t - 1.0);

        float g = pow(f, 3.0) - f * sin(f * PI);

        return t < 0.5
            ? 0.5 * g
            : 0.5 * (1.0 - g) + 0.5;
    }

    float BackOut(float t)
    {
        float f = 1.0 - t;
        return 1.0 - (pow(f, 3.0) - f * sin(f * PI));
    }
    
    /// Bounce
    float BounceOut(float t)
    {
        const float a = 4.0 / 11.0;
        const float b = 8.0 / 11.0;
        const float c = 9.0 / 10.0;

        const float ca = 4356.0 / 361.0;
        const float cb = 35442.0 / 1805.0;
        const float cc = 16061.0 / 1805.0;

        float t2 = t * t;

        return t < a
            ? 7.5625 * t2
            : t < b
                ? 9.075 * t2 - 9.9 * t + 3.4
                : t < c
                    ? ca * t2 - cb * t + cc
                    : 10.8 * t * t - 20.52 * t + 10.72;
    }
    
    float BounceIn(float t)
    {
        return 1.0 - BounceOut(1.0 - t);
    }
    
    float BounceInOut(float t)
    {
        return t < 0.5
            ? 0.5 * (1.0 - BounceOut(1.0 - t * 2.0))
            : 0.5 * BounceOut(t * 2.0 - 1.0) + 0.5;
    }

    
    // Circular
    float CircularIn(float t)
    {
        return 1.0 - sqrt(1.0 - t * t);
    }
    
    float CircularInOut(float t)
    {
        return t < 0.5
            ? 0.5 * (1.0 - sqrt(1.0 - 4.0 * t * t))
            : 0.5 * (sqrt((3.0 - 2.0 * t) * (2.0 * t - 1.0)) + 1.0);
    }

    float CircularOut(float t)
    {
        return sqrt((2.0 - t) * t);
    }
    
    // Cubic
    float CubicIn(float t)
    {
        return t * t * t;
    }
    
    float CubicInOut(float t)
    {
        return t < 0.5
            ? 4.0 * t * t * t
            : 0.5 * pow(2.0 * t - 2.0, 3.0) + 1.0;
    }
    
    float CubicOut(float t)
    {
        float f = t - 1.0;
        return f * f * f + 1.0;
    }
    
    // Elastic
    float ElasticIn(float t)
    {
        return sin(13.0 * t * HALF_PI) * pow(2.0, 10.0 * (t - 1.0));
    }
    
    float ElasticInOut(float t)
    {
        return t < 0.5
            ? 0.5 * sin(+13.0 * HALF_PI * 2.0 * t) * pow(2.0, 10.0 * (2.0 * t - 1.0))
            : 0.5 * sin(-13.0 * HALF_PI * ((2.0 * t - 1.0) + 1.0)) * pow(2.0, -10.0 * (2.0 * t - 1.0)) + 1.0;
    }
    
    float ElasticOut(float t)
    {
        return sin(-13.0 * (t + 1.0) * HALF_PI) * pow(2.0, -10.0 * t) + 1.0;
    }

    
    // Exponential
    float ExponentialIn(float t)
    {
        return t == 0.0 ? t : pow(2.0, 10.0 * (t - 1.0));
    }
    
    float ExponentialInOut(float t)
    {
        return t == 0.0 || t == 1.0
            ? t
            : t < 0.5
                ? +0.5 * pow(2.0, (20.0 * t) - 10.0)
                : -0.5 * pow(2.0, 10.0 - (t * 20.0)) + 1.0;
    }
    
    float ExponentialOut(float t)
    {
        return t == 1.0 ? t : 1.0 - pow(2.0, -10.0 * t);
    }
    
    // Linear
    float Linear(float t)
    {
        return t;
    }
    
    // Quadratic
    float QuadraticIn(float t)
    {
        return t * t;
    }
    
    float QuadraticInOut(float t)
    {
        float p = 2.0 * t * t;
        return t < 0.5 ? p : -p + (4.0 * t) - 1.0;
    }
    
    float QuadraticOut(float t)
    {
        return -t * (t - 2.0);
    }
    
    // Quartic
    float QuarticIn(float t)
    {
        return pow(t, 4.0);
    }
    
    float QuarticInOut(float t)
    {
        return t < 0.5
            ? +8.0 * pow(t, 4.0)
            : -8.0 * pow(t - 1.0, 4.0) + 1.0;
    }
    
    float QuarticOut(float t)
    {
        return pow(t - 1.0, 3.0) * (1.0 - t) + 1.0;
    }
    
    // Qintic
    float QinticIn(float t)
    {
        return pow(t, 5.0);
    }
    
    float QinticInOut(float t)
    {
        return t < 0.5
            ? +16.0 * pow(t, 5.0)
            : -0.5 * pow(2.0 * t - 2.0, 5.0) + 1.0;
    }
    
    float QinticOut(float t)
    {
        return 1.0 - (pow(t - 1.0, 5.0));
    }

    // Sine
    float SineIn(float t)
    {
        return sin((t - 1.0) * HALF_PI) + 1.0;
    }
    
    float SineInOut(float t)
    {
        return -0.5 * (cos(PI * t) - 1.0);
    }

    float SineOut(float t)
    {
        return sin(t * HALF_PI);
    }
}
#endif