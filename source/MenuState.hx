package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Http;

class MenuState extends FlxState
{
	public var menuTitle:MenuButton;
	public var menuPlay:MenuButton;
	public var menuOptions:MenuButton;

	public var musicBox:SongHandler;

	public var camGame:FlxCamera;

	public static var checkedVersion:Bool = false;

	override public function create()
	{
		super.create();

		ClientSettings.retrieveData();
		camGame = new FlxCamera();
		camGame.zoom = 1;
		FlxG.cameras.reset(camGame);
		camGame.bgColor = FlxColor.fromString("#99CCFF");

		var menuSky = new FlxSprite(0, 0).loadGraphic(Paths.image('Sky'));
		var menuHill = new FlxSprite(0, 500).loadGraphic(Paths.image('Hill'));
		var signPost = new FlxSprite(0, 137.1).loadGraphic(Paths.image('Sign Post'));

		menuOptions = new MenuButton(0, 493.4, 'options');
		menuPlay = new MenuButton(0, 275.8, 'play');
		menuTitle = new MenuButton(0, 59.5, 'title');
		menuTitle.addAnim('fred 3am', 'sign fred tween', false, new FlxPoint(0, 0));

		musicBox = new SongHandler();
		musicBox.playSong('cove-of-the-colors', 76);
		musicBox.stepFunction = songStep;
		musicBox.beatFunction = songBeat;

		add(menuSky);
		add(menuHill);
		add(signPost);
		add(menuOptions);
		add(menuPlay);
		add(menuTitle);

		signPost.scale.x = 0.65;

		menuSky.screenCenter();
		menuHill.screenCenter(X);
		signPost.screenCenter(X);
		menuOptions.screenCenter(X);
		menuPlay.screenCenter(X);
		menuTitle.screenCenter(X);

		var menuOff = 125;
		menuOptions.x += -menuOff + 165;
		menuPlay.x += -menuOff + 85;
		menuTitle.x += -menuOff;
		signPost.x += 43;

		menuSky.antialiasing = menuHill.antialiasing = signPost.antialiasing = ClientSettings.antialiasing;

		if (fredTrolling >= 10)
		{
			musicBox.playSound('OW MY EARS', 1.25);
			menuTitle.playAnim('fred 3am', true);
		}

		if (!checkedVersion)
		{
			checkedVersion = true;

			var dataRequest = new Http(OutdatedSubState.versionLink);
			var dataReturned:Array<String>;

			dataRequest.onData = function(data:String)
			{
				trace('Data returned to socket! Data: $data');
				// build num ; build vers ; build name
				dataReturned = data.split(';');
				OutdatedSubState.publicBuildNum = Std.parseInt(dataReturned[0]);
				OutdatedSubState.publicBuildVers = dataReturned[1];
				OutdatedSubState.publicBuildName = dataReturned[2];

				if (OutdatedSubState.curBuildNum != OutdatedSubState.publicBuildNum)
				{
					musicBox.playSound('pause');
					var ss:OutdatedSubState = new OutdatedSubState();
					ss.exitFunc = function()
					{
						closeSubState();
					};
					openSubState(ss);
				}
				else
					musicBox.playSound('allow');
				camGame.flash();
			};
			dataRequest.onError = function(data:String)
			{
				trace('No data returned to socket.');
				musicBox.playSound('deny');
			};

			dataRequest.request();
		}
	}

	public var shutup:Bool = false;

	public static var fredTrolling:Int = 0;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		musicBox.update();
		menuPlay.angle = -menuTitle.angle / 2;
		menuOptions.angle = menuTitle.angle / 2;

		menuPlay.updateSize(FlxG.mouse.overlaps(menuPlay));
		menuOptions.updateSize(FlxG.mouse.overlaps(menuOptions));

		if (FlxG.mouse.justPressed && !shutup)
			if (menuPlay.oldHovering)
				doPress(menuPlay);
			else if (menuOptions.oldHovering)
				doPress(menuOptions);
			else if (FlxG.mouse.overlaps(menuTitle))
			{
				if (fredTrolling == 10)
				{
					musicBox.playSound('OW MY EARS', 1.25);
					menuTitle.playAnim('fred 3am', true);
					FlxG.mouse.load(Paths.image('fred'), 0.1, -25, -25);
					fredTrolling = 20;
				}
				else if (fredTrolling < 10)
				{
					fredTrolling++;
					musicBox.playSound('le tap', 1);
				}
			}

		#if debug
		if (FlxG.keys.justPressed.NINE)
			doPress(null);
		#end
	}

	public function doPress(button:MenuButton)
	{
		camGame.flash(FlxColor.WHITE, 1, null, true);
		shutup = true;
		FlxTween.tween(camGame, {zoom: 1.5}, 1.25, {ease: FlxEase.quadInOut});

		FlxTween.tween(menuTitle, {x: FlxG.width + 500}, 0.75, {ease: FlxEase.quadIn});
		if (button != menuPlay)
			FlxTween.tween(menuPlay, {x: -500}, 0.75, {ease: FlxEase.quadIn});
		if (button != menuOptions)
			FlxTween.tween(menuOptions, {x: FlxG.width + 500}, 0.75, {ease: FlxEase.quadIn});

		var sound = musicBox.playSound('allow_alt', 0.75);
		sound.persist = false;

		var the:FlxTimer = new FlxTimer();
		the.start(3.5, function(time:FlxTimer)
		{
			if (button == menuPlay)
				FlxG.switchState(new PlayState());
			else if (button == menuOptions)
			{
				openSubState(new OptionsSubState());
			}
			#if debug
			else
				FlxG.switchState(new OffsetState());
			#end
		}, 1);

		/*sound.onComplete = function()
			{
				if (button == menuPlay)
					FlxG.switchState(new PlayState());
				else if (button == menuOptions)
					FlxG.switchState(new OffsetState());
		};*/
	}

	public function songStep() {}

	public function songBeat()
	{
		menuTitle.angle = musicBox.curBeat % 2 == 1 ? 5 : -5;
		FlxTween.tween(menuTitle, {angle: 0}, musicBox.getStepCrochet() / 500, {ease: FlxEase.cubeOut});
	}
}
