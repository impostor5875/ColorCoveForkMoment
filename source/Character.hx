package;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Character extends CCSprite
{
	public var finishFunc:(instance:Character, phil:Bool) -> Void;

	override public function new(?x:Float = 0, ?y:Float = 0)
	{
		super(0, y, 'Characters');
		addAnimIndices('idle0', 'Nicholas Idle', [0, 1, 2, 3, 4, 5, 6, 7, 8], false, new FlxPoint(0, 0));
		addAnimIndices('idle1', 'Nicholas Idle', [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], false, new FlxPoint(0, 0));
		addAnim('death', 'Nicholas zDead', false, new FlxPoint(7, 60));
		addAnimIndices('idle0-alt', 'Phil Idle', [0, 1, 2, 3, 4, 5, 6, 7, 8], false, new FlxPoint(0, 0));
		addAnimIndices('idle1-alt', 'Phil Idle', [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], false, new FlxPoint(0, 0));
		addAnim('death-alt', 'Phil Vanishes', false, new FlxPoint(359, 61));

		animation.finishCallback = function(anim:String)
		{
			if (anim == 'death-alt')
				alpha = 0;
		};
	}

	private var danceCount:Int = 0;

	public function funnyDance(?change:Bool = true)
	{
		if (philDied)
			return;
		playAnim('idle${danceCount}${phil ? '-alt' : ''}', true);
		if (change)
			danceCount = danceCount == 0 ? 1 : 0;
	}

	public var phil:Bool = false;
	public var philDied:Bool = false;

	public var speed:Float = 0;

	public function snapFloat(num:Float, min:Float, max:Float)
	{
		if (num < min)
			return min;
		if (num > max)
			return max;
		return num;
	}

	// public var walkTween:FlxTween;
	var theEndX:Float = 0;

	public function resetGuy(startX:Float, endX:Float, y:Float, diff:Float)
	{
		setPosition(startX, y);

		alpha = 1;

		phil = FlxG.random.bool(snapFloat(diff * 25, 5, 30));
		philDied = false;

		var rand = FlxG.random.int(5, 15);
		speed = 20 - rand;

		// playAnim(phil ? 'idle-alt' : 'idle', true);

		theEndX = endX;
		funnyDance(false);

		/*walkTween = FlxTween.tween(this, {x: endX}, snapFloat(((rand / 10) * 12.5) - diff / 50, 2.5, 10) - (phil ? 0.5 : 0.05), {
			ease: FlxEase.linear,
			onComplete: function(twn:FlxTween)
			{
				kill();

				if (finishFunc != null)
					finishFunc(this, phil);
			}
		});*/
	}

	override public function update(e:Float)
	{
		super.update(e);
		if (this.alive && x <= theEndX)
		{
			kill();
			if (finishFunc != null)
				finishFunc(this, phil);
		}
		else
			x -= speed * e * 45;
	}
}
