package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.FlxBasic;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileCircle;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileSquare;
import flixel.addons.transition.TransitionData;
import filters.Grain;
import openfl.Lib;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
class MusicBeatState extends FlxUIState
{
	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	private var controls(get, never):Controls;

	public static var camBeat:FlxCamera;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

    var shader = new Grain();
    var filters:Array<BitmapFilter> = []; 

	override function create() {
		camBeat = FlxG.camera;
		// var skip:Bool = FlxTransitionableState.skipNextTransOut;
		// super.create();

		// if(!skip) {
		// 	openSubState(new CustomFadeTransition(0.7, true));
		// }
		
		// FlxTransitionableState.skipNextTransOut = false;
		shader = new Grain();
        var filter = new ShaderFilter(shader);
        filters.push(filter);
        FlxG.camera.filters = filters;
		FlxG.game.setFilters(filters);
		//  ------------ TRANSITION ----------------
		var cam = FlxG.camera;

        // Inicia con zoom alto y pantalla negra
        cam.zoom = 2;
        cam.fade(0xFF000000, 0, false);

        // Fade Out + Zoom Out en el nuevo estado
        new FlxTimer().start(0.1, function(_) {
            cam.fade(0xFF000000, 0.5, true);

            // Animación de Zoom Out
            new FlxTimer().start(0.01, function(timer) {
                if (cam.zoom > 1) {
                    cam.zoom -= 0.05;
                    timer.reset(0.01);
                }
            });
        });
		// ------------------ END -------------------------
	}

	override function update(elapsed:Float)
	{
		// GRAIN UPDATE FUNCTION
		
        if (shader != null){
            #if (openfl >= "8.0.0")
            shader.uTime.value = [Lib.getTimer() / 1000];
            #else
            shader.uTime = Lib.getTimer() / 1000;
            #end
        }

	    // END
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
		{
			if(curStep > 0)
				stepHit();

			if(PlayState.SONG != null)
			{
				if (oldStep < curStep)
					updateSection();
				else
					rollbackSection();
			}
		}

		if(FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;

		super.update(elapsed);
	}

	private function updateSection():Void
	{
		if(stepsToDo < 1) stepsToDo = Math.round(getBeatsOnSection() * 4);
		while(curStep >= stepsToDo)
		{
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
	}

	private function rollbackSection():Void
	{
		if(curStep < 0) return;

		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length)
		{
			if (PlayState.SONG.notes[i] != null)
			{
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if(stepsToDo > curStep) break;
				
				curSection++;
			}
		}

		if(curSection > lastSection) sectionHit();
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	public static function switchState(nextState:FlxState) {
		AssmanTransition.transitionTo(nextState);
	}

	public static function resetState() {
		MusicBeatState.switchState(FlxG.state);
	}

	public static function getState():MusicBeatState {
		var curState:Dynamic = FlxG.state;
		var leState:MusicBeatState = curState;
		return leState;
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//trace('Beat: ' + curBeat);
	}

	public function sectionHit():Void
	{
		//trace('Section: ' + curSection + ', Beat: ' + curBeat + ', Step: ' + curStep);
	}

	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if(PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}
	static var initialized:Bool = false;
	// ----------- TRANSITION ---------
	function initTransData(){
		if (!initialized)
		{
			initialized = true;
			FlxTransitionableState.defaultTransIn = new TransitionData();
			FlxTransitionableState.defaultTransOut = new TransitionData();
			
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;
			
			FlxTransitionableState.defaultTransIn.tileData = {asset: diamond, width: 32, height: 32};
			FlxTransitionableState.defaultTransOut.tileData = {asset: diamond, width: 32, height: 32};
			
			// // Of course, this state has already been constructed, so we need to set a transOut value for it right now:
			transOut = FlxTransitionableState.defaultTransOut;
		}
		FlxTransitionableState.defaultTransIn.color = FlxColor.fromString("#0000000");
		FlxTransitionableState.defaultTransIn.type = TILES;
		setDirectionFromStr("e", FlxTransitionableState.defaultTransIn.direction);
		FlxTransitionableState.defaultTransIn.duration = 0.3;
		FlxTransitionableState.defaultTransIn.tileData.asset = getDefaultAsset("square");
		
		FlxTransitionableState.defaultTransOut.color = FlxColor.fromString("#000000");
		FlxTransitionableState.defaultTransOut.type = TILES;
		setDirectionFromStr("w", FlxTransitionableState.defaultTransOut.direction);
		FlxTransitionableState.defaultTransOut.duration = 0.6;
		FlxTransitionableState.defaultTransOut.tileData.asset = getDefaultAsset("square");
		
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
    }

    // ASSET
    function getDefaultAssetStr(c:FlxGraphic):String
    {
        return switch (c.assetsClass)
        {
            case GraphicTransTileCircle: "circle";
            case GraphicTransTileSquare: "square";
            case GraphicTransTileDiamond, _: "diamond";
        }
    }
    
    function getDefaultAsset(str):FlxGraphic
    {
        var graphicClass:Class<Dynamic> = switch (str)
        {
            case "circle": GraphicTransTileCircle;
            case "square": GraphicTransTileSquare;
            case "diamond", _: GraphicTransTileDiamond;
        }
        
        var graphic = FlxGraphic.fromClass(cast graphicClass);
        graphic.persist = true;
        graphic.destroyOnNoUse = false;
        return graphic;
    }

    // DIRECTION

    function getDirection(ix:Int, iy:Int):String
    {
        if (ix < 0)
        {
            if (iy == 0)
                return "w";
            if (iy > 0)
                return "sw";
            if (iy < 0)
                return "nw";
        }
        else if (ix > 0)
        {
            if (iy == 0)
                return "e";
            if (iy > 0)
                return "se";
            if (iy < 0)
                return "ne";
        }
        else if (ix == 0)
        {
            if (iy > 0)
                return "s";
            if (iy < 0)
                return "n";
        }
        return "center";
    }
    
    function setDirectionFromStr(str:String, ?p:FlxPoint):FlxPoint
    {
        if (p == null)
            p = new FlxPoint();
            
        switch (str)
        {
            case "n":
                p.set(0, -1);
            case "s":
                p.set(0, 1);
            case "w":
                p.set(-1, 0);
            case "e":
                p.set(1, 0);
            case "nw":
                p.set(-1, -1);
            case "ne":
                p.set(1, -1);
            case "sw":
                p.set(-1, 1);
            case "se":
                p.set(1, 1);
            default:
                p.set(0, 0);
        }
        return p;
    }  
}
