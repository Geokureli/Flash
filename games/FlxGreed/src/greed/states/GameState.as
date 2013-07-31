package greed.states {
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
	public class GameState extends KrkLevelManager {
		
		static public const NUM_LEVELS:int = 4;
		
		private var levelNum:Number;
		private var hellMode:Boolean;
		public function GameState() {
			super();
			trace("state constructor");
		}
		override public function create():void {
			levelNum = 0;
			hellMode = false;
			super.create();
			FlxG.bgColor = 0xFF808080;
		}
		override protected function addBG():void {
			super.addMG();
			
			startLevel(Imports.getLevel(levelNum.toString(), hellMode));
			
			FlxG.visualDebug = true;
			
		}
		override protected function addUI():void {
			super.addUI();
		}
		
		override protected function onLevelEnd():void {
			trace("end: " + levelNum);
			
			super.onLevelEnd();
			levelNum++;
			if (levelNum == NUM_LEVELS) {
				if (hellMode) return;
				else {
					hellMode = true;
					levelNum = 0;
				}
			}
			startLevel();
		}
		
	}

}