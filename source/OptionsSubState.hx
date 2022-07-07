package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class OptionsSubState extends FlxSubState
{
	public var bruhCam:FlxCamera;

	var newPopup:OptionsPopup;

	override public function create()
	{
		bruhCam = new FlxCamera();
		bruhCam.bgColor.alpha = 0;
		super.create();
		FlxG.cameras.add(bruhCam, false);
		var popupBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		popupBG.alpha = 0;
		add(popupBG);
		FlxTween.tween(popupBG, {alpha: 0.5}, 0.75, {ease: FlxEase.quadIn});
		newPopup = new OptionsPopup(0, 0);
		newPopup.screenCenter();
		var oldY = newPopup.y;
		newPopup.y = 0;
		newPopup.cameras = popupBG.cameras = [bruhCam];
		FlxTween.tween(newPopup, {y: oldY}, 1.5, {ease: FlxEase.bounceOut});
		add(newPopup);
		newPopup.exitFunc = function()
		{
			ClientSettings.setData();
			FlxG.cameras.remove(bruhCam);
			FlxG.switchState(new MenuState());
		};
	}

	override public function update(e:Float)
	{
		super.update(e);
		if (FlxG.keys.justPressed.ESCAPE)
			newPopup.exitFunc();
	}
}
