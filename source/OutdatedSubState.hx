package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText.FlxTextAlign;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class OutdatedSubState extends FlxSubState
{
	var warningText:FlxText;

	public static var versionLink:String = 'https://raw.githubusercontent.com/DillyzThe1/ColorCove/master/colorCove.versionDownload';

	public static var curBuildNum:Int = 361;
	public static var curBuildVers:String = '0.5.0';
	public static var curBuildName:String = 'Game-Jam Release';

	public static var publicBuildNum:Int = curBuildNum;
	public static var publicBuildVers:String = curBuildVers;
	public static var publicBuildName:String = curBuildName;

	var mouseTimer:Float = 0;

	public var exitFunc:() -> Void;

	override public function create()
	{
		var popupBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		popupBG.alpha = 0;
		add(popupBG);
		FlxTween.tween(popupBG, {alpha: 0.5}, 0.75, {ease: FlxEase.quadIn});

		var textScale = 2;
		warningText = new FlxText(20, 20 + (20 * textScale) * 2, 0, 'w', Std.int(16 * textScale), true);
		warningText.setFormat(Paths.font('FredokaOne-Regular'), Std.int(16 * textScale), FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		warningText.antialiasing = ClientSettings.antialiasing;

		add(warningText);

		warningText.text = 'Warning!\n\n'
			+ 'You\'re running the $curBuildName on $curBuildVers (build $curBuildNum)!\n'
			+ 'The current public build is the $publicBuildName on $publicBuildVers (build $publicBuildNum)!\n' #if desktop
		+ 'Please consider updating your game!\n\n'
		#else
		+ 'Please download a desktop release!\n\n'
		#end
		+ 'https://www.github.com/DillyzThe1/ColorCove/releases/latest/\n\n'
		+
		'(${FlxG.onMobile ? 'Hold to igonre, ENTER to download.' : 'ESCAPE to ignore, ENTER to ${#if desktop 'update' #else 'download' #end}, C to view Changelog.'})';
		warningText.screenCenter();
		exitFunc = function()
		{
			FlxG.switchState(new MenuState());
		};
	}

	override public function update(e:Float)
	{
		super.update(e);
		if (FlxG.keys.justPressed.ESCAPE)
			exitFunc();
		else if (FlxG.keys.justPressed.ENTER)
			FlxG.openURL('https://www.github.com/DillyzThe1/ColorCove/releases/latest/');
		else if (FlxG.keys.justPressed.C)
			FlxG.openURL('https://www.github.com/DillyzThe1/ColorCove/blob/main/Changelog.md');

		if (FlxG.onMobile)
			if (FlxG.mouse.pressed)
			{
				mouseTimer += e;
				if (mouseTimer >= 2.5)
				{
					mouseTimer = 0;
					FlxG.openURL('https://www.github.com/DillyzThe1/ColorCove/releases/latest/');
				}
			}
			else
			{
				if (mouseTimer > 0.1)
					exitFunc();
				mouseTimer = 0;
			}
	}
}
