package editors;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;

class CharacterColorTest extends MusicBeatState{
    var dad:Character;
    var bf:Boyfriend;
    var colors:ColorSwap;
    override function create() {
        super.create();
		Paths.setCurrentLevel("shared");

        colors = new ColorSwap();

        dad = new Character(200, 200, "ellis");
        add(dad);
        bf = new Boyfriend(500, 200, "bf");
        add(bf);
        
        var t = new FlxText(20,20,0,"PRESS 0 TO HUE\nPRESS 1 TO BRIGTHNESS\nPRESS 2 TO SATURATION", 55);
        add(t);
    }
    var aidi:Int = 0;

    override function update(elapsed:Float){
        super.update(elapsed);

        if (FlxG.keys.justPressed.R){
            dad.brightness = 0;
            dad.hue = 0;
            dad.saturation = 0;
        }
        if (FlxG.keys.justPressed.S){
            trace("DAD HUE: "+dad.hue);
            trace("DAD BRIGHTNESS: "+dad.brightness);
            trace("DAD SATURATION: "+dad.saturation);
        }

        if (FlxG.keys.justPressed.R){
            bf.brightness = 0;
            bf.hue = 0;
            bf.saturation = 0;
        }
        if (FlxG.keys.justPressed.S){
            trace("BF HUE: "+bf.hue);
            trace("BF BRIGHTNESS: "+bf.brightness);
            trace("BF SATURATION: "+bf.saturation);
        }

        if (FlxG.keys.justPressed.ONE){
            aidi = 0;
        }
        if (FlxG.keys.justPressed.TWO){
            aidi = 1;
        }
        if (FlxG.keys.justPressed.THREE){
            aidi = 2;
        }

        if (FlxG.keys.pressed.RIGHT)
            changeas(aidi,elapsed*0.1);
        if (FlxG.keys.pressed.LEFT)
            changeas(aidi,-elapsed*0.1);
        
        if (FlxG.keys.pressed.D)
            changeasbf(aidi,elapsed*0.1);
        if (FlxG.keys.pressed.A)
            changeasbf(aidi,-elapsed*0.1);

        if (controls.BACK){
            MusicBeatState.switchState(new Funk4DeadMainMenu());
        }
    }

    function changeas(oidi:Int = 0, assus:Float){
        switch(oidi){
            case 0:
                dad.hue += assus;
                trace(dad.hue+ ", " + oidi);
            case 1:
                if (assus < 0)
                    dad.brightness -= 1/100;
                if (assus > 0)
                    dad.brightness += 1/100;
                trace(dad.brightness+ ", " + oidi);
            case 2:  
                if (assus < 0)
                    dad.saturation -= 1/100; 
                if (assus > 0)
                    dad.saturation += 1/100; 
                trace(dad.saturation + ", " + oidi);
        }
    }

    function changeasbf(oidi:Int = 0, assus:Float){
        switch(oidi){
            case 0:
                bf.hue += assus;
                trace(bf.hue+ ", " + oidi);
            case 1:
                if (assus < 0)
                    bf.brightness -= 1/100;
                if (assus > 0)
                    bf.brightness += 1/100;
                trace(bf.brightness+ ", " + oidi);
            case 2:  
                if (assus < 0)
                    bf.saturation -= 1/100; 
                if (assus > 0)
                    bf.saturation += 1/100; 
                trace(bf.saturation + ", " + oidi);
        }
    }
}