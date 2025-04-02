package editors;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.math.FlxMath;
import lime.system.Clipboard;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;

using StringTools;

/**
    @author: assmanbruh
    just a simple stage editor :v
**/
class StageEditor extends MusicBeatState{

    ////---- STAGE VARIABLES ----////
        // carnival stage
        var wall:FlxSprite;
        var floor:FlxSprite;
        var coach:FlxSprite;
        var nick:FlxSprite;
        var rochelle:FlxSprite;
        var lights:FlxSprite;
        var shade:FlxSprite;
        var shadow:FlxSprite;
        var carnivalZombies:Array<StageZombies>;
        var clown:StageZombies;
        var staff:StageZombies;
        var common1:StageZombies;
        var common2:StageZombies;
        var common3:StageZombies;
    // vannah stage
        var coachDancer:FlxSprite;
        var vannah_bg:FlxSprite;
    ////---- END VARIABLES ----////


    var stage:String = "carnival";
    var opp:Character;
    var player:Boyfriend;
    var gf:Character;
    var oppName:String = "ellis";
    var playerName="bf";
    var gfName="gf";
    
    var camFollow:FlxObject;
	var camFollowPos:FlxObject;

    var leText:FlxText;

    var oppPos = [0.0,0.0];
    var playerPos = [0.0,0.0];
    var gfPos = [0.0,0.0];

    var stageObjLength:Array<FlxSprite> = [];

    public function new(stage="carnival", oppName:String="ellis",playerName:String="bf",gfName:String=""){
        super();
        this.stage = stage;
        this.oppName = oppName;
        this.playerName = playerName;
        this.gfName = gfName;
    }

    override function create(){

        FlxG.sound.music.stop();
        FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
        
		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos); 

        switch (stage){
            case "carnival":
                stageObjLength = [];
				carnivalZombies = [];
                FlxG.camera.zoom = 0.8;
                playerCameraOffset = [-30, -45];
                opponentCameraOffset = [-25, -24];
				wall = new FlxSprite(0,0);
				wall.loadGraphic(Paths.image("stages/carnival/wallBG", "f4d"));
                wall.setPosition(-1617.05, -961.9);
				wall.updateHitbox();
				wall.antialiasing = ClientPrefs.globalAntialiasing;
				add(wall);
                stageObjLength.push(wall);

				floor = new FlxSprite(0,0);
				floor.loadGraphic(Paths.image("stages/carnival/floorBG", "f4d"));
				floor.setPosition(-930.1, -241.6);
				floor.updateHitbox();
				floor.antialiasing = ClientPrefs.globalAntialiasing;
				add(floor);
				stageObjLength.push(floor);

				nick = new FlxSprite(0,0);
				nick.frames = Paths.getSparrowAtlas("stages/carnival/nickBG", "f4d");
				nick.animation.addByPrefix("dance", "nick dance", 24, false);
				nick.setPosition(-348.25, 145.5);
				nick.antialiasing = ClientPrefs.globalAntialiasing;
				nick.updateHitbox();
				add(nick);
				stageObjLength.push(nick);

				rochelle = new FlxSprite(0,0);
				rochelle.frames = Paths.getSparrowAtlas("stages/carnival/rochelleBG", "f4d");
				rochelle.animation.addByPrefix("dance", "rochelle dance", 24, false);
				rochelle.animation.addByPrefix("shoot", "rochelle shoot", 24, false);
				rochelle.setPosition(360.75, 161.7);
				rochelle.antialiasing = ClientPrefs.globalAntialiasing;
				rochelle.updateHitbox();
				add(rochelle);
				stageObjLength.push(rochelle);

				coach = new FlxSprite(0,0);
				coach.frames = Paths.getSparrowAtlas("stages/carnival/coachBG", "f4d");
				coach.animation.addByPrefix("dance", "coach dance", 24, false);
				coach.setPosition(593.65, 128.35);
				coach.antialiasing = ClientPrefs.globalAntialiasing;
				coach.updateHitbox();
				add(coach);
				stageObjLength.push(coach);
				
				// zombies
				clown = new StageZombies(0, 0,"clown");
				add(clown);
				stageObjLength.push(clown);
		
				staff = new StageZombies(800, 60,"staff");
				add(staff);
				stageObjLength.push(staff);
				
				common1 = new StageZombies(20, 340,"shitOne");
				common2 = new StageZombies(200, 340,"shitTwo");
				common3 = new StageZombies(700, 340,"shitThree");

				carnivalZombies.push(clown);
				carnivalZombies.push(staff);
				carnivalZombies.push(common1);
				carnivalZombies.push(common2);
				carnivalZombies.push(common3);
				
			    lights = new FlxSprite(450, 210, Paths.image("stages/carnival/lights", "f4d"));
				lights.antialiasing = ClientPrefs.globalAntialiasing;
				lights.updateHitbox();
                lights.setPosition(-982,-301);
				shade = new FlxSprite(0,0);
				shade.loadGraphic(Paths.image("stages/carnival/shadeEffect", "f4d"));
				shade.setPosition(-1655.5, -1007.5);
                shade.scrollFactor.set();
				shade.antialiasing = ClientPrefs.globalAntialiasing;
				shade.updateHitbox();
				shade.blend = ADD;

				shadow = new FlxSprite(0,0);
				shadow.loadGraphic(Paths.image("stages/carnival/blackShadeBG", "f4d"));
				shadow.setPosition(-1638.5, -810.5);
				shadow.antialiasing = ClientPrefs.globalAntialiasing;
				shadow.scale.set(0.7,.7);
				shadow.updateHitbox();
                shadow.scrollFactor.set();

                wall.setPosition(-1617.05, -961.9);

                floor.setPosition(-930.1,-241.6);
    
                coach.setPosition(604.65,126.35);
    
                nick.setPosition(-348.25,145.5);
    
                rochelle.setPosition(355.75,161.7);
    
                lights.setPosition(-982,-301);
    
                shade.setPosition(-1735.5,-967.5);
    
                shade.scale.set(1, 1);
    
                shadow.setPosition(-1037.5,-515.5);
    
                shadow.scale.set(0.87, 0.87);
    
                clown.setPosition(-538,200);
    
                staff.setPosition(1060,220);
    
                common1.setPosition(-320,600);
    
                common2.setPosition(170,584);
    
                common3.setPosition(900,580);
    
				// zoomin = 1.24;
				// zoomout = 0.71; 

                playerPos = [631, 385.2];
                oppPos = [-145.5, 162.2];   
			case "vannah": 
                stageObjLength = [];
                FlxG.camera.zoom = 0.45;
				GameOverSubstate.characterName = 'hunter-dead';
				vannah_bg = new FlxSprite(-1924.05, -289.9);
				vannah_bg.loadGraphic(Paths.image("stages/vannah/l4d_el_bg_xd", "f4d"));
                vannah_bg.stageObjName = "VANNAH_BG";
				vannah_bg.antialiasing = ClientPrefs.globalAntialiasing;
				vannah_bg.updateHitbox();
				add(vannah_bg);
				stageObjLength.push(vannah_bg);

				var yCoach = 620;
				coachDancer = new FlxSprite(0,yCoach);
				coachDancer.loadGraphic(Paths.image("stages/vannah/coach", "f4d"));
				coachDancer.screenCenter(X);
                coachDancer.stageObjName = "COACH_DANCER";
				coachDancer.dyn.update = function(elapsed:Float){
					// back to y def babe!!
					var yass = FlxMath.lerp(coachDancer.y, yCoach, CoolUtil.boundTo(elapsed*12, 0, 1));
					coachDancer.y = yass;
				}
				add(coachDancer);
				stageObjLength.push(coachDancer);

				// zoomin: 0.57;
				// zoomout: 0.4; 

                oppPos = [-480.5, 88.8];
                playerPos = [967, 160.2];
                gfPos = [590, 121.2];
         }

         FlxG.camera.follow(camFollowPos, null, 1);

         if (gfName != ""){
            gf = new Character(gfPos[0], gfPos[1],gfName);
            add(gf);
         }

         opp = new Character(oppPos[0], oppPos[1],oppName);
         add(opp);
         player = new Boyfriend(playerPos[0], playerPos[1],playerName);
         add(player);
         

         switch (stage){
            case "carnival":
                add(common1);
                add(common3);
                add(common2);
                add(lights);
                add(shadow);
                add(shade);
                stageObjLength.push(common1);
                stageObjLength.push(common3);
                stageObjLength.push(common2);
                stageObjLength.push(lights);
                stageObjLength.push(shadow);
                stageObjLength.push(shade);
         }
         pointTo(0);

         leText = new FlxText(20,20,0,textos,50);
         leText.borderStyle = OUTLINE;
         leText.borderColor = 0xFF000000;
         leText.scrollFactor.set();
         leText.borderSize = 2.23;
         add(leText);
    }

    var aidi:Int = 0;
    override function update(elapsed:Float){
        super.update(elapsed);

        var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);      
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

        var left = FlxG.keys.justPressed.LEFT;
        var left_P = FlxG.keys.pressed.LEFT;
        var right = FlxG.keys.justPressed.RIGHT;
        var right_P = FlxG.keys.pressed.RIGHT;
        var up = FlxG.keys.justPressed.UP;
        var up_P = FlxG.keys.pressed.UP;
        var down = FlxG.keys.justPressed.DOWN;
        var down_P = FlxG.keys.pressed.DOWN;
    
        var camleft = FlxG.keys.pressed.J;
        var camright = FlxG.keys.pressed.L;
        var camup = FlxG.keys.pressed.I;
        var camdown = FlxG.keys.pressed.K;
        // var left = FlxG.keys.justPressed.LEFT;
        var shiftass = (FlxG.keys.pressed.SHIFT ? 20 : 1);

        if (FlxG.keys.justPressed.ONE){
            aidi = 0;//dad
            pointTo(0);
        }
        if (FlxG.keys.justPressed.TWO){
            aidi = 1;//bf
            pointTo(1);
        }
        if (FlxG.keys.justPressed.THREE){
            aidi = 2;//gf
            pointTo(2);
        }
        switch (stage){
           case "carnival":
            if (FlxG.keys.justPressed.FOUR)
                aidi = 3;
            if (FlxG.keys.justPressed.FIVE)
                aidi = 4;
            if (FlxG.keys.justPressed.SIX)
                aidi = 5;
            if (FlxG.keys.justPressed.SEVEN)
                aidi = 6;
            if (FlxG.keys.justPressed.EIGHT)
                aidi = 7;
            if (FlxG.keys.justPressed.NINE)
                aidi = 8;
            if (FlxG.keys.justPressed.Q)
                aidi = 9;
            if (FlxG.keys.justPressed.W)
                aidi = 10;
            if (FlxG.keys.justPressed.E)
                aidi = 11;
            if (FlxG.keys.justPressed.R)
                aidi = 12;
            if (FlxG.keys.justPressed.T)
                aidi = 13;
            if (FlxG.keys.justPressed.Y)
                aidi = 14;
            if (FlxG.keys.justPressed.U)
                aidi = 15;
            if (FlxG.keys.justPressed.Z)
                aidi = 16;
           case "special-rivals":
            if (FlxG.keys.justPressed.FOUR)
                aidi = 3;
            if (FlxG.keys.justPressed.FIVE)
                aidi = 4;
        }
    
            if (camleft){
                camFollow.x -= 1;
            }
            if (camright){
                camFollow.x += 1;
            }
            if (camup){
                camFollow.y -= 1;
            }
            if (camdown){
                camFollow.y += 1;
            }
            if (FlxG.keys.pressed.PLUS && FlxG.camera.zoom < 3){
                FlxG.camera.zoom += elapsed * FlxG.camera.zoom;
				if(FlxG.camera.zoom > 3) FlxG.camera.zoom = 3;
			}
			if (FlxG.keys.pressed.MINUS && FlxG.camera.zoom > 0.1) {
				FlxG.camera.zoom -= elapsed * FlxG.camera.zoom;
				if(FlxG.camera.zoom < 0.1) FlxG.camera.zoom = 0.1;
			}
            if (left){
                moveObj(aidi).x -= 1*shiftass;
            }
            if (right){
                moveObj(aidi).x += 1*shiftass;
            }
            if (down){
                moveObj(aidi).y += 1*shiftass;
            }
            if (up){
                moveObj(aidi).y -= 1*shiftass;
            }

            if (FlxG.keys.pressed.SPACE){
                if (FlxG.mouse.wheel != 0){
                    moveObj(aidi).scale.set(-FlxG.mouse.wheel*1, -FlxG.mouse.wheel*1);
                }
            }

        if (FlxG.keys.pressed.CONTROL){
            if (FlxG.keys.justPressed.C){
                var copyshit:String = "NOT STAGE DATA";
                switch(stage){
                case "carnival":
                    copyshit = '
                    wall.setPosition(${wall.x}, ${wall.y});\n
                    floor.setPosition(${floor.x},${floor.y});\n
                    coach.setPosition(${coach.x},${coach.y});\n
                    nick.setPosition(${nick.x},${nick.y});\n
                    rochelle.setPosition(${rochelle.x},${rochelle.y});\n
                    lights.setPosition(${lights.x},${lights.y});\n
                    shade.setPosition(${shade.x},${shade.y});\n
                    shade.scale.set(${shade.scale.x}, ${shade.scale.y});\n
                    shadow.setPosition(${shadow.x},${shadow.y});\n
                    shadow.scale.set(${shadow.scale.x}, ${shadow.scale.y});\n
                    clown.setPosition(${clown.x},${clown.y});\n
                    staff.setPosition(${staff.x},${staff.y});\n
                    common1.setPosition(${common1.x},${common1.y});\n
                    common2.setPosition(${common2.x},${common2.y});\n
                    common3.setPosition(${common3.x},${common3.y});\n\n
        
                    zoom: ${FlxG.camera.zoom}\n
                    camx: ${camFollow.x}\n
                    camy: ${camFollow.y}
                    ';
                }

                // Clipboard.
            }
            if(FlxG.keys.justPressed.S)  {
                save(stage);
            }
        }

        if (controls.BACK){
            MusicBeatState.switchState(new PlayState());
        }
        // for (i in 0...stageObjLength.length){
        //     stageObjLength[i].ID = i;
        //     stageObjLength[i].stageObjSelected = false;
        //     if (stageObjLength[aidi].ID == i)
        //      stageObjLength[aidi].stageObjSelected = true;
        // }
        leText.text = objtext + ": ["+moveObj(aidi).x+", "+moveObj(aidi).y+"]";
    }

    var textos ="assasfas";
    var objtext:String = "assmansonsio";
    function moveObj(IDI:Int=0){
        var leobj:FlxSprite = opp;
        switch(stage){
        case "carnival":
        switch(IDI){
           case 0:
             objtext = opp.curCharacter.toLowerCase();
             leobj = opp;  
           case 1: 
            objtext = player.curCharacter.toLowerCase();
            leobj = player;
           case 2:  
            if (gfName != ""){
                leobj = gf;
                objtext = gf.curCharacter.toLowerCase();
            }
            else{
                leobj = player;
                objtext = player.curCharacter.toLowerCase();
            }
           case 3:  
            objtext = "WALL";
            leobj = wall;
           case 4:  
            objtext = "FLOOR";
            leobj = floor;
           case 5:  
            objtext = "COACH";
             leobj = coach;
           case 6:  
            objtext = "NICK";
            leobj = nick;
           case 7:  
            objtext = "ROCHELLE";
             leobj = rochelle;
           case 8:  
            objtext = "LIGHTS";
             leobj = lights;
           case 9:  
            objtext = "SHADE";
             leobj = shade;
           case 10:  
            objtext = "SHADOW";
             leobj = shadow;
           case 11:  
            objtext = "CLOWN";
             leobj = clown;
           case 12:  
            objtext = "STAFF";
             leobj = staff;
           case 13:  
            objtext = "COMMON-1";
             leobj = common1;
           case 14:
            objtext = "ASSMAN";
            leobj = opp;
           case 15:  
            objtext = "COMMON-2";
             leobj = common2;
           case 16:  
            objtext = "COMMON-3";
             leobj = common3;
        }
        case "vannah":
           switch(IDI) {
           case 0:
             objtext = opp.curCharacter.toLowerCase();
             leobj = opp;  
           case 1: 
             objtext = player.curCharacter.toLowerCase();
             leobj = player;
           case 2:  
            if (gfName != ""){
                leobj = gf;
                objtext = gf.curCharacter.toLowerCase();
            }
            else{
                leobj = player;
                objtext = player.curCharacter.toLowerCase();
            }
           default:
               leobj = stageObjLength[IDI];
               objtext = stageObjLength[IDI].stageObjName;
            }
        }

        leobj.color = flixel.util.FlxColor.LIME;
        return leobj;
    }

    var opponentCameraOffset = [0.0, 0.0];
    var playerCameraOffset = [0.0,0.0];
    var gfCameraOffset = [0.0,0.0];

    function pointTo(id:Int=0){
        switch (id){
            case 0: //dad
            camFollow.setPosition(opp.getMidpoint().x + 150, opp.getMidpoint().y - 100);
			camFollow.x += opp.cameraPosition[0] + opponentCameraOffset[0];
			camFollow.y += opp.cameraPosition[1] + opponentCameraOffset[1];
            case 1://bf
            camFollow.setPosition(player.getMidpoint().x - 100, player.getMidpoint().y - 100);
			camFollow.x -= player.cameraPosition[0] - playerCameraOffset[0];
			camFollow.y += player.cameraPosition[1] + playerCameraOffset[1];
            case 2://gf
            if (gf != null){
            camFollow.setPosition(gf.getMidpoint().x - 100, gf.getMidpoint().y - 100);
			camFollow.x -= gf.cameraPosition[0] - gfCameraOffset[0];
			camFollow.y += gf.cameraPosition[1] + gfCameraOffset[1];
            }
        }
    }

    function save(lesta:String){
        var saveshit:String = "NOT STAGE DATA";
        switch(lesta){
        case "carnival":
         saveshit = '
            wall.setPosition(${wall.x}, ${wall.y});\n
            floor.setPosition(${floor.x},${floor.y});\n
            coach.setPosition(${coach.x},${coach.y});\n
            nick.setPosition(${nick.x},${nick.y});\n
            rochelle.setPosition(${rochelle.x},${rochelle.y});\n
            lights.setPosition(${lights.x},${lights.y});\n
            shade.setPosition(${shade.x},${shade.y});\n
            shade.scale.set(${shade.scale.x}, ${shade.scale.y});\n
            shadow.setPosition(${shadow.x},${shadow.y});\n
            shadow.scale.set(${shadow.scale.x}, ${shadow.scale.y});\n
            clown.setPosition(${clown.x},${clown.y});\n
            staff.setPosition(${staff.x},${staff.y});\n
            common1.setPosition(${common1.x},${common1.y});\n
            common2.setPosition(${common2.x},${common2.y});\n
            common3.setPosition(${common3.x},${common3.y});\n\n

            zoom: ${FlxG.camera.zoom}\n
            camx: ${camFollow.x}\n
            camy: ${camFollow.y}
            ';
        }

        saveStageData(saveshit);
    }
	var _file:FileReference;

    function onSaveComplete(_):Void
        {
            _file.removeEventListener(Event.COMPLETE, onSaveComplete);
            _file.removeEventListener(Event.CANCEL, onSaveCancel);
            _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            _file = null;
            FlxG.log.notice("Successfully saved file.");
        }
    
        /**
            * Called when the save file dialog is cancelled.
            */
        function onSaveCancel(_):Void
        {
            _file.removeEventListener(Event.COMPLETE, onSaveComplete);
            _file.removeEventListener(Event.CANCEL, onSaveCancel);
            _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            _file = null;
        }
    
        /**
            * Called if there is an error while saving the gameplay recording.
            */
        function onSaveError(_):Void
        {
            _file.removeEventListener(Event.COMPLETE, onSaveComplete);
            _file.removeEventListener(Event.CANCEL, onSaveCancel);
            _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            _file = null;
            FlxG.log.error("Problem saving file");
        }
    
        function saveStageData(data:String) {
            _file = new FileReference();
            _file.addEventListener(Event.COMPLETE, onSaveComplete);
            _file.addEventListener(Event.CANCEL, onSaveCancel);
            _file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            _file.save(data, stage + ".txt");
    }

    function ClipboardAdd(prefix:String = ''):String {
        if(prefix.toLowerCase().endsWith('v')) //probably copy paste attempt
        {
            prefix = prefix.substring(0, prefix.length-1);
        }

        var text:String = prefix + Clipboard.text.replace('\n', '');
        return text;
    }
}