import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.text.FlxInputText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxSave;
import lime.system.System;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.display.PNGEncoderOptions;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.net.FileFilter;
import openfl.net.FileReference;
import openfl.utils.ByteArray;
import sys.FileSystem;
import sys.io.File;

using StringTools;
class MenuState extends FlxState {
    var input:FlxInputText;
    var pfp:FlxSprite;
    var save:FlxSave;
    var file:FileReference;
    var savePath:String;
    
    override public function create():Void {
        super.create();
        
        savePath = haxe.io.Path.normalize(Sys.getCwd() + "/user_pfp.png");
        // savePath.replace(" C:/Users/cybertel/Desktop/games/JuegoDeTerror/SpectoGram/export/hl/bin/", "");
        trace(savePath);
        
        // Input de texto
        input = new FlxInputText(10, 10, 200, "");
        
        add(input);
        
        // Botón para obtener el nombre de usuario
        var btnUser = new FlxButton(10, 40, "Get Windows Username", getUsername);
        add(btnUser);
        
        // Botón para cargar imagen
        var btnLoadImg = new FlxButton(10, 70, "Cargar Imagen", loadImage);
        add(btnLoadImg);
        
        // Sprite para la imagen de perfil
        pfp = new FlxSprite(220, 10);
        add(pfp);
        
        // Guardado
        save = new FlxSave();
        save.bind("profileData");
        
        // Cargar imagen si existe
        if (FileSystem.exists(savePath)) {
            var bmpData = BitmapData.fromFile(savePath);
            var graphic = FlxGraphic.fromBitmapData(bmpData);
            pfp.loadGraphic(graphic);
            pfp.setGraphicSize(64, 64);
            pfp.updateHitbox();
        }
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (input.hasFocus) {
            trace("escribiendo...");
        };
        else{
            trace("dejo de escribir.");
        };

        var avaiableKeys = FlxG.keys.justPressed.ANY;
        // var blockedkeys:Array = ;
        if (input.hasFocus && !FlxG.keys.anyJustPressed([SPACE,PERIOD,COMMA,SEMICOLON,SLASH,BACKSLASH,MINUS,EQUAL,LBRACKET,RBRACKET, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, PRINTSLOCK]) && avaiableKeys) {
            flashEffect();
        }
    }
    
    function flashEffect():Void {
       FlxG.camera.flash(0xFFFFFFFF, 0.12);
    }
    
    function getUsername():Void {
        #if sys
        input.text = Sys.environment()["USERNAME"];
        #end
    }
    
    function loadImage():Void {
        file = new FileReference();
        file.browse([new FileFilter("Images", "*.png;*.jpg;*.jpeg;*.bmp")]);
        file.addEventListener(Event.SELECT, function(_) {
            file.load();
        });
        file.addEventListener(Event.COMPLETE, function(_) {
            var loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(_) {
                var bmpData:BitmapData = cast(loader.content, openfl.display.Bitmap).bitmapData;
                var circularBmp = createCircularBitmap(bmpData, 64);
                var graphic = FlxGraphic.fromBitmapData(circularBmp);
                pfp.loadGraphic(graphic);
                pfp.setGraphicSize(64, 64);
                pfp.updateHitbox();
                
                saveImage(circularBmp);
            });
            loader.loadBytes(file.data);
        });
    }
    
    function saveImage(bmpData:BitmapData):Void {
        var byteArray:ByteArray = new ByteArray();
        bmpData.encode(new Rectangle(0, 0, bmpData.width, bmpData.height), new PNGEncoderOptions(), byteArray);
        
        try {
            File.saveBytes(savePath, byteArray);
            save.data.pfpPath = savePath;
            save.flush();
            trace("Imagen guardada correctamente en: " + savePath);
        } catch (e:Dynamic) {
            trace("Error al guardar la imagen: " + e);
        }
    }
    
    function createCircularBitmap(source:BitmapData, size:Int):BitmapData {
        var bmp = new BitmapData(size, size, true, 0x00000000);
        var temp = new BitmapData(size, size, true, 0x00000000);
        
        var scaleMatrix = new Matrix();
        scaleMatrix.scale(size / source.width, size / source.height);
        temp.draw(source, scaleMatrix, null, null, null, true);
        
        var mask = new Shape();
        mask.graphics.beginFill(0xFFFFFF);
        mask.graphics.drawCircle(size / 2, size / 2, size / 2);
        mask.graphics.endFill();
        
        var maskBmp = new BitmapData(size, size, true, 0x00000000);
        maskBmp.draw(mask);
        
        bmp.copyPixels(temp, new Rectangle(0, 0, size, size), new openfl.geom.Point(0, 0), maskBmp, new openfl.geom.Point(0, 0), true);
        
        return bmp;
    }
}
