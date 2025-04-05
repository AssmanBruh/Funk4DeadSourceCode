package gamejolt;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.api.FlxGameJolt;
import flixel.addons.display.FlxBackdrop;
import openfl.display.Bitmap;
import openfl.display.Loader;
import openfl.net.URLRequest;
import flixel.util.FlxTimer;

class GameJoltLoggedMenu extends MusicBeatSubstate {
    private var userAvatar:FlxSprite;
    private var usernameText:FlxText;
    private var titleText:FlxText;
    
    public function new() {
        super();
        
        // Fondo semitransparente
        var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0.7;
        add(bg);
        
        // Panel principal
        var panel = new FlxSprite(FlxG.width * 0.1, FlxG.height * 0.1);
        panel.makeGraphic(Std.int(FlxG.width * 0.8), Std.int(FlxG.height * 0.8), FlxColor.fromRGB(40, 40, 50));
        panel.alpha = 0.9;
        add(panel);
        
        // Título
        titleText = new FlxText(panel.x + 20, panel.y + 20, 0, "Logged as:", 32);
        titleText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT);
        add(titleText);
        
        // Nombre de usuario
        usernameText = new FlxText(panel.x + 20, titleText.y + 50, 0, GameJoltClient.username, 28);
        usernameText.setFormat(Paths.font("vcr.ttf"), 28, FlxColor.CYAN, LEFT);
        add(usernameText);
        
        // Avatar placeholder
        userAvatar = new FlxSprite(panel.x + panel.width - 150, panel.y + 50);
        userAvatar.makeGraphic(128, 128, FlxColor.GRAY);
        add(userAvatar);
        
        // Cargar avatar real
        loadAvatar();
        
        // Botón de cerrar
        var closeButton = new FlxButton(panel.x + panel.width - 50, panel.y + 10, "X", function() {
            close();
        });
        add(closeButton);
        
        // Más elementos pueden añadirse aquí...
    }
    
    private function loadAvatar():Void {
        if (FlxGameJolt.user != null && FlxGameJolt.user.avatar_url != null) {
            var loader = new Loader();
            loader.contentLoaderInfo.addEventListener(openfl.events.Event.COMPLETE, function(e) {
                var bitmap:Bitmap = cast(loader.content, Bitmap);
                if (bitmap != null) {
                    userAvatar.pixels = bitmap.bitmapData;
                    userAvatar.updateHitbox();
                }
            });
            loader.load(new URLRequest(FlxGameJolt.user.avatar_url));
        }
    }
    
    override function update(elapsed:Float):Void {
        super.update(elapsed);
        
        if (controls.BACK) {
            close();
        }
    }
    
    private function close():Void {
        FlxG.state.closeSubState();
    }
}