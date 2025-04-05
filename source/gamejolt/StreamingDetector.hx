package gamejolt;

import sys.io.Process;

class StreamingDetector
{
    public static final STREAMING_APPS:Array<String> = [
        'obs32.exe',
        'obs64.exe',
        'streamlabs obs.exe',
        'bdcam.exe',
        'fraps.exe',
        'xsplit.core.exe',
        'hycam2.exe',
        'twitchstudio.exe',
        'gamecaster.exe',
        'nvidia share.exe' // ShadowPlay/GeForce Experience
    ];

    public static function isStreaming():Bool
    {
        #if windows
        try {
            // Ejecutar tasklist y leer la salida
            var process = new Process('tasklist', []);
            var output = process.stdout.readAll().toString().toLowerCase();
            process.close();
            
            // Buscar cualquier aplicación de streaming
            for (app in STREAMING_APPS) {
                if (output.indexOf(app) != -1) {
                    trace('Aplicación de streaming detectada: $app');
                    return true;
                }
            }
        } catch (e:Dynamic) {
            trace('Error al verificar procesos:', e);
        }
        #end
        
        // Para otras plataformas podrías implementar diferentes métodos
        #if linux
        // Implementación para Linux...
        #end
        
        #if mac
        // Implementación para Mac...
        #end
        
        return false;
    }
}