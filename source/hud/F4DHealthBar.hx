package hud;

import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class F4DHealthBar extends FlxSpriteGroup{
    
    public var pla:PLAYERS = PLAYER;
    
    /**
        ---- VALUES ----
    **/
    /**
        0 opp 1 player
    **/
    public var xPosition = [39.1, 879.85];
    public var yPosition = 552.55;

    /**
        the adders sector width positions
    **/
    public var xBar = 102.95;

    
    /**
        the adders sector height positions
    **/
    public var yBar = 70.4;

   /**
    the fake sec width 
   **/
    public var secWidth=305.0;
    
   /**
    the fake sec height
   **/
    public var secHeight=150.1;

    /**
        player name X adders
    **/
    public var nameX = 15.35;
    
    /**
        player name Y adders
    **/
    public var nameY = 108.15;

    /**  scale value  **/
    public var nameScale = 40;

    /** health txt value X  adder **/
    public var healthTxtX = 127.45;
    /** health txt value Y adder **/
    public var healthTxtY = 25.85;
    /** heaelth txt scale **/
    public var healthTxtScale = 40;

    /** fakeHealth FOR TEXTS **/
    public var healthValue:Int = 100;

    /** health FOR HP BAR **/
    public var dahealth = 2.0;

    /**
        *lemme explain it

        - 5 to ELLIS
        - 4 to BF
        - 3 to efafeaf
    **/
    public var character:Int = 0;

    /** character name value **/
    public var characterName:String = "Xx_455M4N_FNFPRO_player777_LoveMyMOM_perupecausitaleforde_xX";
    // public var characterName:String = "The_Ultimate_Overpowered_Legendary_Godlike_Super_Saiyan_MegaDestroyer_9999_XxShadowPhantomReaperXx_UnstoppableDoomBringer_MasterOfTheMultiverse";
    /**END VALUES**/

    /** sector Portrait obj**/
    public var sectorPortrait:FlxSprite;
    /** bar obj **/
    public var healthBar:FlxBar;
    /** fake bar **/
    public var fakeBar:FlxSprite;
    /** name text **/
    public var nameTxt:FlxText;
    /** health text **/
    public var healthTxt:FlxText;
    /** bar type: INFECTED, SURVIVOR, DOWNED **/
    public var charSpecie:BarType;
    
    public function new(pla:PLAYERS=PLAYER, character:Int = 4, characterName:String="Carlos", charSpecie:BarType){
        super();
        this.pla = pla;
        this.character = character;
        this.characterName = characterName;
        this.charSpecie = charSpecie;
        trace("hola si funciono");

        fakeBar = new FlxSprite(posX(xBar), posY(yBar), Paths.image("UI/survEmptyBar", "f4d"));
        fakeBar.updateHitbox();
        fakeBar.antialiasing = ClientPrefs.globalAntialiasing;
        add(fakeBar);

        healthBar = new FlxBar(fakeBar.x, fakeBar.y, LEFT_TO_RIGHT, Std.int(fakeBar.width), Std.int(fakeBar.height), 
        this, "dahealth", 0, 2);
        healthBar.updateBar();
        healthBar.createImageFilledBar(Paths.image("UI/survFilledBar", "f4d"), FlxColor.TRANSPARENT);
        healthBar.createImageEmptyBar(Paths.image("UI/survEmptyBar", "f4d"), FlxColor.TRANSPARENT);
        healthBar.antialiasing = ClientPrefs.globalAntialiasing;
        add(healthBar);
        
        sectorPortrait = new FlxSprite(xPosition[calcPlayer(pla)], yPosition);
        sectorPortrait.frames = Paths.getSparrowAtlas("UI/portraitSector", "f4d");
        sectorPortrait.animation.addByPrefix("survivor", "portrait", 0, false);
        sectorPortrait.animation.play("survivor");
        if (sectorPortrait.animation.curAnim != null){
            sectorPortrait.animation.curAnim.curFrame = character;
        }

        sectorPortrait.antialiasing = ClientPrefs.globalAntialiasing;
        sectorPortrait.updateHitbox();
        secWidth = sectorPortrait.width;
        secHeight = sectorPortrait.height;
        add(sectorPortrait);

        healthTxt = new FlxText(posX(healthTxtX), posY(healthTxtY),0, "+ 100", healthTxtScale);
        healthTxt.setFormat(Paths.font("tw-cen-mt-condensed-extrabold.ttf"), healthTxtScale, 0xFF54E008, LEFT, OUTLINE, 0xFFFFFFFF);
        healthTxt.text = "+ "+healthValue;
        add(healthTxt);

        var formattedText = wrapText(characterName, 18);
        nameTxt = new FlxText(posX(nameX), posY(nameY),290, formattedText);
        nameTxt.setFormat(Paths.font("tw-cen-mt-condensed-extrabold.ttf"), nameScale, 0xFFFFFFFF, LEFT);
        nameTxt.text = characterName;
        nameTxt.wordWrap = true;
        nameTxt.fieldWidth = 290;

        // Ajustar tamaño de fuente si el texto es muy alto
        while (nameTxt.height > 55 && nameTxt.size > 10) {
            nameTxt.size -= 1;
            nameTxt.height -= 1;
        }
        add(nameTxt);
    }

    function wrapText(text:String, maxChars:Int):String {
        var result:String = "";
        var i:Int = 0;

        while (i < text.length) {
            if (i > 0) {
                result += "\n";
            }
            result += text.substr(i, maxChars);
            i += maxChars;
        }

        return result;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (dahealth > 2)
            dahealth = 2;

        healthValue = Math.round(dahealth * 50);
        nameTxt.text = characterName;
        healthTxt.text = "+ "+healthValue;

        var healthass = dahealth*50;
        flixel.math.FlxMath.lerp(healthBar.percent, healthass, CoolUtil.boundTo(elapsed*12,0,1));
    }

    public function calcPlayer(plaier:PLAYERS){
        switch (plaier){
            case OPPONENT:
                return 0;
            case PLAYER:
                return 1;
        }
    }

    /** true to Y false to X**/
    public function posX(posi:Float){
           return xPosition[calcPlayer(pla)]+posi;
    }
    public function posY(posi:Float){
        return yPosition+posi;
    }
}

enum PLAYERS {
    OPPONENT;
    PLAYER;
}

enum BarType{
    INFECTED;
    SURVIVOR;
    DOWNED;
}