package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.util.FlxColor;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	// originally used for the offset state testing (made before any other state)
	public static var initialState:Class<FlxState> = #if desktop MenuState #else IncompatibiltyWarningState #end;
	public static var frameRate:Int = #if desktop 120 #else 60 #end;

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, initialState, 1, frameRate, frameRate, true, #if !desktop true #else false #end));
		addChild(new FPS(0, 0, FlxColor.WHITE));
		FlxG.mouse.visible = !FlxG.onMobile;
	}
}
