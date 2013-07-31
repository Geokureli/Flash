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
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author George
	 */
	public class Main extends KrkGame {
		
		{
			KrkLevel.CLASS_REFS.Gold = Gold;
			KrkLevel.CLASS_REFS.Treasure = Treasure;
			KrkLevel.CLASS_REFS.Door = Door;
			KrkLevel.CLASS_REFS.Button = Button;
			KrkLevel.CLASS_REFS.hero = Hero;
			KrkLevel.CLASS_REFS.overHero = OverworldHero;
			KrkLevel.CLASS_REFS.weightForm = WeightForm;
			KrkLevel.CLASS_REFS.levelPath = LevelPath;
			KrkSprite.GRAPHICS.greed_props = Imports.NORMAL_TILES;
			
			//CLASS_REFS.flipScheme = TileScheme;
			
			//CLASS_REFS.Arrow = Arrow;
			//CLASS_REFS.HoldSign = HoldSign;
			
			KrkTilemap.TILE_TYPES.spring = CallbackTile;
			//KrkTilemap.TILE_TYPES.button = Button;
			KrkTilemap.TILE_TYPES.ladder = CallbackTile;
			KrkTilemap.TILE_TYPES.fade = FadeTile;
		}
		
		static private const SCALE:Number = 1;
		
		public function Main():void {
			super(640 / SCALE, 360 / SCALE, LoaderState, SCALE);
			
			trace("1,2,3,4".indexOf(',',2));
		}
		
	}
	
}