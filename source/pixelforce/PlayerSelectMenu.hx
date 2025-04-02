package pixelforce;

import flixel.FlxSprite;
import flixel.FlxG;

class PlayerSelectMenu extends PixelForceState {

    var bf:Bf;
    var bfBanner:FlxSprite;
    var bg:FlxSprite;

    var positions = [80, 613.75,
                     674, 613.75,
                     674, 451.75,
                     80, 451.75];

    override function create(){
        super.create();

        bg =new FlxSprite(0,0).loadGraphic(Paths.image("pixel/title/bg", "f4d"));
        bg.updateHitbox();
        add(bg);

        bfBanner = new FlxSprite(314.15, 152.4).loadGraphic(Paths.image("pixel/title/bfPortrait", "f4d"));
        bfBanner.updateHitbox();
        add(bfBanner);
        var startpos = [80, 613.75];

        bf = new Bf(startpos, true);
        add(bf);
        bf.playWalk("right");
    }

    override function onUpdate(elapsed:Float) {
        super.onUpdate(elapsed);

        if (FlxG.keys.justPressed.SHIFT){
            trace("bf pos X: " + bf.x + ", bf pos Y: " + bf.y);
        }
        
        if (bf.x > 674){
            bf.playWalk("up");
        } if (bf.y < 451){
            bf.playWalk("left");
        } if (bf.x < 80){
            bf.playWalk("down");
        }if (bf.y > 613){
            bf.playWalk("right");
        }
    }
}