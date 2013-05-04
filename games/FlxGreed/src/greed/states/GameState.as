package greed.states {
	import greed.art.Hero;
	import greed.tilemaps.Level_test;
	import krakel.KrkGameState;
	import org.flixel.FlxG;
	import org.flixel.FlxRect;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author George
	 */
	public class GameState extends KrkGameState {
		static public const DEFAULT_REFS:Object = {X:1, ' ':0};
		private var hero:Hero;
		private var level:FlxTilemap;
		
		override public function create():void {
			super.create();
			FlxG.bgColor = 0xFFFFFFFF;
		}
		override protected function addBG():void {
			super.addBG();
			
			add(level = new Level_test(false));
			
			//add(level = new FlxTilemap());
			//level.loadMap(
				//createMap(
					//"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n" +
					//"X                                      X\n" +
					//"X                                      X\n" +
					//"X                                      X\n" +
					//"X                                      X\n" +
					//"X                                      X\n" +
					//"X                                      X\n" +
					//"X                                      X\n" +
					//"X                                      X\n" +
					//"X                                      X\n" +
					//"X                                      X\n" +
					//"X                                      X\n" +
					//"X                                      X\n" +
					//"X                                      X\n" +
					//"X                                      X\n" +
					//"X                                      X\n" +
					//"X                                      X\n" +
					//"X                                      X\n" +
					//"X                                      X\n" +
					//"X                XXXX                  X\n" +
					//"X                XXXX                  X\n" +
					//"X    XXXX        XXXX                  X\n" +
					//"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n"
				//),
				//FlxTilemap.ImgAuto,
				//8,
				//8,
				//FlxTilemap.AUTO
			//);
			
			
			FlxG.worldBounds.width = level.width;
			
			FlxG.worldBounds.height = level.height;
			
			FlxG.camera.bounds = new FlxRect(0, 0, level.width, level.height);
			
		}
		override protected function addMG():void {
			super.addMG();
			add(hero = new Hero(16, FlxG.height-24));
			FlxG.camera.follow(hero);
		}
		
		override public function update():void {
			super.update();
			FlxG.collide(hero, level);
		}
		
		override public function destroy():void {
			super.destroy();
			
		}
		protected function createMap(map:String, refs:Object = null):String {
			if (refs == null) refs = DEFAULT_REFS;
			
			map = map.split("").join(',').split(",\n,").join('\n');
			
			for (var i:String in refs)
				map = map.split(i).join(refs[i].toString());
			
			return map;
		}
	}

}