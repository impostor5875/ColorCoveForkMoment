package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.FlxSound;

class SongHandler
{
	public function new() {}

	public var lastSongName:String;

	public function playSong(music:String, bpm:Int, ?soundMultiplier:Float = 1, ?withForce:Bool = false)
	{
		if (withForce || FlxG.sound.music == null || lastSongName != music)
		{
			lastSongName = music;
			FlxG.sound.playMusic(Paths.music(music));
			FlxG.sound.music.looped = true;
			FlxG.sound.music.volume = ClientSettings.musicVolume * soundMultiplier;
			setBPM(bpm);
		}
	}

	public function toggleSongPause(?paused:Null<Bool> = null)
	{
		if (paused == null)
			paused = !FlxG.sound.music.playing;

		if (paused)
			FlxG.sound.music.pause();
		else
			FlxG.sound.music.resume();
	}

	public function playSound(sound:String, ?soundMultiplier:Float = 1)
	{
		var newSound:FlxSound = FlxG.sound.load(Paths.sound(sound), ClientSettings.soundVolume * soundMultiplier);

		/*newSound.onComplete = function()
			{
				newSound.destroy();
		};*/
		#if lime_legacy
		newSound.pitch = FlxG.random.int(8, 12) / 10;
		trace("pee pants");
		#end
		newSound.play();
		return newSound;
	}

	public var curStep:Int = 0;
	public var curBeat:Int = 0;

	public var stepFunction:Void->Void;
	public var beatFunction:Void->Void;

	private var curBPM:Int;
	private var crochet:Float;
	private var stepCrochet:Float;

	public function getBPM()
	{
		return curBPM;
	}

	public function getCrochet()
	{
		return crochet;
	}

	public function getStepCrochet()
	{
		return stepCrochet;
	}

	public function setBPM(newBPM:Int)
	{
		curBPM = newBPM;
		crochet = (60 / curBPM) * 1000;
		stepCrochet = crochet / 4;
	}

	public function update()
	{
		var time = FlxG.sound.music != null && FlxG.sound.music.playing ? FlxG.sound.music.time : 0;

		var lastStep = curStep;
		var lastBeat = curBeat;

		curStep = Math.floor(time / stepCrochet);
		curBeat = Math.floor(curStep / 4);

		if (lastStep != curStep && stepFunction != null)
			stepFunction();
		if (lastBeat != curBeat && beatFunction != null)
			beatFunction();
	}
}
