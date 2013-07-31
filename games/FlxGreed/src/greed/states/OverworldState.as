package greed.states {
	import greed.levels.LevelRef;
	import greed.levels.Overworld;
	import krakel.KrkState;
	import org.flixel.FlxG;
	import org.flixel.FlxRect;
	
	/**
	 * ...
	 * @author George
	 */
	public class OverworldState extends KrkState {
		
		[Embed(source="../../../res/levels/MainMenu.xml",mimeType="application/octet-stream")] static private const OVERWORLD_XML:Class;
		[Embed(source="../../../res/levels/maps/MainMenu.csv",mimeType="application/octet-stream")] static private const OVERWORLD_CSV:Class;
		[Embed(source="../../../res/graphics/greed_props.png")] static private const TILES:Class;
		
		private var level:Overworld;
		
		override public function create():void {
			super.create();
			add(level = new Overworld(new OVERWORLD_CSV(), TILES));
			level.setParameters(new XML(new OVERWORLD_XML()));
		}
	}

}