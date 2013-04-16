package relic.events 
{
	import flash.events.Event;
	import relic.art.Asset;
	
	/**
	 * ...
	 * @author George
	 */
	public class AssetEvent extends Event 
	{
		static public const KILL:String = "kill",
							IN_BOUNDS:String = "inBounds",
							OUT_BOUNDS:String = "outBounds";
							
		public var asset:Asset;
		public function AssetEvent(type:String, asset:Asset, bubbles:Boolean = false, cancelable:Boolean = false){
			super(type, bubbles, cancelable);
			this.asset = asset;
		}
		
	}

}