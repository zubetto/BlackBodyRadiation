/*
    This function approximates luminance and chromaticity of a black body radiation emitted at the given temperature.
    Approximation errors are not given, so this function should not be used where computational accuracy is critical!
    Instead, the primary purpose of this function is to render a black body surface in real time, which can be used in CG shaders,
    therefore the function is written in HLSL.
    
    The luminance and chromaticity of a black body radiation are computed independently of each other.
    The alpha-component of returned value is effective radiance in W/(sr*m2), which 
    should be multiplied by 683.002 lm/W to get the corresponding luminance in cd/m2.
    The rgb-components of returned value are color components expressed in linear sRGB color space.
    Relative luminance of returned color is close to 1 for temperatures above about 1000 K.
    Note, that returned color can have negative components, which means that chromaticity of a black body
    is outside the sRGB gamut for a given temperature (g-component < 0 for temperatures below about 900 K and
    b-component < 0 for temperatures below about 1900 K).
    To get final color of a black body radiation with luminance in cd/m2 
    the rgb-components should be multiplied by the alpha-component and by 683.002 lm/W.
    
    sRGB is defined according to ITU-R BT.709:
                        x       y
        white point = 0.3127, 0.3290
        red prime   =   0.64,   0.33
        green prime =   0.30,   0.60
        blue prime  =   0.15,	0.06
    More details can be found here https://www.desmos.com/calculator/8pjrrlw951
    
    T - temperature in degrees Kelvin;
    bComputeRadiance - if true, effective radiance is computed;
    bComputeChromaticity - if true, chromaticity is computed;
    
    returns: float4 ChromaRadiance = {chroma_r, chroma_g, chroma_b, effRadiance}
*/
float4 BlackBodyRadiation(float T, bool bComputeRadiance, bool bComputeChromaticity)
{
    [branch] if(T <= 0.0)
        return float4(0.0, 0.0, 0.0, 0.0);

    float4 ChromaRadiance = {0.0, 0.0, 0.0, 0.0};
    
    // --- Effective radiance in W/(sr*m2) ---
    [branch] if(bComputeRadiance)
        ChromaRadiance.a = 230141698.067 / (exp(25724.2/T) - 1.0);
    
    // luminance Lv = Km*ChromaRadiance.a in cd/m2, where Km = 683.002 lm/W
    
    // --- Chromaticity in linear sRGB ---
    // (i.e. color luminance Y = dot({r,g,b}, {0.2126, 0.7152, 0.0722}) = 1)
    [branch] if(bComputeChromaticity)
    {
        // --- R ---
        float u = 0.000536332*T;
        ChromaRadiance.r = 0.638749 + (u + 1.57533) / (u*u + 0.28664);
        
        // --- G ---
        u = 0.0019639*T;
        ChromaRadiance.g = 0.971029 + (u - 10.8015) / (u*u + 6.59002);
        
        // --- B ---
        float p = 0.00668406*T + 23.3962;
        u = 0.000941064*T;
        float q = u*u + 0.00100641*T + 10.9068;
        ChromaRadiance.b = 2.25398 - p/q;
    }
    
    return ChromaRadiance;
}
