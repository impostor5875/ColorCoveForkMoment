package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

class CCSprite extends FlxSprite
{
	public var animOffsets:Map<String, FlxPoint> = new Map<String, FlxPoint>();

	public function new(x:Float, y:Float, sheetName:String, ?idleName:String = null, ?idleLooped:Bool = true)
	{
		super(x, y);
		frames = Paths.getSparrowAtlas(sheetName);
		if (idleName != null)
		{
			addAnim('idle', idleName, idleLooped, new FlxPoint(0, 0));
			playAnim('idle', true);
		}
		antialiasing = ClientSettings.antialiasing;
	}

	public function addAnim(name:String, prefix:String, looped:Bool, offset:FlxPoint)
	{
		animation.addByPrefix(name, prefix, 24, looped, false, false);
		animOffsets.set(name, offset);
	}

	public function addAnimIndices(name:String, prefix:String, indices:Array<Int>, looped:Bool, offset:FlxPoint)
	{
		animation.addByIndices(name, prefix, indices, '', 24, looped, false, false);
		animOffsets.set(name, offset);
	}

	public function playAnim(name:String, forced:Bool)
	{
		animation.play(name, true);

		if (animOffsets.exists(name))
		{
			var off = animOffsets.get(name);
			offset.set(off.x, off.y);
		}
		else
			offset.set(0, 0);
	}
}
