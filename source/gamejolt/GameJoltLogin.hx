package gamejolt;

import flixel.FlxSprite;
import flixel.addons.ui.FlxInputText;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.ui.FlxUIInputText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.input.mouse.FlxMouseEvent;
import flixel.util.FlxColor;
using StringTools;

class GameJoltLogin extends MusicBeatSubstate {
    private var usernameInput:GJInputBox;
    private var tokenInput:GJInputBox;
    private var loginButton:FlxButton;

    var logo:FlxSprite;
    var zombie:FlxSprite;
    var loginBox:LoginButton;
    var checkBox:LoginCheckBox;
    var rememberMe:FlxSprite;
    var helpButton:FlxSprite;
    var rememberLogMe:Bool = GameJoltClient.rememberMe;
    public function new() {
        super();

        try {
            GameJoltManager.init();
        } catch (e:Dynamic) {
            trace("Error al inicializar GameJolt API:", e);
            FlxG.camera.flash(FlxColor.RED, 0.5);
            // Opcional: Mostrar mensaje de error al usuario
        }

        var tex = Paths.getSparrowAtlas("gamejolt/gameJoltLogin", "f4d");

        var bg:FlxSprite = new FlxSprite();
        bg.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        bg.alpha = 0;
        add(bg);

        FlxTween.tween(bg, {alpha: 0.55}, 0.4, {ease: FlxEase.quartInOut});

        zombie = new FlxSprite(682.75, 106);
        zombie.frames = tex;
        zombie.animation.addByPrefix("dance", "zombie", 24, false);
        zombie.antialiasing = ClientPrefs.globalAntialiasing;
        zombie.updateHitbox();
        add(zombie);
        // zombie.color = 0xFF000000;
        // FlxTween.color(zombie, 0xFF000000, FlxColor.WHITE, 1, {ease: FlxEase.quartInOut});

        // usernameInput = new FlxUIInputText(60.15, 306.1, 515, "", 40, FlxColor.BLACK, FlxColor.TRANSPARENT);
        usernameInput = new GJInputBox(60.15, 286.1, "username");
        // handleInput(usernameInput, "username");
        add(usernameInput);

        // tokenInput = new FlxUIInputText(60.15, 510.1, 515, "", 40, FlxColor.BLACK, FlxColor.TRANSPARENT);
        tokenInput = new GJInputBox(60.15, 490.1, "gametoken");
        // handleInput(tokenInput, "gametoken");
        if (StreamingDetector.isStreaming()){
            tokenInput.text.passwordMode = true;
        }else{
            tokenInput.text.passwordMode = false;
        }
        add(tokenInput);

        checkBox = new LoginCheckBox(76.6, 594.65, rememberLogMe);
        trace(checkBox.x + 105.29, checkBox.y + 1.6);
        rememberMe = new FlxSprite(checkBox.x + 105.29, checkBox.y + 1.6);
        rememberMe.frames = tex;
        rememberMe.animation.addByPrefix("remember", "remember me", 24, false);
        rememberMe.animation.play("remember");
        rememberMe.antialiasing = ClientPrefs.globalAntialiasing;
        rememberMe.updateHitbox();
        add(rememberMe);
        // shade
        var rememberMeShade = new FlxSprite(rememberMe.x, rememberMe.y);
        rememberMeShade.frames = Paths.getSparrowAtlas("gamejolt/remembermeShade", "f4d");
        rememberMeShade.animation.addByPrefix("check", "remember check", 24, false);
        rememberMeShade.antialiasing = ClientPrefs.globalAntialiasing;
        rememberMeShade.scale.x = rememberMe.scale.x;
        rememberMeShade.scale.y = rememberMe.scale.y;
        rememberMeShade.angle = rememberMe.angle;
        rememberMeShade.alpha = rememberMe.alpha;
        rememberMeShade.updateHitbox();
        rememberMeShade.animation.finishCallback = function(name){
            rememberMeShade.visible = false;
        }
        rememberMeShade.visible = false;
        add(rememberMeShade);
        // end
        checkBox.onCheck = function(val:Bool) {
            rememberLogMe = val;
            rememberMeShade.visible = val;
            if (val){
            rememberMeShade.animation.play("check");
            rememberMeShade.x = rememberMe.x - rememberMeShade.width;
            rememberMeShade.y = rememberMe.y - rememberMeShade.height;
            }else{
            rememberMeShade.animation.stop();
            if (rememberMeShade.animation.curAnim != null){
                rememberMeShade.animation.curAnim.curFrame = 0;
            }
            }
            trace(rememberLogMe);
        }
        // add check
        add(checkBox);

        loginBox = new LoginButton(430.2, 603.1, function() {
            onLogin();
        });
        add(loginBox);

        logo = new FlxSprite(60.15, 18.5);
        logo.frames = tex;
        logo.animation.addByPrefix("logo", "gamejoltLogo", 24, true);//if exists and anim :v
        logo.animation.play("logo");
        logo.antialiasing = ClientPrefs.globalAntialiasing;
        logo.updateHitbox();
        add(logo);

        FlxG.camera.scroll.x = 0;
        FlxG.camera.scroll.y = 0;
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (FlxG.sound.music != null){
            Conductor.songPosition = FlxG.sound.music.time;
        }

        if (FlxG.keys.justPressed.ENTER) {
            onLogin();
        }
        if (FlxG.keys.justPressed.Q) {
            tokenInput.text.passwordMode = !tokenInput.text.passwordMode;
            tokenInput.text.text = tokenInput.text.text;
        }
        if (controls.BACK){
            FlxG.state.closeSubState();
        }

        if (FlxG.keys.justPressed.F3){
            GameJoltManager.logout();
        }
    }

    override function beatHit() {
        super.beatHit();
        zombie.animation.play("dance");
    }

    private function onLogin():Void {
            var username = usernameInput.text.text;
            var token = tokenInput.text.text;
            trace("Username: " + username + ", Token: " + token);            
            if (username.trim() == "" || token.trim() == "") {
                FlxG.camera.flash(FlxColor.RED, 0.5);
                trace("Username or token cannot be empty!");
                return;
            }
            
            GameJoltManager.login(username, token, rememberLogMe, function(success:Bool) {
                if (success) {
                    FlxG.camera.flash(FlxColor.GREEN, 1.1);
                    trace("Login successful!");
                    
                    // Cerrar el subestado después de un breve retraso
                    FlxTween.tween(zombie, {alpha: 0}, 0.5, {
                        onComplete: function(twn:FlxTween) {
                            FlxG.state.closeSubState();
                        }
                    });
                }/** else {
                    FlxG.camera.flash(FlxColor.RED, 0.5);
                    trace("Login failed. Check your credentials.");
                }**/
            });
    }
}

class GJInputBox extends FlxTypedGroup<Dynamic> {
    public var type:String = "username";
    public var box:FlxSprite;
    public var title:FlxSprite;
    public var text:FlxInputText;
    public function new(X=0.0, Y=0.0, type:String="username", _ID = 0) {
        super();
        this.type = type;

        box = new FlxSprite(X, Y);
        box.frames = Paths.getSparrowAtlas("gamejolt/gameJoltLogin", "f4d");
        box.animation.addByPrefix("box", type+" box", 0, false);
        box.animation.play("box");
        add(box);

        title = new FlxSprite(X+4.5,Y-62);
        title.frames = box.frames;
        var caca = type;
        if (type == "gametoken"){
            caca = "game token";
        }

        title.animation.addByPrefix(type, caca, 24, false);
        title.animation.play(type);
        title.antialiasing = ClientPrefs.globalAntialiasing;
        title.updateHitbox();
        add(title);

        var falopa = type == "username" ? GameJoltClient.username : GameJoltClient.userToken;
        text = new FlxInputText(X + 84.95, Y + 9.4, 515, GameJoltClient.rememberMe ? falopa:"", 40, FlxColor.BLACK, FlxColor.TRANSPARENT);
        text.setFormat(Paths.font("OCRAEXT.TTF"), 40, 0xFFFFFF, LEFT);
        text.caretColor = FlxColor.WHITE;
        text.caretWidth = 4;
        text.ID = _ID;
        add(text);
    }
}

class LoginCheckBox extends FlxSprite{
    public var value = false; // unchecked
    public var onCheck:Bool->Void;
    public function new(X=0.0,Y=0.0,value:Bool = false) {
        super(X,Y);
        this.value = value;

        frames = Paths.getSparrowAtlas("gamejolt/gameJoltLogin", "f4d");
        animation.addByPrefix("true", "checkbox check", 24, false);
        animation.addByPrefix("false", "checkbox uncheck", 24, true);
        animation.play(Std.string(value));
        antialiasing = ClientPrefs.globalAntialiasing;
        updateHitbox();
        FlxMouseEvent.add(this, 
            function(object:FlxSprite/*mousedown*/){
                      check();
            },
            function(object:FlxSprite/**onUp**/){

            },
            function(object:FlxSprite/**onmouseover**/){
                    this.color.brightness*1.6;
            },
            function(object:FlxSprite/**onmouseout**/){
                this.color.brightness=1;
            });
    }

    public function check() {
        value = !value;
        if (onCheck != null){
            onCheck(value);
        }
        animation.play(Std.string(value));
    }
}


class LoginButton extends FlxSprite{
    public var onHit:Void->Void;
    public function new(X=0.0,Y=0.0,onPress:Void->Void) {
        super(X,Y);
        this.onHit = onPress;

        frames = Paths.getSparrowAtlas("gamejolt/gameJoltLogin", "f4d");
        animation.addByPrefix("basic", "login basic", 24, false);
        animation.addByPrefix("hover", "login white", 24, true);
        animation.play("basic");
        antialiasing = ClientPrefs.globalAntialiasing;
        updateHitbox();
        FlxMouseEvent.add(this, 
            function(object:FlxSprite/*mousedown*/){
                      hit();
            },
            function(object:FlxSprite/**onUp**/){
            },
            function(object:FlxSprite/**onmouseover**/){
            },
            function(object:FlxSprite/**onmouseout**/){
            });
    }

    // aaaah, so bussy man!
    public override function update(elapsed:Float):Void {
        super.update(elapsed);
        if (FlxG.mouse.overlaps(this)){
            if (FlxG.mouse.justReleased){
                hit();
            }
            animation.play("basic");
        }else{
            animation.play("hover");   
        }

        if (FlxG.mouse.justPressed) {
            if (overlapsPoint(FlxG.mouse.getWorldPosition())) {
                hit();
            }
        }
    }

    public function hit() {
        if (onHit != null){
            onHit();
        }
    }
}