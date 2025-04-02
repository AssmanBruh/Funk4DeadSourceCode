import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxTimer;
import flixel.FlxCamera;

class AssmanTransition {
    public static function transitionTo(nextState:FlxState) {
        var cam = FlxG.camera;

        // Fade In + Zoom In
        cam.fade(0xFF000000, 0.5, false, function() {
            FlxG.switchState(nextState);
            
            // Reset Zoom para el siguiente estado
            cam.zoom = 2;
            
            // Fade Out + Zoom Out
            new FlxTimer().start(0.1, function(_) {
                cam.fade(0xFF000000, 0.5, true);
                FlxG.camera.zoom = 1;
            });
        });

        // Zoom In Effect
        new FlxTimer().start(0.01, function(timer) {
            if (cam.zoom < 2) {
                cam.zoom += 0.05;
                timer.reset(0.01);
            }
        });

         // Zoom In Effect
         new FlxTimer().start(0.5, function(timer) {
            FlxG.switchState(nextState);
        });
    }
}
