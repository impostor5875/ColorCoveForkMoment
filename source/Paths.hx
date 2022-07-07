package;

import flixel.graphics.frames.FlxAtlasFrames;

class Paths
{
	inline public static var SOUND_EXT:String = #if html5 "mp3" #else "ogg" #end;

	inline public static function asset(file:String)
	{
		return 'assets/$file';
	}

	inline public static function json(file:String)
	{
		return asset('data/$file.json');
	}

	inline public static function font(file:String, ?fontType:String = "ttf")
	{
		return asset('fonts/$file.$fontType');
	}

	inline public static function image(file:String)
	{
		return asset('images/$file.png');
	}

	inline public static function xml(file:String)
	{
		return asset('images/$file.xml');
	}

	inline public static function music(file:String)
	{
		return asset('music/$file.$SOUND_EXT');
	}

	inline public static function sound(file:String)
	{
		return asset('sounds/$file.$SOUND_EXT');
	}

	inline public static function getSparrowAtlas(files:String)
	{
		return FlxAtlasFrames.fromSparrow(image(files), xml(files));
	}
}
