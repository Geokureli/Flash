package greed.states {
	import greed.art.Gold;
	import greed.levels.GreedLevel;
	import greed.art.Hero;
	import greed.art.Treasure;
	import krakel.KrkGameState;
	import krakel.KrkLevel;
	import org.flixel.FlxG;
	import org.flixel.FlxRect;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author George
	 */
	public class GameState extends KrkGameState {
		
		static public const NUM_LEVELS:int = 3;
		
		private var level:GreedLevel;
		private var levelNum:Number;
		private var hellMode:Boolean;
		
		override public function create():void {
			levelNum = 0;
			hellMode = false;
			super.create();
			FlxG.bgColor = 0xFF808080;
		}
		override protected function addBG():void {
			super.addMG();
			
			startLevel();
			
			FlxG.visualDebug = true;
			
		}
		override protected function addUI():void {
			super.addUI();
		}
		
		private function startLevel():void {
			//try {
				add(level = Imports.getLevel(levelNum.toString(), hellMode));
				level.endLevel = onLevelEnd;
				
				FlxG.worldBounds.width = level.width;
				
				FlxG.worldBounds.height = level.height;
				
				FlxG.camera.bounds = new FlxRect(0, 0, level.width, level.height);
				
			//} catch (e:Error) { level = null };
		}
		
		private function onLevelEnd():void {
			trace("end: " + levelNum);
			
			remove(level);
			level.destroy();
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