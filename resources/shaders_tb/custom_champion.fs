#ifndef GL_ES
#  define lowp
#  define mediump
#endif

varying lowp vec4 Color0;
varying mediump vec2 TexCoord0;
varying lowp vec4 ColorizeOut;
varying lowp vec3 ColorOffsetOut;
varying lowp vec2 TextureSizeOut;
varying lowp float PixelationAmountOut;
varying lowp vec3 ClipPlaneOut;
uniform sampler2D Texture0;
const lowp vec3 _lum = vec3(0.212671, 0.715160, 0.072169);
const lowp float _pi =  3.14159265359;

#define USE_PREMULTIPLIED_ALPHA

lowp vec2 getPixelatedCoord(lowp vec2 coord)
{
	lowp vec2 pa = vec2(1.0+PixelationAmountOut, 1.0+PixelationAmountOut) / TextureSizeOut;
	return PixelationAmountOut > 0.0 ? coord - mod(coord, pa) + pa * 0.5 : coord;
}

lowp vec3 unpackColor(lowp float c)
{
	return vec3(
		floor(c/10.0)/100.0,
		floor(mod(c,10.0)*100.0)/100.0,
		mod(c*1000.0,10.0)
	);
}

lowp vec4 getChampionColor(lowp vec3 baseColor, lowp float modifier)
{
	if(modifier>=1.0 && modifier<2.0)
	{
		lowp vec4 defaultColor = vec4(unpackColor(baseColor.r), 1.0);

		lowp vec2 centeredCoord = (abs(gl_FragCoord.xy-baseColor.gb)/100.0)*10.0;
		lowp float pixelScale = 0.25;
		centeredCoord = floor(centeredCoord/pixelScale)*pixelScale;

		lowp float dist = (sin((length(centeredCoord)+mod(modifier, 1.0)*2.0*_pi)*9.0)+1.0)*0.5;
		dist = pow(dist, 0.25)*0.5+0.5;

		return vec4(defaultColor.rgb*dist, defaultColor.a);
	}
	else if(modifier>=2.0 && modifier<3.0)
	{
		lowp vec4 defaultColor = vec4(unpackColor(baseColor.r), 1.0);
		lowp float time = mod(modifier, 1.0);

		lowp vec2 centeredCoord = ((gl_FragCoord.xy-baseColor.gb)/100.0)*10.0;
		lowp float pixelScale = 0.25;
		centeredCoord = floor(centeredCoord/pixelScale)*pixelScale;

		lowp float noise = fract(sin(dot(vec2(floor((centeredCoord.x+time*2.0)*5.54)/5.54, 0.0), vec2(12.9898, 78.233))) * 43758.5453);

		lowp float sinAngle = (centeredCoord.y+sin(centeredCoord.x*3.0)*0.25*(noise*3.0)-time*2.0*_pi)*5.0;
		sinAngle = floor(sinAngle/pixelScale)*pixelScale;

		lowp float dist = (sin(sinAngle)+1.0)*0.5;
		dist = pow(dist, 0.25)*0.4+0.6;

		return vec4(defaultColor.rgb*dist, defaultColor.a);
	}
	else if(modifier>=3.0 && modifier<4.0)
	{

	}

	return vec4(baseColor, 1.0);
}

lowp vec4 evaluateFinalColor(lowp vec4 currentColor, lowp vec3 baseColor, lowp float modifier)
{
	if(modifier>=3.0 && modifier<4.0)
	{
		lowp float lum = dot(currentColor.rgb, _lum);
		if(lum<0.05)
		{
			currentColor.rgb = vec3(1.0, 0.05, 0.05)*currentColor.a;
		}
		else
		{
			currentColor.rgb = vec3(0.0, 0.0, 0.0);
		}

		return currentColor;
	}

	return currentColor;
}

void main(void)
{
	// Clip
	if(dot(gl_FragCoord.xy, ClipPlaneOut.xy) < ClipPlaneOut.z)
		discard;
	
	// Pixelate
	bool usesShader = ColorizeOut.a >= 0.0;
	lowp float modifier = usesShader ? ColorizeOut.a : (-ColorizeOut.a-1.0);
	lowp vec4 champColor = getChampionColor(ColorizeOut.rgb, modifier);

	
	lowp vec4 SourceColor = texture2D(Texture0, getPixelatedCoord(TexCoord0));
	if(!usesShader)
	{
		champColor.a *= 1.5;
		SourceColor.a = (0.5+(1.0-(dot(SourceColor.rgb, _lum)*0.5+0.5))*0.5)*SourceColor.a;
	}

	if(SourceColor.a < 0.5)
	{
		// alpha < 0.5, leave color unchanged and remap opacity to [0;1]
#ifdef USE_PREMULTIPLIED_ALPHA
		SourceColor *= 2.00788; // 255/127
#else
		SourceColor.a *= 2.00788;
#endif
	}
	else
	{
		// alpha > 0.5, blend with champion color
#ifdef USE_PREMULTIPLIED_ALPHA
		SourceColor.rgb /= SourceColor.a;
		//SourceColor = mix(vec4(ChampionColorOut.rgb * dot(SourceColor.rgb, _lum), ChampionColorOut.a), vec4(SourceColor.rgb, 1.0), (SourceColor.a - 0.50196) * 2.00788);
		SourceColor = mix(vec4(SourceColor.rgb, 1.0), vec4(champColor.rgb * dot(SourceColor.rgb, _lum), 1.0), champColor.a * (1.0 - SourceColor.a) * 2.00788);
		SourceColor.rgb *= SourceColor.a;
#else
		//SourceColor = mix(vec4(ChampionColorOut.rgb * dot(SourceColor.rgb, _lum), ChampionColorOut.a), vec4(SourceColor.rgb, 1.0), (SourceColor.a - 0.50196) * 2.00788);
		SourceColor = mix(vec4(SourceColor.rgb, 1.0), vec4(champColor.rgb * dot(SourceColor.rgb, _lum), 1.0), champColor.a * (1.0 - SourceColor.a) * 2.00788);
#endif
	}

	SourceColor = evaluateFinalColor(SourceColor, ColorizeOut.rgb, modifier);
	
	lowp vec4 Color = Color0 * SourceColor;
	lowp vec3 Colorized = Color.rgb;//mix(Color.rgb, dot(Color.rgb, _lum) * ColorizeOut.rgb, ColorizeOut.a);
	gl_FragColor = vec4(Colorized + ColorOffsetOut * Color.a, Color.a);
	
	// Color reduction
	gl_FragColor.rgb = mix(gl_FragColor.rgb, gl_FragColor.rgb - mod(gl_FragColor.rgb, 1.0/16.0), clamp(PixelationAmountOut, 0.0, 1.0));
}

/*
void main(void)
{
	vec4 SourceColor = texture2D(Texture0, TexCoord0);
	if(SourceColor.a < 0.5)
	{
		// alpha < 0.5, leave color unchanged and remap opacity to [0;1]
#ifdef USE_PREMULTIPLIED_ALPHA
		SourceColor *= 2.00788; // 255/127
#else
		SourceColor.a *= 2.00788;
#endif
	}
	else
	{
		// alpha > 0.5, blend with champion color
#ifdef USE_PREMULTIPLIED_ALPHA
		SourceColor.rgb /= SourceColor.a;
		SourceColor = mix(vec4(ChampionColorOut.rgb * dot(SourceColor.rgb, _lum), ChampionColorOut.a), vec4(SourceColor.rgb, 1.0), (SourceColor.a - 0.50196) * 2.00788);
		SourceColor.rgb *= SourceColor.a;
#else
		SourceColor = mix(vec4(ChampionColorOut.rgb * dot(SourceColor.rgb, _lum), ChampionColorOut.a), vec4(SourceColor.rgb, 1.0), (SourceColor.a - 0.50196) * 2.00788);
#endif
	}
	
	vec4 Color = Color0 * SourceColor;
	vec3 Colorized = mix(Color.rgb, dot(Color.rgb, _lum) * ColorizeOut.rgb, ColorizeOut.a);
	gl_FragColor = vec4(Colorized + ColorOffsetOut * Color.a, Color.a);
}
*/
