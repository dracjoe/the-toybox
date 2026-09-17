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

#define MM 0

lowp float ofs = 0.5;

lowp float RATIO = 0.8,              // stone length/width ratio
 /*   STONE_slope = 0.3,        // 0.  .3  .3  -.3
      STONE_height = 1.0,       // 1.  1.  .6   .7
      profile = 1.0,            // z = height + slope * dist ^ prof
 */   
      CRACK_depth = 1.0,
      CRACK_zebra_scale = 0.5,  // fractal shape of the fault zebra
      CRACK_zebra_amp = 0.5,
      CRACK_profile = 1.25,      // fault vertical shape  1.  .2 
      CRACK_slope = 80.0,       //                      10.  1.4
      CRACK_width = 0.0;
    
// === Voronoi =====================================================
// --- Base Voronoi. inspired by https://www.shadertoy.com/view/MslGD8

#define hash22(p)  fract( 18.5453 * sin( p * mat2(127.1,311.7,269.5,183.3)) )
#define disp(p) ( -ofs + (1.0+2.0*ofs) * hash22(p) )

// --- Voronoi distance to borders. inspired by https://www.shadertoy.com/view/ldl3W8
lowp vec3 voronoiB( lowp vec2 u )  // returns len + id
{
    lowp vec2 iu = floor(u), C, P;
	lowp float m = float(1e9),d;
    for( int k=0; k < 25; k++ ) {
        lowp vec2  p = iu + vec2(int(mod(float(k),5.0))-2,k/5-2),
              o = disp(p),
      	      r = p - u + o;
		d = dot(r,r);
        if( d < m ) m = d, C = p-iu, P = r;
    }

    m = float(1e9);
    
    for( int k=0; k < 25; k++ ) {
        lowp vec2 p = iu+C + vec2(int(mod(float(k),5.0))-2,k/5-2),
		     o = disp(p),
             r = p-u + o;

        if( dot(P-r,P-r)>0.00001 )
        m = min( m, 0.5*dot( (P+r), normalize(r-P) ) );
    }

    return vec3( m, P+u );
}

// === pseudo Perlin noise =============================================
#define rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
int MOD = 1;  // type of Perlin noise
    
// --- 2D
#define hash21(p) fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453123)
lowp float noise2(lowp vec2 p) {
    lowp vec2 i = floor(p);
    lowp vec2 f = fract(p); f = f*f*(3.0-2.0*f); // smoothstep

    lowp float v= mix( mix(hash21(i+vec2(0.0,0.0)),hash21(i+vec2(1.0,0.0)),f.x),
                  mix(hash21(i+vec2(0.0,1.0)),hash21(i+vec2(1.0,1.0)),f.x), f.y);
	return   MOD==0 ? v
	       : MOD==1 ? 2.0*v-1.0
           : MOD==2 ? abs(2.0*v-1.0)
                    : 1.0-abs(2.0*v-1.0);
}

#define noise22(p) vec2(noise2(p),noise2(p+17.7))
lowp vec2 fbm22(lowp vec2 p) {
    lowp vec2 v = vec2(0.0,0.0);
    lowp float a = 0.5;
    lowp mat2 R = rot(0.37);

    for (int i = 0; i < 6; i++, p*=2.0,a/=2.0) 
        p *= R,
        v += a * noise22(p);

    return v;
}

lowp vec3 rgbToHsl(lowp vec3 color)
{
    lowp float hue=0.0, sat=0.0, lum=0.0;
    lowp float cmx=max(color.r, max(color.g, color.b));
    lowp float cmn=min(color.r, min(color.g, color.b));
    lowp float dif=cmx-cmn;

    lum = (cmx+cmn)/2.0;
    if(abs(dif)>0.01)
    {
        sat = dif/(1.0-abs(2.0*lum-1.0));
        
        if(cmx==color.r) hue = mod((color.g-color.b)/dif, 6.0);
        else if(cmx==color.g) hue = (color.b-color.r)/dif+2.0;
        else hue = (color.r-color.g)/dif+4.0;
    }

    return vec3(hue,sat,lum);
}
lowp vec3 hslToRgb(lowp vec3 hsl)
{
    lowp float r=0.0, g=0.0, b=0.0;
    lowp float c = (1.0-abs(2.0*hsl.b-1.0))*hsl.g;
    lowp float x = c*(1.0-abs(mod(hsl.r, 2.0)-1.0));

    if(hsl.r<=1.0) r=c, g=x;
    else if(hsl.r<=2.0) r=x, g=c;
    else if(hsl.r<=3.0) g=c, b=x;
    else if(hsl.r<=4.0) g=x, b=c;
    else if(hsl.r<=5.0) r=x, b=c;
    else r=c, b=x;

    return vec3(r,g,b)+vec3(hsl.b-c/2.0);
}

void main(void)
{
    if(dot(gl_FragCoord.xy, ClipPlaneOut.xy) < ClipPlaneOut.z)
		discard;
    lowp vec2 pa = vec2(1.0+PixelationAmountOut, 1.0+PixelationAmountOut) / TextureSizeOut;
    lowp vec4 texColor = Color0 * texture2D(Texture0, PixelationAmountOut > 0.0 ? TexCoord0 - mod(TexCoord0, pa) + pa * 0.5 : TexCoord0);
    lowp float time = ColorizeOut.r+0.0;

    lowp vec2 newCoord = TexCoord0+vec2(time*10.0,0.0);
    lowp float pixelscale = 1.0;
    newCoord = floor(newCoord*TextureSizeOut.xy/pixelscale)*pixelscale/TextureSizeOut.xy;

    lowp vec4 color = texColor;
    color.r += 0.15;
    color.g += 0.05;

    // Converts color to pure green, makes it more saturated
    lowp vec3 hsl = rgbToHsl(color.rgb);
    hsl.r = 0.21; // hue
    hsl.g = 0.42; // sat
    hsl.b = hsl.b*0.4; // lum
    color.rgb = hslToRgb(hsl);
    //color.g += 0.15;

    lowp vec3 H0 = vec3(0.0,0.0,0.0);
    lowp vec3 crackColor = vec3(0.0,0.0,0.0);

    for(lowp float i=0.0; i<CRACK_depth ; i++) {
        lowp vec2 V =  newCoord / vec2(RATIO,1.0),
             D = CRACK_zebra_amp * fbm22(newCoord/CRACK_zebra_scale) * CRACK_zebra_scale;
        lowp vec3  H = voronoiB( V + D ); if (i==0.0) H0=H;
        lowp float d = H.x;
        d = min( 1.0, CRACK_slope * pow(max(0.0,d-CRACK_width),CRACK_profile) );
  
        crackColor += vec3(1.0-d, 1.0-d, 1.0-d) / exp2(i);
    }
    crackColor.rgb = vec3(1.0,1.0,1.0)-crackColor.rgb;
    color.rgb *= crackColor.rgb;

    color.rgb = mix(texColor.rgb, color.rgb, texColor.a);
    gl_FragColor = vec4(color.rgb + ColorOffsetOut * color.a, texColor.a);
}
