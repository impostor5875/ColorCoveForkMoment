package;

import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class MenuButton extends CCSprite
{
	public var button:String;

	override public function new(x:Float, y:Float, buttonn:String)
	{
		super(x, y, 'Sign Buttons');
		button = buttonn;
		addAnim('title', 'sign logo', true, new FlxPoint(0, 0));
		addAnim('play', 'play button', true, new FlxPoint(0, 4)); // new FlxPoint(-100, 4));
		addAnim('options', 'options', true, new FlxPoint(0, 5)); // new FlxPoint(-158, 5));
		playAnim(button, true);
	}

	public var oldTween:FlxTween;

	public var oldHovering:Bool = true;

	public function updateSize(hovering:Bool)
	{
		if (hovering == oldHovering)
			return;

		oldHovering = hovering;
		if (oldTween != null)
			oldTween.cancel();
		oldTween = FlxTween.tween(this.scale, {x: hovering ? 1.1 : 0.9, y: hovering ? 1.15 : 0.9}, 0.25, {ease: FlxEase.quadInOut});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
