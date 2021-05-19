# Black Body Radiation
The _BlackBodyRadiation_ function approximates luminance and chromaticity of a black body radiation emitted at the given temperature.
Approximation errors are not provided, so this function should not be used where computational accuracy is critical!
Instead, the primary purpose of this function is to render a black body surface in real time, which can be used in CG shaders,
therefore the function is written in HLSL.  

The luminance and chromaticity of a black body radiation are computed independently of each other.
The alpha-component of returned value is effective radiance in _W/(sr*m2)_, which 
should be multiplied by 683.002 _lm/W_ to get the corresponding luminance in _cd/m2_.
The rgb-components of returned value are color components expressed in linear sRGB color space.
Relative luminance of returned color is close to 1 for temperatures above about 1000 _K_.
Note, that returned color can have negative components, which means that chromaticity of a black body
is outside the sRGB gamut for a given temperature (g-component < 0 for temperatures below about 900 _K_ and
b-component < 0 for temperatures below about 1900 _K_).
To get final color of a black body radiation with luminance in _cd/m2_ 
the rgb-components should be multiplied by the alpha-component and by 683.002 _lm/W_.  

sRGB is defined according to **ITU-R BT.709**:

chromaticity | x | y
-------------|---|---
white point | 0.3127 | 0.3290  
red primary   |   0.64 |   0.33  
green primary |   0.30 |   0.60  
blue primary  |   0.15 |   0.06

<p align="left">
  <img src="https://raw.githubusercontent.com/zubetto/BlackBodyRadiation/master/BlackBody_Radiance.png" width="800" height="800"/>
</p>
<p align="left">
  <img src="https://raw.githubusercontent.com/zubetto/BlackBodyRadiation/master/BlackBody_Chroma.png" width="800" height="800"/>
</p>

More details about how this approximation was derived can be found here https://www.desmos.com/calculator/qaxw5zb0zc
