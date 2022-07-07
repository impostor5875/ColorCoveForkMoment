package;

import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PopupText extends FlxText
{
	override public function new(newX:Float, newY:Float)
	{
		super(0, 0, 0, '+0', 48, true);
		setFormat(Paths.font('FredokaOne-Regular'), 48, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE, true);
		borderSize = 4;
		antialiasing = ClientSettings.antialiasing;
	}

	public function resetText(newX:Float, newY:Float, score:Int)
	{
		text = '${score > 0 ? '+' : ''}$score';
		color = score > 0 ? FlxColor.fromString("#33FF33") : FlxColor.fromString("#FF0099");
		borderColor = score > 0 ? FlxColor.fromString("#003300") : FlxColor.fromString("#330000");
		x = newX - 480; // - width / 2;
		y = newY - 25; // - height / 2;
		alpha = 1;

		// trace('new text $text as $color');

		FlxTween.tween(this, {y: y - 250}, 1.5, {
			ease: FlxEase.elasticOut,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(this, {alpha: 0}, 2.5, {
					ease: FlxEase.elasticOut,
					onComplete: function(twn:FlxTween)
					{
						kill();
					}
				});
			}
		});
	}
}
