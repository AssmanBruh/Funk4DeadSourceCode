package gamejolt;

import flixel.addons.api.FlxGameJolt;
import flixel.FlxG;
import haxe.Json;
import sys.io.File;
import sys.FileSystem;

class GameJoltManager {
    public static var isLoggedIn:Bool = false;
    public static var username:String = "";
    public static var token:String = "";
    private static var initialized:Bool = false;
    
    // Inicializa la API de GameJolt
    public static function init():Void {
        if (initialized) return;
        initialized = true;
        
        // Cargar credenciales desde JSON
        var apiCredentials = loadAPICredentials();
        if (apiCredentials != null) {
            GameJoltClient.gameJoltGameID = apiCredentials.gameID;
            GameJoltClient.gameJoltPrivateKey = apiCredentials.privateKey;
            FlxGameJolt.init(apiCredentials.gameID, apiCredentials.privateKey);
        } else {
            trace("Error: No se pudieron cargar las credenciales de GameJolt API");
            return;
        }
        if (GameJoltClient.hasSavedCredentials()) {
            autoLogin();
        }
    }
    
    // Cargar credenciales API desde JSON
    private static function loadAPICredentials():{gameID:Int, privateKey:String} {
        try {
            var path = "assets/gamejolt/API.json";
            if (FileSystem.exists(path)) {
                var jsonString = File.getContent(path);
                trace("inited game! -- "+Json.parse(jsonString));
                return Json.parse(jsonString);
            } else {
                trace("Error: Archivo gamejoltapi.json no encontrado");
                return null;
            }
        } catch (e:Dynamic) {
            trace("Error al cargar gamejoltapi.json:", e);
            return null;
        }
    }
    
    // Intento de login automático con credenciales guardadas
    private static function autoLogin():Void {
        FlxGameJolt.authUser(GameJoltClient.username, GameJoltClient.userToken, function(data:Bool) {
            isLoggedIn = data;
            if (isLoggedIn) {
                trace("Auto-login successful!");
                fetchUserData();
            } else {
                trace("Auto-login failed. Credentials may be invalid.");
                GameJoltClient.clearData();
            }
        });
    }
    // Login manual
    public static function login(user:String, pass:String, remember:Bool, callback:Bool->Void):Void {
        FlxGameJolt.authUser(user, pass, function(data:Bool) {
            isLoggedIn = data;
            
            if (isLoggedIn) {
                username = user;
                token = pass;
                
                if (remember) {
                    saveCredentials(remember);
                } else {
                    clearCredentials();
                }
                
                fetchUserData();
            }
            
            callback(isLoggedIn);
        });
    }
    
    // Guardar credenciales
    private static function saveCredentials(remember = false):Void {
        GameJoltClient.username = username;
        GameJoltClient.userToken = token;
        GameJoltClient.rememberMe = remember;
    }
    
    // Eliminar credenciales guardadas
    private static function clearCredentials():Void {
        GameJoltClient.clearData();
    }
    
    // Obtener datos del usuario
    private static function fetchUserData():Void {
        FlxGameJolt.fetchUser(0, GameJoltClient.username, [], function(data:Dynamic) {
            if (data != null) {
                trace("User data:", data);
            }
        });
    }
    
    // Enviar trofeo
    public static function sendTrophy(trophyId:Int):Void {
        if (isLoggedIn) {
            FlxGameJolt.addTrophy(trophyId, function(data:Dynamic) {
                trace("Trophy unlocked:", data);
            });
        }
    }
    
    // Enviar puntuación
    public static function sendScore(score:Int, tableId:Int, extraData:String = ""):Void {
        if (isLoggedIn) {
            FlxGameJolt.addScore('${score} points', score, tableId, extraData, function(data:Dynamic) {
                trace("Score submitted:", data);
            });
        }
    }
    
    // Cerrar sesión
    public static function logout():Void {
        isLoggedIn = false;
        username = "";
        token = "";
        clearCredentials();
    }
}