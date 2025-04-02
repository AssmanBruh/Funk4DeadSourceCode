package pixelforce;

import flixel.util.FlxTimer;
import flixel.FlxBasic;
import lime.app.Application;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;

class PixelForceState extends MusicBeatState {
    var black:FlxSprite;
    var application = Application.current;
    var transalpha = 1.0;
    override function create(){
        super.create();
        application.window.width = 823;
        application.window.minimized = false;
        transIn = null;
		transOut = null;

        black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        black.alpha = 0;
        add(black);
        // this really active the transition shit
        gotoState(true, false);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (activarSioSi){
            onUpdate(elapsed);
        }
     
    }

    /**
        use this update func
        because the normal update func 
        dont works debido transition
        
    **/
    public function onUpdate(elapsed:Float) {
        if (controls.BACK){
            application.window.resize(1280, 720);
        }
    }

    /**
        active state when the black
        transition done's
    **/
    var activarSioSi:Bool = false;

    /**true to in, false to out**/
    public function gotoState(i:Bool=true, switched:Bool = false, ?nextState = null) {
         switch (i)  {
            case false:
            black.alpha = 0;
            new FlxTimer().start(0.3, function(tmr){
                black.alpha += 1/tmr.loopsLeft;
                if (tmr.loopsLeft < 1){
                    activarSioSi = true;
                    if (switched){
                        if (nextState != null)
                        FlxG.switchState(nextState);
                    }
                }
            },3);
            case true:
            black.alpha = 1;
            new FlxTimer().start(0.5, function(tmr){
                black.alpha -= 1/tmr.loopsLeft;
                if (tmr.loopsLeft < 2){
                    activarSioSi = true;
                }
            },3);
         }
    }

    override function add(Object:FlxBasic):FlxBasic
    {
        if (Std.isOfType(Object, FlxSprite))
            cast(Object, FlxSprite).antialiasing = false;
        return super.add(Object);
    }
}