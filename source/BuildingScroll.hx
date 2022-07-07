package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class BuildingScroll extends FlxSpriteGroup
{
	public var buildingList:Array<FlxSprite> = [];

	public var buildingNames:Array<String> = ["Floppa Store", "The Place", "Fred's Bakery", "Pets Untied", "Lazer's Tag"];

	public function genBuilding(x:Int)
	{
		var building = new FlxSprite(x);
		building.frames = Paths.getSparrowAtlas('Buildings');
		for (i in 0...buildingNames.length)
			building.animation.addByIndices(buildingNames[i], 'Building Frames', [i], '', 24, true, false, false);
		building.antialiasing = ClientSettings.antialiasing;
		add(building);
		buildingList.push(building);
		swapBuilding(buildingList.length - 1, buildingNames[(buildingList.length - 1) % buildingNames.length]);
	}

	public function swapBuilding(building:Int, ?overrideBuilding:String = '')
	{
		buildingList[building].animation.play(overrideBuilding != '' ? overrideBuilding : FlxG.random.getObject(buildingNames), true);
	}

	// 492px apart
	override public function new(x:Int, y:Int, buildingCount:Int)
	{
		super(x, y);

		for (i in 0...buildingCount)
			genBuilding(i * 492);
	}
}
