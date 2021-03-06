package astley.states {
	import astley.art.Cloud;
	import astley.art.EndPipe;
	import astley.art.Grass;
	import astley.art.Rick;
	import astley.art.Shrub;
	import astley.art.Tilemap;
	import astley.data.LevelData;
	import krakel.helpers.Random;
	import krakel.KrkSound;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author George
	 */
	public class BaseState extends FlxState {
		
		
		[Embed(source = "../../../res/astley/audio/music/nggyu.mp3")] static private const SONG_FILE:Class;
		//[Embed(source = "../../../res/astley/text/Flappy.ttf", fontFamily = "NES", embedAsCFF = "false")] static private const FONT:Class;
		
		static public const HERO_SPAWN_X:Number = 32;
		static public const EASY_WIN_MODE:Boolean = false;
		
		protected var _map:Tilemap;
		protected var _endPipe:FlxSprite;
		protected var _ground:FlxSprite;
		protected var _bgSprites:FlxGroup;
		protected var _song:KrkSound;
		
		override public function create():void {
			super.create();
			
			_song = new KrkSound().embed(SONG_FILE);
			
			setDefaultProperties();
			addBG();
			addMG();
			addFG();
		}
		
		protected function setDefaultProperties():void {
			
			_bgSprites = add(new FlxGroup()) as FlxGroup;
			
			var levelSize:int = _song.duration * Rick.SPEED;
			
			if (EASY_WIN_MODE) {
				
				var buffer:int = ((Math.ceil(levelSize / LevelData.TILE_SIZE) - Tilemap.PIPE_START ) % Tilemap.PIPE_INTERVAL) * LevelData.TILE_SIZE;
				levelSize = LevelData.TILE_SIZE * (Tilemap.PIPE_START + Tilemap.PIPE_INTERVAL * 1 + 2) + buffer;
			}
			
			FlxG.camera.bounds = new FlxRect(0, 0, levelSize, FlxG.height);
		}
		
		private function addBgSprites(parent:FlxGroup):void {
			
			// --- CLOUDS
			var x:int = 0;
			while (x < FlxG.camera.bounds.width)
				
				parent.add(new Cloud(x += Random.between(Cloud.MIN_SPREAD, Cloud.MAX_SPREAD, LevelData.TILE_SIZE)));
			
			// --- SHRUBS
			x = 0;
			while (x < FlxG.camera.bounds.width)
				
				parent.add(new Shrub(x += Random.between(Shrub.MIN_SPREAD, Shrub.MAX_SPREAD, LevelData.TILE_SIZE)));
		}
		
		protected function addBG():void {
			
			addBgSprites(_bgSprites);
			addTileMap();
			add(new Grass());
			add(_ground = new FlxSprite(0, LevelData.SKY_HEIGHT));
			_ground.makeGraphic(FlxG.width, LevelData.FLOOR_HEIGHT, 0xFF109400);
			_ground.scrollFactor.x = 0;
			_ground.solid = true;
		}
		
		protected function addTileMap():void {
			//Tilemap.addPipes = false;
			add(_map = new Tilemap());
		}
		
		protected function addMG():void { }
		protected function addFG():void {
			
			add(_endPipe = new EndPipe(_map.endX, _map.endY));
		}
		
		protected function setCameraFollow(target:Rick):void {
			FlxG.camera.target = target;
			FlxG.camera.deadzone = new FlxRect (
				target.x,
				0,
				target.width,
				FlxG.camera.height
			);
		}
		
		protected function onStart():void {
			
			//_song.play(true);
		}
		
		override public function update():void {
			super.update();
			
			updateWorldBounds();
		}
		
		protected function updateWorldBounds():void { }
	}

}