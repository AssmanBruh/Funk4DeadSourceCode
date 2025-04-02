package pixelforce;

import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;

class Map extends MusicBeatState{
    var bf:Bf;
    var startpos = [0.0,0.0];
     
    public static var instance:Map;

    var enabled:Bool = false;

    var gunType:GunType = GUN;

    var stunnTmr:Float = 1; //for gun

    override function create() {
        super.create();

        instance = this;

        startpos = [300, 400];

        bf = new Bf(startpos);
        add(bf);

        new FlxTimer().start(stunnTmr, function(tmr){
            if (enabled){
                switch (gunType){
                    case SHOTGUN:
                        addSHOTGUNBullet();
                    case MP5:
                        addMP5Bullet();
                    case GUN:
                        addGunBullet();
                }
            }
        },0);
    }

    public function spawnBullet(enab:Bool = false){
       enabled = enab;
    }

    
    function addGunBullet(){
        var bullet = new Bullet(bf,bf.dir);
        bullet.dir = bf.dir;
        add(bullet);
        stunnTmr = 1.0;
    }

    function addMP5Bullet(){
        var bullet = new Bullet(bf,bf.dir);
        bullet.dir = bf.dir;
        add(bullet);
        stunnTmr = 0.07;
    }

    function addSHOTGUNBullet(){
        for (i in 0...3){
            var bullet = new Bullet(bf, bf.dir);
            bullet.dir = bf.dir;
            bullet.ID = i;
            switch (bullet.dir){
            case RIGHT, LEFT:    
                bullet.y += (bullet.height+6)*i;
                switch (i){
                    case 0:
                        bullet.dudeangle -= 35;
                    case 1:    
                        bullet.dudeangle += 0;
                    case 2:   
                        bullet.dudeangle -= 265;
                }
            case UP:    
                bullet.x += (bullet.width+6)*i;
                    switch (i){
                        case 0:
                            bullet.dudeangle += 75;
                        case 1:    
                            bullet.dudeangle += 0;
                        case 2:   
                            bullet.dudeangle += 225;
                    }
                case DOWN:    
                    bullet.x += (bullet.width+6)*i;
                        switch (i){
                            case 0:
                                bullet.dudeangle -= 80;
                            case 1:    
                                bullet.dudeangle += 0;
                            case 2:   
                                bullet.dudeangle -= 275;
                        }    
            }
            add(bullet);
        }
        stunnTmr = 0.83;
    }

    override function update(elapsed:Float){
        super.update(elapsed);

        if (controls.BACK){
            FlxG.switchState(new Funk4DeadMainMenu());
        }

        if (FlxG.keys.justPressed.ONE)
            gunType = GUN;
        if (FlxG.keys.justPressed.TWO)
            gunType = MP5;
        if (FlxG.keys.justPressed.THREE)
            gunType = SHOTGUN;
    }
}

enum GunType{
    SHOTGUN; //escopeta
    MP5; //mp5
    GUN; //normal gun
}