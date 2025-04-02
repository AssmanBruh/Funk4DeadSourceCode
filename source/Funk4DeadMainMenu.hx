import shaders.SaturationShader;
#if desktop
import Discord.DiscordClient;
#end
// -..........
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.input.mouse.FlxMouseEvent;
import flixel.addons.transition.FlxTransitionableState;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import filters.Grain;
import openfl.Lib;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import menus.nickname.NickNameState;
import flixel.tweens.FlxTween;

class Funk4DeadMainMenu extends MusicBeatState{

    var menuList = ["play", "survivors", "mutation", "options"];
    var menuGrp:FlxTypedGroup<FlxSprite>;
    public static var curSelected:Int = 0;
    var selectedSomethin:Bool = false;
    public var menucursor:FlxSprite;
    var debugKeys:Array<FlxKey>;

    var newDisplacement:Bool = false;

    var bg:FlxSprite;
    var fg:FlxSprite;
    var zoombie:FlxSprite;
    var bgShader:SaturationShader;
    var positions:Array<Float> = [];
    public static var instance:Funk4DeadMainMenu;
    override function create(){
        super.create();

        instance = this;

        menuData();

        bgShader = new SaturationShader();

        // BACKGROUND HERE
        bg = new FlxSprite();
        bg.loadGraphic(Paths.image("menu/bgMenu", "f4d"));
        bg.screenCenter();
        bg.antialiasing = ClientPrefs.globalAntialiasing;
        add(bg);

        fg = new FlxSprite();
        fg.loadGraphic(Paths.image("menu/fg", "f4d"));
        fg.screenCenter();
        fg.antialiasing = ClientPrefs.globalAntialiasing;
        add(fg);

        bg.shader = bgShader.Shader;
        fg.shader = bgShader.Shader;

        menuGrp = new FlxTypedGroup<FlxSprite>();
        add(menuGrp);
        positions = [];
        for (i in 0...menuList.length){
             var menu = new FlxSprite(130.2, 74.25);
             menu.frames = Paths.getSparrowAtlas("menu/menuButtons", "f4d");
             menu.animation.addByPrefix("selected", menuList[i] + " sel", 24, true);
             menu.animation.addByPrefix("unselected", menuList[i] + " unsel", 24, true);
             menu.animation.play("unselected");
             menu.antialiasing = ClientPrefs.globalAntialiasing;
             menu.ID = i;
             menu.x += (110.75+menu.width)*i;
             menu.origin.x += menu.width / 2;
             menu.origin.y += menu.height / 2;
             positions.push(menu.x);
             menuGrp.add(menu);
             FlxMouseEvent.add(menu, 
                function(object:FlxSprite/*mousedown*/){
                    if(!selectedSomethin){
                        // if(object==gfDance){
                        //     var anims = ["singUP","singLEFT","singRIGHT","singDOWN"];
                        //     var sounds = ["GF_1","GF_2","GF_3","GF_4"];
                        //     var anim = FlxG.random.int(0,3);
                        //     gfDance.holdTimer=0;
                        //     gfDance.playAnim(anims[anim]);
                        //     FlxG.sound.play(Paths.sound(sounds[anim]));
                        // }else{
                            for(obj in menuGrp.members){
                                if(obj==object){
                                    accept();
                                    break;
                                }
                            }
                        // }
                    }
                },
                function(object:FlxSprite/**onUp**/){

                },
                function(object:FlxSprite/**onmouseover**/){
                    if(!selectedSomethin){
                        for(idx in 0...menuGrp.members.length){
                            var obj = menuGrp.members[idx];
                            if(obj==object){
                                if(idx!=curSelected){
                                    FlxG.sound.play(Paths.sound('scrollMenu'));
                                    if (newDisplacement){
                                    onHover(object);
                                    }
                                    changeItem(idx,true);
                                }
                            }
                        }
                    }
                },
                function(object:FlxSprite/**onmouseout**/){
                });
        }

        menucursor = new FlxSprite(0,0,Paths.image("f4dCursor", "f4d"));
		menucursor.loadGraphic(Paths.image("f4dCursor", "f4d"));
		menucursor.antialiasing = ClientPrefs.globalAntialiasing;
		menucursor.screenCenter();
		FlxG.mouse.visible = true;
        changeItem(0,false);

        zoombie = new FlxSprite(355.3, 348.65).makeGraphic(65, 145,0xFFFF0000);
        add(zoombie);
    }

    var randomAngle = -3;
    var shitcounter:Int = 0;
    var sine:Float=0;
    override function update(elapsed:Float){
        super.update(elapsed);

        FlxG.camera.scroll.x = FlxG.mouse.x * 0.011;
        FlxG.camera.scroll.y = FlxG.mouse.y * 0.011;

        sine += elapsed;

        // X: 674.7, Y:-894.4
        var x = Math.sin(675*sine)+2.3;
        var y = Math.sin(-894*sine)+2.3;
        zoombie.x = x;
        zoombie.y = y;

        bgShader.update(elapsed);
        bgShader.saturation -= Math.sin(sine*0.55)*Conductor.stepCrochet*0.05;
        // bgShader.saturation = FlxMath.wrap(bgShader-Math.sin(sine*1.1)*Conductor.stepCrochet*0.005, 0, 1);
        if (bgShader.saturation > 1)
            bgShader.saturation = 1;
        else if (bgShader.saturation < 0)
            bgShader.saturation = 0;
        
        // FlxG.mouse.load(FlxGraphic.fromBitmapData(Paths.image("f4dCursor", "f4d")));
        FlxG.mouse.load(menucursor.pixels, 1);

        if (Main.AssmanDebug)
        {
            if (FlxG.keys.justPressed.EIGHT){
                FlxG.switchState(new pixelforce.Map());
            }

            if (FlxG.keys.justPressed.ONE){
                FlxG.switchState(new editors.CharacterColorTest());
            }

            if (FlxG.keys.justPressed.THREE){
                openSubState(new NickNameState());
            }

        }

        if (controls.UI_LEFT_P){
            changeItem(-1);
        }
        if (controls.UI_RIGHT_P){
            changeItem(1);
        }if (controls.ACCEPT){
            accept();
        }
        // shitcounter = 0;
        // if (controls.UI_RIGHT){
        //     shitcounter+= Std.int(Math.pow(Math.pow(2,2),2));
        //     if (shitcounter % 256 == 0){
        //         shitcounter = 0;
        //         changeItem(1);
        //     }
        // }
        // if (controls.UI_LEFT){
        //     shitcounter+=Std.int(Math.pow(Math.pow(2,2),2));
        //     if (shitcounter % 256 == 0){
        //         shitcounter = 0;
        //        changeItem(-1);
        //     }
        // }

        // trace(shitcounter);

        menuGrp.forEach(function(spr:FlxSprite)
        {
            var lerpvalue:Float = CoolUtil.boundTo(elapsed * 9.2, 0, 1);
            if (spr.ID == curSelected){
                var mult = FlxMath.lerp(spr.scale.x, 1.18, lerpvalue);
                var multAngle = FlxMath.lerp(spr.angle, randomAngle, lerpvalue);
                spr.scale.set(mult,mult);
                spr.angle = multAngle;
                // spr.updateHitbox();
            }else{
                var mult = FlxMath.lerp(spr.scale.x, 1, lerpvalue);
                var multAngle = FlxMath.lerp(spr.angle, 0, lerpvalue);
                spr.scale.set(mult,mult);
                spr.angle = multAngle;
                // spr.updateHitbox();    
            }
        });
    }

    public function accept() {
        switch (menuList[curSelected]){
            case "play":
                AssmanTransition.transitionTo(new StoryMenuState());
            case "survivors":
                AssmanTransition.transitionTo(new CreditsState());
            case "mutation":
                AssmanTransition.transitionTo(new FreeplayState());  
            case "options":
                LoadingState.loadAndSwitchState(new options.OptionsState());
        }
    }

	function changeItem(huh:Int = 0,force:Bool=false)
	{
		if(force){
			curSelected=huh;
		}else{
			// curSelected += huh;
            curSelected = FlxMath.wrap(curSelected+huh, 0, menuList.length-1);
		}

        if (newDisplacement){
        rotateMenu(huh!=1);
        }

        for (item in menuGrp.members){
             item.animation.play("unselected");
             if (item.ID == curSelected){
                 randomAngle = FlxG.random.int(-3, 3, [-2, -1, 0, 1, 2]);
                 item.animation.play("selected");
             }
        }
	}

    function rotateMenu(toRight:Bool) {
        if (toRight) {
            var last = menuGrp.members.pop();
            menuGrp.members.insert(0, last);
        } else {
            var first = menuGrp.members.shift();
            menuGrp.members.push(first);
        }

        for (i in 0...menuGrp.members.length) {
            FlxTween.tween(menuGrp.members[i], {x: positions[i]}, 0.3, {ease: flixel.tweens.FlxEase.expoOut});
            // menuItems[i].color = (i == 0) ? FlxColor.YELLOW : FlxColor.WHITE;if (i == 0){
            if (i == 0){
                menuGrp.members[i].animation.play("selected"); 
            }else{
                menuGrp.members[i].animation.play("unselected");
            }
        }
    }

    function onHover(item:FlxSprite) {
        var hoveredIndex = menuGrp.members.indexOf(item);

        while (hoveredIndex > 0) {
            rotateMenu(false);
            hoveredIndex--;
        }
    }

    public function menuData() {
        #if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Into Funk 4 Dead Menu", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		persistentUpdate = persistentDraw = true;
    }
}