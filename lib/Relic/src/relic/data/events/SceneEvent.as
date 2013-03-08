package relic.data.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author George
	 */
	public class SceneEvent extends Event 
	{
		public var data:Object;
		static public const SCENE_CHANGE:String = "sceneChange";
		public function SceneEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
	}

}