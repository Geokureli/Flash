package relic.data {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author George
	 */
	public class Keys {
		
		static private const dispatcher:EventDispatcher = new EventDispatcher();
		
		static private const watchers:Vector.<KeyWatchList> = new Vector.<KeyWatchList>(256);
		
		static public function init(stage:Stage):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandle);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyHandle);
		}
		
		static private function keyHandle(e:KeyboardEvent):void {
			dispatchEvent(e);
			if(watchers[e.keyCode] != null)
				watchers[e.keyCode].state = e.type == KeyboardEvent.KEY_DOWN;
		}
		
		static public function autoWatch(keyCode:int, target:Object, paramID:String = null):void {
			if (watchers[keyCode] == null) watchers[keyCode] = new KeyWatchList(); 
			watchers[keyCode].add(target, paramID);
		}
		static public function removeWatch(keyCode:int, target:Object, paramID:String = null):void {
			if (watchers[keyCode] == null) return;
			watchers[keyCode].remove(target, paramID);
		}
		
		/* DELEGATE flash.events.EventDispatcher */
		
		static public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		static public function dispatchEvent(event:Event):Boolean {
			return dispatcher.dispatchEvent(event);
		}
		
		static public function hasEventListener(type:String):Boolean {
			return dispatcher.hasEventListener(type);
		}
		
		static public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		static public function toString():String {
			return dispatcher.toString();
		}
		
		static public function willTrigger(type:String):Boolean {
			return dispatcher.willTrigger(type);
		}
		
		static public function hasOwnProperty(V:* = null):Boolean {
			return dispatcher.hasOwnProperty(V);
		}
		
		static public function isPrototypeOf(V:* = null):Boolean {
			return dispatcher.isPrototypeOf(V);
		}
		
		static public function propertyIsEnumerable(V:* = null):Boolean {
			return dispatcher.propertyIsEnumerable(V);
		}
		
	}

}