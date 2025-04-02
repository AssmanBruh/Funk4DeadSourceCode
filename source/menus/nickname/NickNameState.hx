package menus.nickname;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.text.FlxInputText;
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
import flixel.input.mouse.FlxMouseEvent;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

// opcion quant notes
class NickNameState extends MusicBeatSubstate{
   
    // METADATA
    var DUMBIEAVATAR_X = 92.85;
    var DUMBIEAVATAR_Y = 466.1;

    var PFPMARK_X = 79.1;
    var PFPMARK_Y = 454.8;

    var PFP_X = 92.85;
    var PFP_Y = 467.6;

    var PFP_SIZE = 206;
    // END METADATA

    // create variables
    var save:FlxSave;
    var file:FileReference;
    var dumbieavatar_spr:FlxSprite;
    var pfpMark:FlxSprite;
    var pfp:FlxSprite;
    var savePath:String;

    public static var isPFPLoaded:Bool = false; //dumbasshitvaginapene

    public function new() {
        super();	

        var bg:FlxSprite = new FlxSprite(0,0).makeGraphic(FlxG.width, FlxG.height,FlxColor.BLACK);
        bg.screenCenter();
        bg.alpha = 0;
        add(bg);
        FlxTween.tween(bg, {alpha:0.7}, 0.7, {ease: FlxEase.circIn});

        save = new FlxSave(); // svae pfp path
        save.bind("profilePicture");

        if (!isPFPLoaded){
        dumbieavatar_spr = new FlxSprite(DUMBIEAVATAR_X, DUMBIEAVATAR_Y);
        dumbieavatar_spr.frames = Paths.getSparrowAtlas("nickname_menu/dumbAvatar", "f4d");
        dumbieavatar_spr.animation.addByPrefix("dumb", "avatar", 24, true);
        dumbieavatar_spr.animation.play("dumb",true);
        dumbieavatar_spr.antialiasing = ClientPrefs.globalAntialiasing;
        dumbieavatar_spr.visible = true;
        dumbieavatar_spr.updateHitbox();
        add(dumbieavatar_spr);
        FlxMouseEvent.add(dumbieavatar_spr, 
            function(object:FlxSprite/*mousedown*/){
                  if (dumbieavatar_spr.visible){
                        loadImage();
                  }
            },
            function(object:FlxSprite/**onUp**/){

            },
            function(object:FlxSprite/**onmouseover**/){
            },
            function(object:FlxSprite/**onmouseout**/){
            }
        );

        pfp = new FlxSprite(PFP_X, PFP_Y);
        pfp.visible = false;
        add(pfp);
        pfpMark = new FlxSprite(PFPMARK_X, PFPMARK_Y);
        pfpMark.frames = Paths.getSparrowAtlas("nickname_menu/pfpMark", "f4d");
        pfpMark.animation.addByPrefix("mark", "mark",0,false); // hmmm, not modding here!! Z:VV
        pfpMark.animation.addByPrefix("select", "pfp select", 24, true);
        pfpMark.animation.play("mark");
        pfpMark.antialiasing = true;
        pfpMark.visible = false;
        pfpMark.updateHitbox();
        add(pfpMark);
        FlxMouseEvent.add(pfp, 
            function(object:FlxSprite/*mousedown*/){
            },
            function(object:FlxSprite/**onUp**/){
                if (pfpMark.animation.curAnim != null)
                    if (pfpMark.animation.curAnim.name == "select"){
                        loadImage();
                    }
            },
            function(object:FlxSprite/**onmouseover**/){
                pfpMark.animation.play("select",true);
            },
            function(object:FlxSprite/**onmouseout**/){
                pfpMark.animation.play("mark",true);
            }
        );
        pfp.setPosition(pfpMark.x+13.75, pfpMark.y+12.8);
        }else{
                // init fuckers
            savePath = save.data.pfpPath;
            trace(savePath);
            // savePath.replace(" C:/Users/cybertel/Desktop/games/JuegoDeTerror/SpectoGram/export/hl/bin/", "");
            trace(savePath);
            pfp = new FlxSprite(PFP_X, PFP_Y);
            add(pfp);
            // LOAD
           
            if (FileSystem.exists(savePath)) {
                // var bmpData = BitmapData.fromFile(savePath);
                // var graphic = FlxGraphic.fromBitmapData(bmpData);
                pfp.loadGraphic(savePath);
                pfp.setGraphicSize(PFP_SIZE, PFP_SIZE);
                pfp.updateHitbox();
                // attach pfp to mark!!
            }
            // END LOAD

            pfpMark = new FlxSprite(PFPMARK_X, PFPMARK_Y);
            pfpMark.frames = Paths.getSparrowAtlas("nickname_menu/pfpMark", "f4d");
            pfpMark.animation.addByPrefix("mark", "mark",0,false); // hmmm, not modding here!! Z:VV
            pfpMark.animation.addByPrefix("select", "pfp select", 24, true);
            pfpMark.animation.play("mark");
            pfpMark.antialiasing = true;
            pfpMark.updateHitbox();
            add(pfpMark);
            FlxMouseEvent.add(pfp, 
                function(object:FlxSprite/*mousedown*/){
                },
                function(object:FlxSprite/**onUp**/){
                    if (pfpMark.animation.curAnim != null)
                        if (pfpMark.animation.curAnim.name == "select"){
                            loadImage();
                        }
                },
                function(object:FlxSprite/**onmouseover**/){
                    pfpMark.animation.play("select",true);
                },
                function(object:FlxSprite/**onmouseout**/){
                    pfpMark.animation.play("mark",true);
                }
            );
            
            if (FileSystem.exists(savePath)) {
                // Im dumb
                // attach pfp to mark!!
                pfp.setPosition(pfpMark.x+13.75, pfpMark.y+12.8);
            }
        }
    }

    override function update(elapsed:Float){
        super.update(elapsed);

        if (FlxG.keys.justPressed.NINE){
            FlxG.save.data.isPFPLoaded = null;
            trace("reset");
        }

        if (controls.BACK){
            close();
        }
    }

    // WINDOW SHITS
    function getUsername():String {
        #if sys
        return Sys.environment()["USERNAME"];
        #end
    }
    

    // PFP LOADER SHITS
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
                var circularBmp = createCircularBitmap(bmpData, PFP_SIZE);
                var graphic = FlxGraphic.fromBitmapData(circularBmp);
                pfp.loadGraphic(graphic);
                pfp.setGraphicSize(PFP_SIZE, PFP_SIZE);
                pfp.updateHitbox();
                pfp.setPosition(pfpMark.x+13.75, pfpMark.y+12.8);
                if (!pfp.visible)
                pfp.visible = true;
                if (!pfpMark.visible)
                pfpMark.visible = true;
                if (dumbieavatar_spr != null)
                dumbieavatar_spr.visible = false;
                var savePath = "pfp/pfp.png";
                var byteArray:ByteArray = new ByteArray();
                circularBmp.encode(new Rectangle(0, 0, circularBmp.width, circularBmp.height), new PNGEncoderOptions(), byteArray);
                File.saveBytes(savePath, byteArray);
                
                // savePath = file.name;
                trace(savePath);
                save.data.pfpPath = savePath;
                save.flush();
                
                isPFPLoaded = true;
                FlxG.save.data.isPFPLoaded = isPFPLoaded;
                trace(isPFPLoaded);
            });
            loader.loadBytes(file.data);
        });
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
    // END
}