package greed.states {
	import greed.Imports;
	import greed.art.Gold;
	import greed.levels.GreedLevel;
	import greed.art.Hero;
	import greed.art.Treasure;
	import krakel.KrkGameState;
	import krakel.KrkLevel;
	import krakel.KrkLevelManager;
	import org.flixel.FlxG;
	import org.flixel.FlxRect;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author George
	 */
	[SWF(width = "350", height = "800", backgroundColor = "#FFFFFF", frameRate = "30")]
	public class GameState extends KrkLevelManager {
		
		static public const NUM_LEVELS:int = 4;
		
		private var levelNum:Number;
		private var hellMode:Boolean;
		
		public function GameState() {
			super();
			trace("state constructor");
		}
		override public function create():void {
			super.create();
			
			levelNum = 0;
			hellMode = false;
			
			startLevel(Imports.getLevel(levelNum.toString(), hellMode));
		}
		
		override protected function onLevelEnd():void {
			super.onLevelEnd();
			
			trace("end: " + levelNum);
			
			levelNum++;
			if (levelNum == NUM_LEVELS) {
				if (hellMode) return;
				else {
					hellMode = true;
					levelNum = 0;
				}
			}
			startLevel(Imports.getLevel(levelNum.toString(), hellMode));
		}
		
	}

}