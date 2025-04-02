package shaders;

import flixel.system.FlxAssets.FlxShader; 

class SaturationShaderEffect extends FlxShader{
    @:glFragmentSource('
    #pragma header
    const vec2 iResolution = vec2(1,  1);
    #define iChannel0 bitmap

    uniform float brightness ;
    uniform float contrast ;
    uniform float saturation ;

    mat4 brightnessMatrix( float brightness )
    {
        return mat4( 1, 0, 0, 0,
                     0, 1, 0, 0,
                     0, 0, 1, 0,
                     brightness, brightness, brightness, 1 );
    }
    
    mat4 contrastMatrix( float contrast )
    {
        float t = ( 1.0 - contrast ) / 2.0;
        
        return mat4( contrast, 0, 0, 0,
                     0, contrast, 0, 0,
                     0, 0, contrast, 0,
                     t, t, t, 1 );
    
    }
    
    mat4 saturationMatrix( float saturation)
    {
        vec3 luminance = vec3( 0.3086, 0.6094, 0.0820 );
        
        float oneMinusSat = 1.0 - saturation;
        
        vec3 red = vec3( luminance.x * oneMinusSat );
        red+= vec3( saturation, 0, 0 );
        
        vec3 green = vec3( luminance.y * oneMinusSat );
        green += vec3( 0, saturation, 0 );
        
        vec3 blue = vec3( luminance.z * oneMinusSat );
        blue += vec3( 0, 0, saturation );
        
        return mat4( red,     0,
                     green,   0,
                     blue,    0,
                     0, 0, 0, 1 );
    }
    

    
    void main()
    {
        vec4 color = texture( iChannel0, openfl_TextureCoordv/iResolution.xy );
        
        gl_FragColor = brightnessMatrix( brightness ) *
                    contrastMatrix( contrast ) * 
                    saturationMatrix( saturation ) *
                    color;
    }
')

 public function new (){
    super(); 

    data.brightness.value =[0.15];
    data.contrast.value = [1.2];
    data.saturation.value = [1.5]; 
    
 } 
 
}
   
class SaturationShader {
    public var Shader(default, null): SaturationShaderEffect = new SaturationShaderEffect();

    public var brightness: Float = 0;
    public var contrast: Float = 1; 
    public var saturation: Float = 1;

    public function new (){
        Shader.data.brightness.value = [brightness];
        Shader.data.contrast.value = [contrast];
        Shader.data.saturation.value = [saturation];
    }
    public function update(elapsed:Float){
        // var leBright = flixel.math.FlxMath.lerp(0, brightness, Math.min(0, Math.max(1, elapsed*4)));
     
        // var leSat = flixel.math.FlxMath.lerp(1, saturation, Math.min(0, Math.max(1, elapsed*4)));
     
        // var leContrast = flixel.math.FlxMath.lerp(1, contrast, Math.min(0, Math.max(1, elapsed*4)));
     
        // brightness = leBright; 
        // saturation = leSat;
        // contrast = leContrast;
     
        Shader.data.brightness.value = [brightness];
        Shader.data.contrast.value = [contrast];
        Shader.data.saturation.value = [saturation];
     }
}
