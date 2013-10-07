package greed{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import greed.art.Button;
	import greed.art.LevelPath;
	import greed.states.PathCreator;
	import greed.tiles.CallbackTile;
	import greed.art.Door;
	import greed.art.Gold;
	import greed.art.Hero;
	import greed.art.OverworldHero;
	import greed.art.Treasure;
	import greed.art.WeightForm;
	import greed.states.GameState;
	import greed.states.LoaderState;
	import greed.states.OverworldState;
	import greed.tiles.FadeTile;
	import krakel.helpers.StringHelper;
	import krakel.KrkGame;
	import krakel.KrkLevel;
	import krakel.KrkSprite;
	import krakel.KrkTilemap;
	import krakel.serial.KrkImporter;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author George
	 */
	[SWF(width = "720", height = "400", backgroundColor = "#000000", frameRate = "30")]
	public class Main extends KrkGame {
		
		static private function init():void {
			
			
			KrkLevel.CLASS_REFS.Gold = Gold;
			KrkLevel.CLASS_REFS.Treasure = Treasure;
			KrkLevel.CLASS_REFS.Door = Door;
			KrkLevel.CLASS_REFS.Button = Button;
			KrkLevel.CLASS_REFS.hero = Hero;
			KrkLevel.CLASS_REFS.overHero = OverworldHero;
			KrkLevel.CLASS_REFS.weightForm = WeightForm;
			KrkLevel.CLASS_REFS.levelPath = LevelPath;
			
			//CLASS_REFS.flipScheme = TileScheme;
			
			//CLASS_REFS.Arrow = Arrow;
			//CLASS_REFS.HoldSign = HoldSign;
			
			KrkTilemap.TILE_TYPES.spring = CallbackTile;
			//KrkTilemap.TILE_TYPES.button = Button;
			KrkTilemap.TILE_TYPES.ladder = CallbackTile;
			KrkTilemap.TILE_TYPES.fade = FadeTile;
		}
		
		{ init(); }
		
		static private const SCALE:Number = 2;
		
		public function Main():void {
			super(720 / SCALE, 400 / SCALE, GameState, SCALE);
			Imports.BEAM;
		}
		
		override protected function switchState():void {
			super.switchState();
			
			FlxG.bgColor = 0xFFC0C0A0;
		}
	}
	
}