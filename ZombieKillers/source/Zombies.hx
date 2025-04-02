import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
class Zombies extends FlxSprite{
   public var zombieType:String = "clown";
   public function new(X, Y, type:String = "clown") {
      super(X, Y);
      zombieType = type;

      if (type == "clown" || type == "staff")
      frames = FlxAtlasFrames.fromSparrow(AssetPaths.zombieBG__png, AssetPaths.zombieBG__xml);
      else
      frames = FlxAtlasFrames.fromSparrow(AssetPaths.zombieHeads__png, AssetPaths.zombieHeads__xml);

      animation.addByPrefix("dance", type+"Idle", 24, true);
      animation.addByPrefix("shoot", type+"Dead", 24,false);
      animation.addByPrefix("appear", type+"Appear",24,false);
      animation.play("dance");
   }

   var diying:Bool = false;
   override function update(elapsed:Float){
       super.update(elapsed);
       if(animation.curAnim != null)if(animation.curAnim.finished && animation.curAnim.name == "appear") animation.play("dance");

       if (diying){
           killTimer -= elapsed;

       if (killTimer <= 0){
           diying = false;
           trace("restart");
           animation.play("appear");
        }
       }
   }

   var killTimer:Float = 2000000; //huh
   public function killZombie(){
        killTimer = 1.7;
        animation.play("shoot");
        diying= true;
    }
}