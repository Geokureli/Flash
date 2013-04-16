package relic.helpers {
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import relic.Asset;
	/**
	 * ...
	 * @author George
	 */
	public class MouseHelper {
		
		static private var listeners:Object;
		{
			listeners = { };
			listeners[MouseEvent.MOUSE_DOWN 	] = new Vector.<Asset>();
			listeners[MouseEvent.MOUSE_UP		] = new Vector.<Asset>();
			listeners[MouseEvent.MOUSE_MOVE		] = new Vector.<Asset>();
			listeners[MouseEvent.MOUSE_WHEEL	] = new Vector.<Asset>();
		}
		static public var enabled:Boolean
		static public var touching:Vector.<Asset>;
		static public var click:Asset;
		static public var stage:Stage;
		
		static public function init(stage:Stage):void {
			MouseHelper.stage = stage;
			for(var type:String in listeners)
				stage.addEventListener(type, mouseHandle);
			touching = new Vector.<Asset>()
		}
		
		static public function addMouseWatch(asset:Asset, type:String):void {
			
			if(listeners[type].indexOf(asset) == -1)
				
				listeners[type].push(asset);
		}
		static public function removeMouseWatch(asset:Asset, type:String):void {
			var index:int = listeners[type].indexOf(asset);
				
			if (index < listeners[type].length)
				
				listeners[type].splice(index, 1);
		}
		
		static public function clearAll():void {
			
			for (var type:String in listeners) 
				
				while(listeners[type].length > 0)
					
					listeners[type].pop();
				
		}
		
		static private function mouseHandle(e:MouseEvent):void {
			var mouse:Point = new Point(e.stageX, e.stageY);
			var outEvent:MouseEvent;
			var rolledOver:Boolean = false, rolledOut:Boolean = false;
			var i:int;
			
			for each(var asset:Asset in listeners[e.type]) {
				
				i = touching.indexOf(asset);
				
				if (asset.touchingPoint(mouse)) {
					// --- SEND EVENT TO GRAPHIC
					dispatchEvent(e, asset);
					
					if (e.type == MouseEvent.MOUSE_DOWN)
						click = asset;
					
					if (i == -1 && e.type == MouseEvent.MOUSE_MOVE) {
						
						if (!rolledOver) {
							// --- ROLL_OVER ONLY FOR TOP ASSET
							rolledOver = true;
							dispatchEvent(e, asset, MouseEvent.ROLL_OVER);
						}
						dispatchEvent(e, asset, MouseEvent.MOUSE_OVER);
						touching.push(asset);
					}
				} else if (i != -1 && e.type == MouseEvent.MOUSE_MOVE) {
					
					if (!rolledOut) {
						// --- ROLL_OUT ONLY FOR TOP ASSET
						rolledOut = true;
						dispatchEvent(e, asset, MouseEvent.ROLL_OUT);
					}
					dispatchEvent(e, asset, MouseEvent.MOUSE_OUT)
					touching.splice(i, 1);
				}
			}
			
			if (e.type == MouseEvent.MOUSE_UP) {
				
				if (click != null && touching.indexOf(click) != -1)
					
					dispatchEvent(e, click, MouseEvent.CLICK);
				
				click = null;
			}
		}
		
		//static public function get enabled():void {}
		
		static private function dispatchEvent(e:MouseEvent, asset:Asset, type:String = null):void {
			if (type == null) {
				
				asset.graphic.dispatchEvent(e);
				
			} else {
				
				asset.graphic.dispatchEvent(
					new MouseEvent(
						type == null ? e.type : type,
						e.bubbles,
						e.cancelable,
						e.stageX - asset.x,
						e.stageY - asset.y,
						e.relatedObject,
						e.ctrlKey,
						e.altKey,
						e.shiftKey,
						e.buttonDown,
						e.delta
					)
				);
			}
			//trace(type == null ? e.type : type);
		}
	}
}