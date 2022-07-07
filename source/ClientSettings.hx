package;

import flixel.FlxG;
import flixel.util.FlxSave;

class ClientSettings
{
	public static var globalSave:FlxSave;
	// Volume
	public static var soundVolume:Float = 1;
	public static var musicVolume:Float = 0.25;
	// Cameras
	public static var cameraMovement:Bool = true;
	public static var camZooming:Float = 1.0;
	public static var camRotation:Float = 1.0;
	// Visuals
	public static var antialiasing:Bool = true;

	public static function retrieveData()
	{
		if (globalSave == null)
		{
			globalSave = new FlxSave();
			globalSave.bind("CCGlobal");
		}

		if (globalSave.data.soundVolume != null)
			soundVolume = globalSave.data.soundVolume;
		if (globalSave.data.musicVolume != null)
			musicVolume = globalSave.data.musicVolume;
	}

	public static function setData()
	{
		globalSave.data.soundVolume = soundVolume;
		globalSave.data.musicVolume = musicVolume;
		globalSave.flush();
	}

	public static function updateBoolByString(str:String, value:Bool)
	{
		trace('$str = $value');

		switch (str)
		{
			case 'cam.movement':
				cameraMovement = value;
			case 'antialiasing':
				antialiasing = value;
		}
	}

	public static function updateIntByString(str:String, value:Int)
	{
		trace('$str = $value');

		switch (str)
		{
			case 'soundvolume':
				var floatVal:Float = value;
				soundVolume = floatVal / 100;
			case 'musicvolume':
				var floatVal:Float = value;
				musicVolume = floatVal / 100;
				FlxG.sound.music.volume = musicVolume;
		}
	}

	public static function updateFloatByString(str:String, value:Float)
	{
		trace('$str = $value');

		switch (str)
		{
			case 'cam.zooming':
				camZooming = value;
			case 'cam.rotation':
				camRotation = value;
		}
	}

	public static function getBoolByString(str:String)
	{
		switch (str)
		{
			case 'cam.movement':
				return cameraMovement;
			case 'antialiasing':
				return antialiasing;
		}
		return false;
	}

	public static function getIntByString(str:String)
	{
		switch (str)
		{
			case 'soundvolume':
				return Std.int(soundVolume * 100);
			case 'musicvolume':
				return Std.int(musicVolume * 100);
		}
		return 50;
	}

	public static function getFloatByString(str:String)
	{
		switch (str)
		{
			case 'cam.zooming':
				return camZooming;
			case 'cam.rotation':
				return camRotation;
		}
		return 0.5;
	}
}
