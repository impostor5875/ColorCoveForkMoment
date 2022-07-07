package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PauseSubState extends FlxSubState
{
	var bruhCam:FlxCamera;

	var bg:FlxSprite;
	var bgTween:FlxTween;

	var exiting:Bool = false;
	var canInteract:Bool = false;

	var parentInstance:PlayState;

	var resumeText:FlxText;

	var optionList:FlxTypedSpriteGroup<PauseMenuText>;

	var curSel:Int = 0;
	var textScale:Float = 2.5;

	public function new(parentInst:PlayState)
	{
		super();
		parentInstance = parentInst;
	}

	override public function create()
	{
		super.create();
		bruhCam = new FlxCamera();
		bruhCam.bgColor.alpha = 0;
		FlxG.cameras.add(bruhCam, false);
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.5;
		add(bg);

		optionList = new FlxTypedSpriteGroup<PauseMenuText>();
		add(optionList);

		var resumeText = new PauseMenuText(0, 0, 0, 'Resume', Std.int(16 * textScale), true);
		resumeText.setFormat(Paths.font('FredokaOne-Regular'), Std.int(16 * textScale), FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		resumeText.buttonType = 'Resume';
		var reportBugText = new PauseMenuText(0, 0, 0, 'Report New Bug', Std.int(16 * textScale), true);
		reportBugText.setFormat(Paths.font('FredokaOne-Regular'), Std.int(16 * textScale), FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		reportBugText.buttonType = 'Issue Tracker';
		var endText = new PauseMenuText(0, 0, 0, 'End Game', Std.int(16 * textScale), true);
		endText.setFormat(Paths.font('FredokaOne-Regular'), Std.int(16 * textScale), FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		endText.buttonType = 'End Game';
		reportBugText.antialiasing = endText.antialiasing = resumeText.antialiasing = ClientSettings.antialiasing;

		optionList.add(resumeText);
		optionList.add(reportBugText);
		optionList.add(endText);

		bruhCam.alpha = 0;
		bgTween = FlxTween.tween(bruhCam, {alpha: 1}, 0.5, {
			ease: FlxEase.elasticInOut,
			onComplete: function(t:FlxTween)
			{
				canInteract = true;
			}
		});

		bg.cameras = optionList.cameras = [bruhCam];

		for (i in optionList)
			i.cameras = bg.cameras;

		updateSel();
	}

	public function updateSel(?selAdd:Int = 0)
	{
		curSel += selAdd;

		if (curSel <= -1)
			curSel = optionList.length - 1;
		else if (curSel >= optionList.length)
			curSel = 0;

		for (i in 0...optionList.length)
		{
			optionList.members[i].yGoal = FlxG.height / 2 - optionList.members[i].height / 2 - ((curSel - i) * optionList.members[i].height);
			// trace(optionList.members[i].yGoal);
			optionList.members[i].color = curSel == i ? FlxColor.fromString("#9999FF") : FlxColor.WHITE;
			optionList.members[i].text = curSel == i ? '> ${optionList.members[i].buttonType} <' : optionList.members[i].buttonType;
			optionList.members[i].screenCenter(X);
		}

		trace(curSel);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (exiting || !canInteract)
			return;

		if (FlxG.keys.justPressed.UP)
			updateSel(-1);
		else if (FlxG.keys.justPressed.DOWN)
			updateSel(1);

		if (FlxG.keys.justPressed.ENTER)
			pressIndex(optionList.members[curSel].buttonType);

		if (FlxG.keys.justPressed.ESCAPE)
			exit();
	}

	public function pressIndex(buttonType:String):Bool
	{
		switch (buttonType.toLowerCase())
		{
			case "resume":
				parentInstance.musicBox.playSound('allow');
				bruhCam.flash(FlxColor.WHITE, 0.5);
				exit();
				return true;
			case "issue tracker":
				parentInstance.musicBox.playSound('allow');
				bruhCam.flash(FlxColor.WHITE, 0.5);
				FlxG.openURL("https://www.github.com/DillyzThe1/ColorCove/issues");
				return true;
			case "end game":
				parentInstance.musicBox.playSound('allow');
				bruhCam.flash(FlxColor.WHITE, 0.5);
				canInteract = false;
				exiting = false;
				FlxTween.tween(optionList, {alpha: 0}, 0.35, {
					ease: FlxEase.elasticInOut
				});
				FlxTween.tween(bg, {alpha: 1}, 0.5, {
					ease: FlxEase.elasticInOut,
					onComplete: function(t:FlxTween)
					{
						FlxG.cameras.remove(bruhCam, true);
						FlxG.switchState(new MenuState());
					}
				});
				return true;
		}

		parentInstance.musicBox.playSound('deny', 0.5);
		return false;
	}

	public function exit()
	{
		canInteract = false;
		exiting = false;
		bgTween = FlxTween.tween(bruhCam, {alpha: 0}, 1, {
			ease: FlxEase.elasticInOut,
			onComplete: function(t:FlxTween)
			{
				FlxG.cameras.remove(bruhCam, true);
				parentInstance.closeSubState();
			}
		});
	}
}

class PauseMenuText extends FlxText
{
	public var yGoal(get, set):Float;

	var _yGoal:Float;
	var theWhen:FlxTween;

	public var buttonType:String = "default";

	override public function update(e:Float)
	{
		super.update(e);
	}

	function get_yGoal():Float
	{
		return _yGoal;
	}

	function set_yGoal(value:Float):Float
	{
		_yGoal = value;

		if (theWhen != null)
			theWhen.cancel();
		theWhen = FlxTween.tween(this, {y: _yGoal}, 0.5, {
			ease: FlxEase.cubeOut,
			onComplete: function(t:FlxTween) {}
		});

		return _yGoal;
	}
}
