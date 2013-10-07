package krakel {
	import org.flixel.FlxBasic;
	/**
	 * ...
	 * @author George
	 */
	public class KrkPhase {
		
		protected var active:Object;
		protected var target:FlxBasic;
		public var endCallBack:Function
		
		public function KrkPhase(target:FlxBasic) {
			this.target = target;
		}
		
		public function start(endCallBack:Function = null):void {
			active = true;
			this.endCallBack = endCallBack;
		}
		
		public function end():void {
			active = false;
			
			if (endCallBack != null)
				endCallBack(this);
		}
		
		public function update():void { }
		
		public function destroy():void {
			active = false;
			target = null;
		}
		
	}

}