package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import lime.app.Application;
import lime.graphics.Image;
import openfl.display.BitmapData;

class PlayState extends FlxState
{
	public var camGame:FlxCamera;
	public var camHUD:FlxCamera;

	public var sideWalkSpr:FlxSprite;
	public var streetOverlaySpr:FlxSprite;

	// public var charSpriteDebugLmao:CCSprite;
	public var charList:FlxTypedSpriteGroup<Character>;
	public var scoreList:FlxTypedSpriteGroup<PopupText>;

	public var camFollow:FlxObject;
	public var followPoint:FlxPoint;

	public var buildingScroll:BuildingScroll;

	public var diffText:FlxText;
	public var scoreText:FlxText;

	// Y OF EACH CHARACTER: 420 TO 640
	public var musicBox:SongHandler;

	public function getBounds()
	{
		return new FlxPoint(4500, 700);
	}

	public var difficulty:Float = 0.5;
	public var score:Float = 0;

	// public var charCountPerDifficulty:Int = 25;

	public function killChar(instance:Character, phil:Bool)
	{
		if (instance.isDead)
			return;
		var newThing:Int = phil ? -500 : 10;
		score += newThing;
		difficulty += phil ? -0.35 : 0.025;
		popupText(1500, 750, newThing);
	}

	public function genCharacter()
	{
		var aliveLength:Int = 0;
		charList.forEachAlive(function(the:Character)
		{
			aliveLength++;
		});

		if (aliveLength > 75)
			return;

		var oldchar = charList.recycle(Character, null, true, true);
		oldchar.resetGuy(getBounds().x, getBounds().y, FlxG.random.int(420, 640), difficulty);
		charList.add(oldchar);
		oldchar.finishFunc = killChar;
		// trace("guy spawned");
		// followPoint.x = oldchar.getGraphicMidpoint().x;
		// followPoint.y = oldchar.getGraphicMidpoint().y;
	}

	public function popupText(centerX:Float, centerY:Float, newScore:Int)
	{
		var popup = scoreList.recycle(PopupText, null, true, true);
		popup.resetText(centerX, centerY, newScore);
		scoreList.add(popup);
		return popup;
	}

	public var defZoom:Float = 0.375;

	override public function create()
	{
		super.create();

		musicBox = new SongHandler();
		musicBox.playSong('side-walkin\'', 118);
		musicBox.stepFunction = songStep;
		musicBox.beatFunction = songBeat;

		// new camera
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camGame.zoom = defZoom;
		camHUD.bgColor.alpha = 1;
		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		camGame.bgColor = FlxColor.fromString("#99CCFF");

		// bg spr loading
		sideWalkSpr = new FlxSprite(-1571, 324.3).loadGraphic(Paths.image('Sidewalk'));
		// sideWalkSpr.x = 1280 / 2 - sideWalkSpr.width / 2;
		buildingScroll = new BuildingScroll(0, -250, 16);
		streetOverlaySpr = new FlxSprite(-370, -475).loadGraphic(Paths.image('Street Over'));

		// trace(sideWalkSpr.width);
		// trace(sideWalkSpr.height);

		sideWalkSpr.setGraphicSize(10836, 1639);

		sideWalkSpr.antialiasing = streetOverlaySpr.antialiasing = ClientSettings.antialiasing;

		// adding the bg
		add(sideWalkSpr);
		add(buildingScroll);
		add(streetOverlaySpr);

		// adding the characters
		// charSpriteDebugLmao = new CCSprite(1343.5, 584.9, 'Characters', 'Nicholas Idle', true);
		// charSpriteDebugLmao.addAnim('Death', 'Nicholas zDead', false, new FlxPoint(7, 60));
		// add(charSpriteDebugLmao);

		charList = new FlxTypedSpriteGroup<Character>();
		// genCharacter();
		add(charList);

		// cam follow
		followPoint = new FlxPoint(2640, 580);
		camFollow = new FlxObject();
		camGame.follow(camFollow, LOCKON, 0.03 / (FlxG.updateFramerate / 120));

		genCharacter();

		// score
		scoreList = new FlxTypedSpriteGroup<PopupText>();
		add(scoreList);

		// ui

		var textScale:Float = 1.5;

		diffText = new FlxText(20, 20, 0, 'Difficulty: $difficulty', Std.int(16 * textScale), true);
		diffText.setFormat(Paths.font('FredokaOne-Regular'), Std.int(16 * textScale), FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);

		scoreText = new FlxText(20, 20 + 20 * textScale, 0, 'Score: $score', Std.int(16 * textScale), true);
		scoreText.setFormat(Paths.font('FredokaOne-Regular'), Std.int(16 * textScale), FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);

		if (FlxG.onMobile)
		{
			var thingTextt = new FlxText(20, 20 + (20 * textScale) * 2, 0, 'Tap & Hold for 5 seconds to pause.', Std.int(16 * textScale), true);
			thingTextt.setFormat(Paths.font('FredokaOne-Regular'), Std.int(16 * textScale), FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE,
				FlxColor.BLACK, true);
			thingTextt.cameras = [camHUD];
			thingTextt.antialiasing = ClientSettings.antialiasing;

			add(thingTextt);
		}

		add(diffText);
		add(scoreText);

		diffText.cameras = scoreText.cameras = [camHUD];
		diffText.antialiasing = scoreText.antialiasing = ClientSettings.antialiasing;
	}

	public var totalElasped:Float = 0;

	public function charSort(bruh:Int, c1:Character, c2:Character)
	{
		return FlxSort.byValues(FlxSort.ASCENDING, c1.y, c2.y);
	}

	public var pressTimer:Float = 0;
	public var oldMusTime:Float = -1;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (oldMusTime != -1)
		{
			musicBox.playSong('side-walkin\'', 118);
			FlxG.sound.music.time = oldMusTime;
			oldMusTime = -1;
			// musicBox.toggleSongPause(false);
		}

		musicBox.update();

		totalElasped += elapsed;

		// DEBUG
		/*#if debug
			var thingToDebug = followPoint;
			var p = FlxG.keys.pressed;
			var amount = FlxG.keys.pressed.SHIFT ? 100 : 10;
			var ctrls = [p.LEFT, p.DOWN, p.RIGHT, p.UP, p.ENTER];
			for (i in 0...ctrls.length)
				if (ctrls[i])
					switch (i)
					{
						case 0:
							thingToDebug.x -= amount;
						case 1:
							thingToDebug.y += amount;
						case 2:
							thingToDebug.x += amount;
						case 3:
							thingToDebug.y -= amount;
						case 4:
							trace('[${thingToDebug.x}, ${thingToDebug.y}]');
					}
			#end */

		camFollow.setPosition(followPoint.x + Math.cos(totalElasped * 0.75) * 7.5, followPoint.y + Math.sin(totalElasped) * 20);

		if (FlxG.random.bool(difficulty) || FlxG.keys.justPressed.ENTER)
			genCharacter();

		difficulty += elapsed / 150;

		charList.sort(charSort);
		// var streetLayer = streetOverlaySpr.sort
		// for ()

		var trolled = FlxG.mouse.justPressed;

		for (i in charList)
			if (FlxG.mouse.overlaps(i) && FlxG.mouse.justPressed)
				if (i.isKillable && !i.isDead)
				{
					i.isDead = true;
					trolled = false;
					difficulty += 0.5;
					var scorePlus = i.speed * (i.x - 750) / 25;
					score += scorePlus;
					i.playAnim('death${i.characterSuffix}', true);
					popupText(i.getGraphicMidpoint().x, i.getGraphicMidpoint().y, Std.int(scorePlus));
					musicBox.playSound('kill', 0.5);
				}

		if (trolled)
		{
			score -= 150;
			difficulty -= 0.25;
			popupText(FlxG.mouse.getPositionInCameraView(camGame).x + 2450, FlxG.mouse.getPositionInCameraView(camGame).y + 300, -150);
		}

		if (difficulty < 0.5)
			difficulty = 0.5;

		diffText.text = 'Difficulty: ${Std.int(difficulty * 10) / 10}';
		scoreText.text = 'Score: ${Std.int(score)}';

		if (FlxG.mouse.pressed)
			pressTimer += elapsed;
		else
			pressTimer = 0;

		if (FlxG.keys.justPressed.ENTER)
		{
			// musicBox.toggleSongPause(true);
			oldMusTime = FlxG.sound.music.time;
			musicBox.playSong('timestop', 90, 0.35);
			musicBox.playSound('pause');
			// for (i in charList)
			//	i.philDied = true;
			openSubState(new PauseSubState(this));
		}

		// mobile users
		if (FlxG.onMobile && pressTimer >= 5)
		{
			FlxG.switchState(new MenuState());
		}

		#if debug
		FlxG.watch.add(musicBox, 'curStep', 'curStep');
		FlxG.watch.add(musicBox, 'curBeat', 'curBeat');
		FlxG.watch.add(this, 'pressTimer', 'pressTimer');
		#end

		// if (FlxG.keys.justPressed.NINE)
		//	Application.current.window.setIcon(Image.fromBitmapData(BitmapData.fromFile(Paths.image('fred'))));
	}

	// screen stuff
	public var beatingPatterns:Array<Array<Int>> = [
		[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
		[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
		[0, 1, 2, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15]
	];

	public var curBeatPat:Int = 0;
	public var zoomAddition:Float = 0.0125;
	public var angleAddition:Float = 0;

	public var bruhTween:FlxTween;

	public function tweenCam()
	{
		if (bruhTween != null)
			bruhTween.cancel();
		bruhTween = FlxTween.tween(camGame, {zoom: defZoom, angle: 0}, musicBox.getStepCrochet() / 500, {ease: FlxEase.cubeOut});
	}

	public function songStep()
	{
		if (ClientSettings.cameraMovement && beatingPatterns[curBeatPat].contains(musicBox.curBeat % 16) && musicBox.curStep % 64 == 62)
		{
			// trace(musicBox.curStep);
			camGame.zoom = defZoom + zoomAddition * ClientSettings.camZooming;
			camGame.angle = (musicBox.curBeat % 2 == 1 ? angleAddition : -angleAddition) * ClientSettings.camRotation;
			tweenCam();
		}
		if (musicBox.curStep % 4 == 3)
			charList.forEachAlive(function(the:Character)
			{
				the.funnyDance();
			});
	}

	public function checkBeat(beat)
	{
		// checks the section
		switch (Math.floor((beat + 1) / 4) + 1)
		{
			case 1:
				curBeatPat = 0;
				angleAddition = 0;
				zoomAddition = 0.0125;
			case 17:
				angleAddition = 1;
			case 21:
				curBeatPat = 1;
			case 25:
				curBeatPat = 2;
				angleAddition = 0;
			case 33:
				curBeatPat = 1;
				angleAddition = 5;
				zoomAddition = 0.02;
			case 41:
				curBeatPat = 2;
				angleAddition = 0;
				zoomAddition = 0.0125;
		}
	}

	public function songBeat()
	{
		for (i in 0...musicBox.curBeat)
			checkBeat(i);

		if (!ClientSettings.cameraMovement || !beatingPatterns[curBeatPat].contains(musicBox.curBeat % 16))
			return;
		// trace(musicBox.curBeat);
		camGame.zoom = defZoom + zoomAddition * ClientSettings.camZooming;
		camGame.angle = (musicBox.curBeat % 2 == 1 ? angleAddition : -angleAddition) * ClientSettings.camRotation;
		tweenCam();
	}
}
