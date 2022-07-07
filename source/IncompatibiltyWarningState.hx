#if !desktop
package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class IncompatibiltyWarningState extends FlxState
{
	var warningText:FlxText;

	override public function create()
	{
		var textScale = 2;
		warningText = new FlxText(20, 20 + (20 * textScale) * 2, 0, 'w', Std.int(16 * textScale), true);
		warningText.setFormat(Paths.font('FredokaOne-Regular'), Std.int(16 * textScale), FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		warningText.antialiasing = ClientSettings.antialiasing;

		add(warningText);

		warningText.text = 'Warning!\nThis game is meant for a windows desktop!\n\n${FlxG.onMobile ? 'Mobile web builds have a few known bugs,\nbut please report them on github!' : 'Web builds may have unknown bugs as of now,\nso please report them on github!'}\n\nhttps://www.github.com/DillyzThe1/ColorCove/\n';
		warningText.screenCenter();
	}

	override public function update(e:Float)
	{
		super.update(e);
		if (FlxG.mouse.justPressed)
			FlxG.switchState(new MenuState());
	}
}
#end
