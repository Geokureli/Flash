package {
	import art.Scenes.AdvancedRectScene;
	import art.Scenes.DisplacementmapScene;
	import art.Scenes.MovementScene;
	import art.Scenes.ProjectionScene;
	import flash.filters.BitmapFilter;
	import relic.data.Game;
	
	/**
	 * ...
	 * @author George
	 */
	public class Main extends Game {
		public function Main() { super(); }
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			scenes = { main:AdvancedRectScene };
		}
	}
	
}