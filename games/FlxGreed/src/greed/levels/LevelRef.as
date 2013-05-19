package greed.levels {
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import krakel.KrkLevel;
	/**
	 * ...
	 * @author George
	 */
	public class LevelRef {
		static public var ROOT_PATH:String;
		
		private var mapLoader:URLLoader;
		private var callBack:Function;
		
		public var xml:XML;
		private var csv:String;
		
		public var name:String;
		
		public function LevelRef(name:String, data:XML) {
			xml = data;
			this.name = name;
		}
		
		public function load(callBack:Function = null):void {
			
			mapLoader = new URLLoader();
			mapLoader.load(new URLRequest(ROOT_PATH + "maps/" + name + ".csv"));
			mapLoader.addEventListener(Event.COMPLETE, onMapLoaded);
			this.callBack = callBack;
		}
		
		private function onMapLoaded(e:Event):void {
			csv = mapLoader.data;
			mapLoader = null;
			if(callBack != null) callBack(this);
		}
		
		public function create():GreedLevel {
			var level:GreedLevel = new ChoiceLevel(csv);
			level.setParameters(xml);
			
			return level;
		}
	}

}