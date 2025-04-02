package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	var clown:Zombies;
	var staff:Zombies;
	var one:Zombies;
	var two:Zombies;
	var three:Zombies;

	override public function create()
	{
		super.create();

		clown = new Zombies(0, 0,"clown");
		add(clown);

		
		staff = new Zombies(800, 60,"staff");
		add(staff);

		
		one = new Zombies(20, 340,"shitOne");
		add(one);

		
		two = new Zombies(200, 340,"shitTwo");
		add(two);

		
		three = new Zombies(700, 340,"shitThree");
		add(three);

		FlxG.camera.zoom = 0.8;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ONE){
            clown.killZombie();
		}

		if (FlxG.keys.justPressed.TWO){
            staff.killZombie();
		}
		
		if (FlxG.keys.justPressed.THREE){
            one.killZombie();
		}
		
		if (FlxG.keys.justPressed.FOUR){
            two.killZombie();
		}
		
		if (FlxG.keys.justPressed.FIVE){
            three.killZombie();
		}
	}
}
