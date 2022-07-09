package;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class Character extends CCSprite
{
	public var finishFunc:(instance:Character, isKillable:Bool) -> Void;

	override public function new(?x:Float = 0, ?y:Float = 0)
	{
		super(0, y, 'Characters');
		addAnimIndices('idle0', 'Nicholas Idle', [0, 1, 2, 3, 4, 5, 6, 7, 8], false, new FlxPoint(0, 0));
		addAnimIndices('idle1', 'Nicholas Idle', [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], false, new FlxPoint(0, 0));
		addAnim('death', 'Nicholas zDead', false, new FlxPoint(7, 60));
		addAnimIndices('idle0-phil', 'Phil Idle', [0, 1, 2, 3, 4, 5, 6, 7, 8], false, new FlxPoint(0, 0));
		addAnimIndices('idle1-phil', 'Phil Idle', [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], false, new FlxPoint(0, 0));
		addAnim('death-phil', 'Phil Vanishes', false, new FlxPoint(359, 61));
		addAnimIndices('idle0-faker', 'Faker Idle', [0, 1, 2, 3, 4, 5, 6, 7, 8], false, new FlxPoint(-7, 0));
		addAnimIndices('idle1-faker', 'Faker Idle', [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], false, new FlxPoint(-7, 0));
		addAnim('death-faker', 'Faker Vanishes', false, new FlxPoint(359, 61));
		addAnimIndices('idle0-speedster', 'Speedster Idle', [0, 1, 2, 3, 4, 5, 6, 7, 8], false, new FlxPoint(-7, 12));
		addAnimIndices('idle1-speedster', 'Speedster Idle', [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], false, new FlxPoint(-7, 12));
		addAnim('death-speedster', 'Speedster Vanishes', false, new FlxPoint(139, 122));

		animation.finishCallback = function(anim:String)
		{
			if (anim.startsWith("death"))
				alpha = 0;
		};
	}

	private var danceCount:Int = 0;

	public function funnyDance(?change:Bool = true)
	{
		if (isDead)
			return;
		playAnim('idle${danceCount}${characterSuffix}', true);
		if (change)
			danceCount = danceCount == 0 ? 1 : 0;
	}

	public var characterSuffix:String = "";
	public var isKillable:Bool = false;
	public var isDead:Bool = false;

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

		var rand = FlxG.random.int(5, 15);
		speed = 20 - rand;

		var topNumber:Int = 1;
		if (diff >= 25)
			topNumber = 3;
		else if (diff >= 15)
			topNumber = 2;

		var funnyCharacter = FlxG.random.int(1, topNumber);
		switch (funnyCharacter)
		{
			/*case 0:
				characterSuffix = ""; */
			case 1:
				isKillable = FlxG.random.bool(snapFloat(diff * 25, 5, 30));

				if (isKillable)
					characterSuffix = "-phil";
				else
					characterSuffix = "";
			case 2:
				isKillable = FlxG.random.bool(snapFloat(diff * 20, 5, 30));

				if (isKillable)
				{
					characterSuffix = "-speedster";
					speed += 15;
				}
				else
					characterSuffix = "";
			case 3:
				isKillable = FlxG.random.bool(snapFloat(diff * 18, 5, 20));

				if (isKillable)
				{
					characterSuffix = "-faker";
					speed -= 5;
				}
				else
					characterSuffix = "";
		}

		isDead = false;

		// playAnim(isKillable ? 'idle-alt' : 'idle', true);

		theEndX = endX;
		funnyDance(false);

		/*walkTween = FlxTween.tween(this, {x: endX}, snapFloat(((rand / 10) * 12.5) - diff / 50, 2.5, 10) - (isKillable ? 0.5 : 0.05), {
			ease: FlxEase.linear,
			onComplete: function(twn:FlxTween)
			{
				kill();

				if (finishFunc != null)
					finishFunc(this, isKillable);
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
				finishFunc(this, isKillable);
		}
		else
			x -= speed * e * 45;
	}
}
