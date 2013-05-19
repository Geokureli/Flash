package color{
	import color.states.GameState;
	import flash.events.Event;
	import flash.utils.getTimer;
	import krakel.KrkGame;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author George
	 */
	public class Main extends KrkGame {
		
		public var signal:Signal;
		
		public function Main():void {
			super(640, 360, GameState);
		}
		override protected function create(e:Event):void {
			super.create(e);
			
			var i:int, t:int;
			var signal:Signal = new Signal();
			signal.add(func1);
			
			t = getTimer();
			for (i = 0; i < 100000; i++) 
				func1(0, 0);
			trace(getTimer() - t);	// --- 26
			
			t = getTimer();
			for (i = 0; i < 100000; i++) 
				func1.apply(this, [0, 0]);
			trace(getTimer() - t);	// --- 137
			
			t = getTimer();
			for (i = 0; i < 100000; i++) 
				func1.call(this, 0, 0);
			trace(getTimer() - t);	// --- 72
			
			t = getTimer();
			for (i = 0; i < 100000; i++) 
				func1.apply.call(this, this, [0, 0]);
			trace(getTimer() - t);	// --- 72
			
			t = getTimer();
			for (i = 0; i < 100000; i++) 
				signal.dispatch(0, 0);
			trace(getTimer() - t);	// --- 305
			
		}
		
		private function func1(x:int, y:int):void { }
		
	}
	
}