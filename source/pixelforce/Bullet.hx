package pixelforce;

import flixel.FlxG;
import pixelforce.Bf.Dirs;
import flixel.FlxSprite;

class Bullet extends FlxSprite{
    public var dir:Bf.Dirs;
    public var bulletSpeed:Int=600;
    public var killers:Array<Zombie> = [];
    public var attach:FlxSprite;
    // the angle add for angle = blahblah on update func
    public var dudeangle:Float = 0.0;
    public function new (attach:FlxSprite, dir:Bf.Dirs){
         super();
         this.attach = attach;
         this.dir = dir;
         killers = [];
         loadGraphic(Paths.image("pixel/bullet", "f4d"));
         setGraphicSize(Std.int(width*CoolUtil.pixelForceZoom));
         updateHitbox();
         antialiasing = false;
        //  init posit
        if (dir != null){
            switch(dir){
                case LEFT:
                    setPosition(attach.x+attach.width/2, (attach.y+attach.height/2)+9);
                case RIGHT:
                    setPosition(attach.x+attach.width/2, (attach.y+attach.height/2)+9);
                case UP:
                    setPosition((attach.x+attach.width/2)+10, (attach.y+attach.height/2));
                case DOWN:
                    setPosition((attach.x+attach.width/2)+5, (attach.y+attach.height/2));
            }
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (dir != null){
        switch(dir){
            case LEFT:
                velocity.x = -bulletSpeed;
                angle = 180 +dudeangle;
            case RIGHT:
                angle = 0 + dudeangle;
                velocity.x = bulletSpeed;
            case UP:
                velocity.y = -bulletSpeed;
                angle = 90 + dudeangle;
            case DOWN:
                velocity.y = bulletSpeed;
                angle = 270 + dudeangle;
        }
       }
    }

    public function killingObjects(){
        for (i in 0...killers.length){
        if (FlxG.pixelPerfectOverlap(this, killers[i],255)){
            kill();
            destroy();
            killers[i].die();
        }
        }

    }
}