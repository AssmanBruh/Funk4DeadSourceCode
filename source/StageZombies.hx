import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

/**
    for singer killer!
**/
class StageZombies extends FlxSprite{
   public var zombieType:String = "clown";
   public function new(X, Y, type:String = "clown") {
      super(X, Y);
      zombieType = type;

      if (type == "clown" || type == "staff")
      frames = Paths.getSparrowAtlas("stages/carnival/zombieBG", "f4d");
      else
      frames = Paths.getSparrowAtlas("stages/carnival/zombieHeads","f4d");

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
       
       if (animation.curAnim != null){
           switch (animation.curAnim.name){
                  case "dance":
                       switch (zombieType){
                           case "clown":
                           case "staff":
                           case "shitOne": 
                           case "shitTwo":
                           case "shitThree":  
                       }
                  case "appear":
                    switch (zombieType){
                        case "clown":
                        case "staff":
                        case "shitOne": 
                        case "shitTwo":
                        case "shitThree":  
                    }
                  case "shoot":    
                    switch (zombieType){
                        case "clown":
                        case "staff":
                        case "shitOne": 
                        case "shitTwo":
                        case "shitThree":  
                    }
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