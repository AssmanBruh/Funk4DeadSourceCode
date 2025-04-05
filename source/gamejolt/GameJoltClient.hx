package gamejolt;

import flixel.FlxG;

class GameJoltClient {
    public static var username(default, set):String = "guest";
    public static var userToken(default, set):String = "";
    public static var rememberMe(default, set):Bool = false;
    public static var gameJoltPrivateKey:String = "";
    public static var gameJoltGameID:Int = 0;
    
    // Inicializar con datos guardados
    public static function init():Void {
        loadSavedData();
    }
    
    // Cargar datos guardados
    private static function loadSavedData():Void {
        if (FlxG.save.data != null){
        if (FlxG.save.data.gameJoltData != null) {
            username = FlxG.save.data.gameJoltData.username;
            userToken = FlxG.save.data.gameJoltData.userToken;
            rememberMe = FlxG.save.data.gameJoltData.rememberMe;
        }
        }
    }
    
    // Guardar todos los datos
    public static function saveData():Void {
        FlxG.save.data.gameJoltData = {
            username: username,
            userToken: userToken,
            rememberMe: rememberMe
        };
        FlxG.save.flush();
    }
    
    // Limpiar datos (logout)
    public static function clearData():Void {
        username = "guest";
        userToken = "";
        rememberMe = false;
        
        FlxG.save.data.gameJoltData = null;
        FlxG.save.flush();
    }
    
    // Setters con guardado automático
    private static function set_username(value:String):String {
        username = value;
        if (rememberMe) saveData();
        return value;
    }
    
    private static function set_userToken(value:String):String {
        userToken = value;
        if (rememberMe) saveData();
        return value;
    }
    
    private static function set_rememberMe(value:Bool):Bool {
        rememberMe = value;
        saveData(); // Siempre guardar este cambio
        return value;
    }
    
    // Verificar si hay credenciales guardadas
    public static function hasSavedCredentials():Bool {
        return rememberMe && username != "guest" && userToken != "";
    }
}