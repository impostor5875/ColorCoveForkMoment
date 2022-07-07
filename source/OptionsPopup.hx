package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxFilterFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.exceptions.NotImplementedException;

using StringTools;

typedef OptionDataLmao =
{
	var varType:String;
	var iconType:String;
	var optionName:String;

	// option default
	var boolDefault:Bool;
	var floatDefault:Float;
	var intDefault:Int;
}

class OptionsPopup extends FlxSpriteGroup
{
	public static function optGen(vt:String, it:String, on:String, bd:Bool, fd:Float, id:Int)
	{
		var bruh:OptionDataLmao = {
			varType: vt,
			iconType: it,
			optionName: on,
			boolDefault: bd,
			floatDefault: fd,
			intDefault: id
		}
		return bruh;
	}

	public static function optBool(it:String, on:String, bd:Bool)
	{
		return optGen('bool', it, on, bd, 0, 0);
	}

	public static function optFloat(it:String, on:String, fd:Float)
	{
		return optGen('float', it, on, false, fd, 0);
	}

	public static function optInt(it:String, on:String, id:Int)
	{
		return optGen('int', it, on, false, 0, id);
	}

	var categories:Array<Dynamic> = [
		// a
		[
			'Volume',
			[
				optInt('headphones', 'Music Volume', Std.int(ClientSettings.musicVolume * 100)),
				optInt('sound', 'Sound Volume', Std.int(ClientSettings.soundVolume * 100))
			]
		],
		[
			'Cameras',
			[
				optBool('camera', 'Cam. Movement', ClientSettings.cameraMovement),
				optFloat('zoom', 'Cam. Zooming', ClientSettings.camZooming),
				optFloat('rotation', 'Cam. Rotation', ClientSettings.camRotation)
			]
		],
		['Visuals', [optBool('quality', 'Antialiasing', ClientSettings.antialiasing)]]
	];

	var bg:CCSprite;
	var tabText:FlxText;
	var tabArrowLeft:CCSprite;
	var tabArrowRight:CCSprite;

	var tabIndex:Int = 0;

	public var exitFunc:() -> Void;

	var optionArray:FlxTypedSpriteGroup<Option>;

	var exitButton:CCSprite;

	override public function new(x:Float, y:Float)
	{
		super(x, y);
		FlxG.camera.active = false;
		FlxG.camera.zoom = 1;
		bg = new CCSprite(0, 0, 'Options BG', 'Options BG0', true);
		add(bg);
		optionArray = new FlxTypedSpriteGroup<Option>();

		tabArrowLeft = new CCSprite(0, 100, 'Options Arrows');
		tabArrowLeft.addAnim('static', 'Option Arrow Static0', false, new FlxPoint(0, 0));
		tabArrowLeft.addAnim('press', 'Option Arrow Press0', false, new FlxPoint(42, 0));
		tabArrowLeft.addAnim('revive', 'Option Arrow Revive0', false, new FlxPoint(0, 0));
		tabArrowLeft.addAnim('die', 'Option Arrow Die0', false, new FlxPoint(0, 0));
		add(tabArrowLeft);
		tabArrowLeft.playAnim('static', true);

		tabArrowRight = new CCSprite(0, 0, 'Options Arrows');
		tabArrowRight.addAnim('static', 'Option Arrow Static0', false, new FlxPoint(0, 0));
		tabArrowRight.addAnim('press', 'Option Arrow Press0', false, new FlxPoint(0, 0));
		tabArrowRight.addAnim('revive', 'Option Arrow Revive0', false, new FlxPoint(0, 0));
		tabArrowRight.addAnim('die', 'Option Arrow Die0', false, new FlxPoint(0, 0));
		add(tabArrowRight);
		tabArrowRight.playAnim('static', true);
		tabArrowRight.flipX = true;

		exitButton = new CCSprite(485, 500, 'exit button');
		exitButton.addAnim('hit', 'go back lmao0', false, new FlxPoint(0, 0));
		exitButton.addAnimIndices('static', 'go back lmao0', [13, 14], false, new FlxPoint(0, 0));
		add(exitButton);

		var textScale = 2.5;
		tabText = new FlxText(0, 0, 0, 'Tab 1', Std.int(16 * textScale), true);
		tabText.setFormat(Paths.font('FredokaOne-Regular'), Std.int(16 * textScale), FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		tabText.antialiasing = ClientSettings.antialiasing;
		add(tabText);

		add(optionArray);
		// optionArray.setPosition(-250, 300);

		updateTabText(0);
	}

	public function updateTabText(tabChange:Int)
	{
		if (tabIndex + tabChange < 0)
			return;
		else if (tabIndex + tabChange >= categories.length)
			return;

		var real:Array<Option> = [];
		for (i in optionArray)
		{
			i.kill();
			i.destroy();
			real.push(i);
		}
		for (i in real)
			optionArray.remove(i);

		tabIndex += tabChange;

		FlxG.sound.play(Paths.sound('click lol'), ClientSettings.soundVolume * 1.1);

		/*if (tabIndex < 0)
				tabIndex = categories.length - 1;
			else if (tabIndex >= categories.length)
				tabIndex = 0; */

		tabArrowRight.animation.finishCallback = tabArrowLeft.animation.finishCallback = null;

		tabText.text = categories[tabIndex][0];

		tabText.x = bg.width / 2 - tabText.width / 2 + bg.x;
		tabArrowLeft.x = tabText.x - tabArrowLeft.width - 20;
		tabArrowRight.x = tabText.x + tabText.width + 20;
		tabText.y = tabArrowLeft.y + tabArrowLeft.height / 2 - tabText.height / 2;
		tabArrowRight.y = tabArrowLeft.y;

		if (tabChange < 0)
			tabArrowLeft.playAnim('press', true);
		else if (tabChange > 0)
			tabArrowRight.playAnim('press', true);

		if (tabIndex == 0)
			tabArrowLeft.animation.finishCallback = function(a:String)
			{
				tabArrowLeft.playAnim('die', true);
				tabArrowLeft.animation.finishCallback = null;
			};
		else if (tabArrowLeft.animation.name == 'die')
			tabArrowLeft.playAnim('revive', true);

		if (tabIndex == categories.length - 1)
			tabArrowRight.animation.finishCallback = function(a:String)
			{
				tabArrowRight.playAnim('die', true);
				tabArrowRight.animation.finishCallback = null;
			};
		else if (tabArrowRight.animation.name == 'die')
			tabArrowRight.playAnim('revive', true);

		var bruh:Array<OptionDataLmao> = categories[tabIndex][1];

		for (i in 0...bruh.length)
		{
			var obj = bruh[i];
			var pos = 0 + (100 * i);
			var option:Option;
			switch (obj.varType)
			{
				case 'bool':
					var bOption = new BoolOption(pos, obj.optionName, obj.iconType,
						ClientSettings.getBoolByString(obj.optionName.toLowerCase().replace(' ', '')));
					option = bOption;
				case 'float':
					var fOption = new FloatOption(pos, obj.optionName, obj.iconType,
						ClientSettings.getFloatByString(obj.optionName.toLowerCase().replace(' ', '')), 0.1, 0, 1.5);
					option = fOption;
				case 'int':
					var iOption = new IntOption(pos, obj.optionName, obj.iconType,
						ClientSettings.getIntByString(obj.optionName.toLowerCase().replace(' ', '')), 5, 0, 150);
					option = iOption;
				default:
					option = new Option(pos, obj.optionName, obj.iconType);
			}
			option.screenCenter(X);
			option.x -= 95;
			trace(obj.optionName + ' created');
			optionArray.add(option);
		}
	}

	override public function update(e:Float)
	{
		super.update(e);

		if (FlxG.keys.justPressed.LEFT)
			updateTabText(-1);
		else if (FlxG.keys.justPressed.RIGHT)
			updateTabText(1);

		if (tabArrowRight.animation.curAnim != null)
			if (tabArrowRight.animation.curAnim.name == 'press' && tabArrowRight.animation.curAnim.curFrame >= 6)
				tabArrowRight.offset.x = -43;
			else
				tabArrowRight.offset.x = 0;

		if (FlxG.mouse.justPressed)
		{
			for (i in optionArray)
				if (FlxG.mouse.overlaps(i.hitbox))
					i.clickThing();
			if (FlxG.mouse.overlaps(tabArrowLeft))
				updateTabText(-1);
			else if (FlxG.mouse.overlaps(tabArrowRight))
				updateTabText(1);
			else if (FlxG.mouse.overlaps(exitButton))
			{
				exitButton.playAnim('hit', true);
				exitFunc();
			}
		}

		if (FlxG.keys.justPressed.R)
		{
			// Volume
			ClientSettings.soundVolume = 1;
			ClientSettings.musicVolume = 0.25;
			// Cameras
			ClientSettings.cameraMovement = true;
			ClientSettings.camZooming = 1.0;
			ClientSettings.camRotation = 1.0;
			// Visuals
			ClientSettings.antialiasing = true;

			// settings new vars
			ClientSettings.setData();
			// displaying new vars
			for (i in optionArray)
				i.updateDisplay();
		}
	}
}

enum OptionType
{
	Null;
	Float;
	Integer;
	Boolean;
}

class Option extends FlxSpriteGroup
{
	var type:OptionType;
	var icon:CCSprite;
	var text:FlxText;
	var button:CCSprite;

	public var hitbox:FlxSprite;

	override public function new(y:Float, optionText:String, optionIcon:String)
	{
		super(0, y + 240);
		this.type = OptionType.Null;
		this.icon = new CCSprite(0, 0, 'Options Icons');
		this.icon.addAnim('sound', 'OI Sound', false, new FlxPoint(0, 0));
		this.icon.addAnim('headphones', 'OI Headphones', false, new FlxPoint(-15, -11));
		this.icon.addAnim('rotation', 'OI Rot', false, new FlxPoint(-21, -6));
		this.icon.addAnim('camera', 'OI Camera', false, new FlxPoint(-24, -14));
		this.icon.addAnim('zoom', 'OI Zoom', false, new FlxPoint(-14, -11));
		this.icon.addAnim('quality', 'OI quality', false, new FlxPoint(-24, -14));
		this.icon.playAnim(optionIcon, true);

		var textScale = 2.5;
		this.text = new FlxText(120, 0, 0, optionText, Std.int(16 * textScale), true);
		this.text.setFormat(Paths.font('FredokaOne-Regular'), Std.int(16 * textScale), FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		this.button = new CCSprite(text.x + text.width + 100, 0, 'Options Buttons');
		this.button.addAnim('?', 'undefined0', false, new FlxPoint(0, 0));
		this.button.addAnim('float', 'IntMod0', false, new FlxPoint(0, 0));
		this.button.addAnim('float minus', 'IntMod Minus0', false, new FlxPoint(5, 8));
		this.button.addAnim('float plus', 'IntMod Plus0', false, new FlxPoint(0, 9));
		this.button.addAnim('int', 'IntMod0', false, new FlxPoint(0, 0));
		this.button.addAnim('int minus', 'IntMod Minus0', false, new FlxPoint(5, 8));
		this.button.addAnim('int plus', 'IntMod Plus0', false, new FlxPoint(0, 9));
		this.button.addAnim('bool true', 'BoolMod true0', false, new FlxPoint(0, 64));
		this.button.addAnim('bool false', 'BoolMod false0', false, new FlxPoint(0, 40));
		this.button.playAnim('?', true);

		this.text.x += 40;

		this.icon.antialiasing = this.text.antialiasing = this.button.antialiasing = ClientSettings.antialiasing;

		add(this.text);
		add(this.icon);
		add(this.button);

		setupHitbox();
		add(hitbox);

		hitbox.alpha = #if debug 0.15 #else 0 #end;
	}

	public function setupHitbox()
	{
		throw new NotImplementedException("Override the setupHitbox() function.");
	}

	public function updateDisplay()
	{
		throw new NotImplementedException("Override the updateDisplay() function.");
	}

	public function clickThing()
	{
		throw new NotImplementedException("Override the clickThing() function.");
	}
}

class BoolOption extends Option
{
	public var realValue:Bool = false;

	override public function new(y:Float, optionText:String, optionIcon:String, defaultValue:Bool)
	{
		super(y, optionText, optionIcon);
		this.type = OptionType.Boolean;
		this.button.playAnim('bool $defaultValue', true);
		realValue = defaultValue;
	}

	override public function setupHitbox()
	{
		hitbox = new FlxSprite(this.button.x + 10, 2).makeGraphic(90, 60, FlxColor.RED);
		hitbox.antialiasing = ClientSettings.antialiasing;
	}

	override public function updateDisplay()
	{
		this.button.playAnim('bool $realValue', true);
		ClientSettings.updateBoolByString(text.text.toLowerCase().replace(' ', ''), realValue);
	}

	override public function clickThing()
	{
		realValue = !realValue;
		updateDisplay();
	}
}

class IntOption extends Option
{
	public var minValue:Int;
	public var realValue:Int;
	public var maxValue:Int;

	public var oldValue:Int;
	public var upBy:Int;
	public var bruhHitbox:FlxSprite;
	public var iAmPissedOff:FlxText;

	override public function new(y:Float, optionText:String, optionIcon:String, defaultValue:Int, upBy:Int, min:Int, max:Int)
	{
		super(y, optionText, optionIcon);
		this.button.playAnim('int', true);
		this.type = OptionType.Integer;
		realValue = defaultValue;
		this.upBy = upBy;
		this.minValue = min;
		this.maxValue = max;
		bruhHitbox = new FlxSprite().makeGraphic(90, 70, FlxColor.RED);
		bruhHitbox.alpha = #if debug 0.15 #else 0 #end;
		add(bruhHitbox);
		bruhHitbox.setPosition(hitbox.x + 90, 0);
		var textScale = 2.5;
		this.iAmPissedOff = new FlxText(this.button.x + 55, 2, 0, '$realValue', Std.int(16 * textScale), true);
		this.iAmPissedOff.setFormat(Paths.font('FredokaOne-Regular'), Std.int(16 * textScale), FlxColor.WHITE, FlxTextAlign.CENTER,
			FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, true);
		add(this.iAmPissedOff);
		this.iAmPissedOff.antialiasing = ClientSettings.antialiasing;
	}

	override public function update(e:Float)
	{
		super.update(e);
		bruhHitbox.setPosition(this.button.x, this.button.y);
	}

	override public function setupHitbox()
	{
		hitbox = new FlxSprite(this.button.x, 0).makeGraphic(180, 70, FlxColor.GREEN);
		hitbox.antialiasing = ClientSettings.antialiasing;
	}

	override public function updateDisplay()
	{
		this.button.playAnim(oldValue > realValue ? 'int minus' : 'int plus', true);
		this.iAmPissedOff.text = '$realValue';
		ClientSettings.updateIntByString(text.text.toLowerCase().replace(' ', ''), realValue);
	}

	override public function clickThing()
	{
		oldValue = realValue;
		if (FlxG.mouse.overlaps(bruhHitbox))
			realValue -= upBy;
		else
			realValue += upBy;
		if (realValue >= maxValue)
			realValue = maxValue;
		else if (realValue <= minValue)
			realValue = minValue;
		updateDisplay();
	}
}

class FloatOption extends Option
{
	public var minValue:Float;
	public var realValue:Float;
	public var maxValue:Float;

	public var oldValue:Float;
	public var upBy:Float;
	public var bruhHitbox:FlxSprite;
	public var iAmPissedOff:FlxText;

	override public function new(y:Float, optionText:String, optionIcon:String, defaultValue:Float, upBy:Float, min:Float, max:Float)
	{
		super(y, optionText, optionIcon);
		this.button.playAnim('int', true);
		this.type = OptionType.Float;
		realValue = defaultValue;
		this.upBy = upBy;
		this.minValue = min;
		this.maxValue = max;
		bruhHitbox = new FlxSprite().makeGraphic(90, 70, FlxColor.RED);
		bruhHitbox.alpha = #if debug 0.15 #else 0 #end;
		add(bruhHitbox);
		bruhHitbox.setPosition(hitbox.x + 90, 0);
		var textScale = 2.5;
		this.iAmPissedOff = new FlxText(this.button.x + 55, 2, 0, realValue == 1 ? '1.0' : '$realValue', Std.int(16 * textScale), true);
		this.iAmPissedOff.setFormat(Paths.font('FredokaOne-Regular'), Std.int(16 * textScale), FlxColor.WHITE, FlxTextAlign.CENTER,
			FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, true);
		add(this.iAmPissedOff);
		this.iAmPissedOff.antialiasing = ClientSettings.antialiasing;
	}

	override public function update(e:Float)
	{
		super.update(e);
		bruhHitbox.setPosition(this.button.x, this.button.y);
	}

	override public function setupHitbox()
	{
		hitbox = new FlxSprite(this.button.x, 0).makeGraphic(180, 70, FlxColor.GREEN);
		hitbox.antialiasing = ClientSettings.antialiasing;
	}

	override public function updateDisplay()
	{
		this.button.playAnim(oldValue > realValue ? 'int minus' : 'int plus', true);
		this.iAmPissedOff.text = realValue == 1 ? '1.0' : '$realValue';
		ClientSettings.updateFloatByString(text.text.toLowerCase().replace(' ', ''), realValue);
	}

	override public function clickThing()
	{
		oldValue = realValue;
		if (FlxG.mouse.overlaps(bruhHitbox))
			realValue -= upBy;
		else
			realValue += upBy;
		if (realValue >= maxValue)
			realValue = maxValue;
		else if (realValue <= minValue)
			realValue = minValue;
		updateDisplay();
	}
}
