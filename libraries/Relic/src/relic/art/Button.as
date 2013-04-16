package relic.art {
	
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.display.BitmapData
	import relic.art.blitting.AnimatedBlit;
	import relic.art.blitting.Animation;
	import relic.art.blitting.Blit;
	import relic.art.blitting.TemplateSheet;
	import relic.Align;
	import relic.Asset;
	import relic.StretchMode;
	/**
	 * ...
	 * @author George
	 */
	public class Button extends Asset {
		
		static public const UP:String = "up",
							DOWN:String = "down",
							OVER:String = "over",
							SELECTED:String = "selected";
							
		public var isToggle:Boolean;
		
		private var _selected:Boolean;
		
		public function Button(graphic:IDisplay = null) { super(graphic); }
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			isToggle = false;
			_selected = false;
		}
		
		override protected function setGraphicParams(params:Object):void {
			if (!(graphic is IDisplay || graphic is BitmapData) && "borderTemplate" in params && graphic == null && !("type" in params)) {
				
				if (!(graphic is AnimatedBlit))
					graphic = new AnimatedBlit();
				
			}
			super.setGraphicParams(params);
		}
		
		override protected function createGraphic(params:Object):void {
			if (params is TemplateSheet) {
				
				if (!(graphic is AnimatedBlit))
					graphic = new AnimatedBlit();
					
				(graphic as Blit).borderTemplate = params as TemplateSheet;
					
			} else if (params is BitmapData) {
				
				if (!(graphic is AnimatedBlit))
					graphic = new AnimatedBlit();
				
				(graphic as Blit).child = params as BitmapData;
				
			} else
				super.createGraphic(params);
			
		}
		
		override protected function initAddedGraphic():void {
			super.initAddedGraphic();
			(graphic as IAnimated).defaultAnimation = (graphic as IAnimated).currentAnimation = "up";
			graphic.align = Align.CENTER;
			graphic.stretchMode = StretchMode.BORDER
		}
		
		override protected function addListeners():void {
			super.addListeners();
			mouseEnabled = true;
		}
		
		override protected function mouseHandle(e:MouseEvent):void {
			
			switch(e.type) {
				case MouseEvent.MOUSE_MOVE: break;
				case MouseEvent.MOUSE_DOWN: state = DOWN; break;
				case MouseEvent.CLICK: //break;
				case MouseEvent.MOUSE_OVER:	state = OVER; break;
				case MouseEvent.MOUSE_OUT: state = selected ? SELECTED : UP; break;
			}
			super.mouseHandle(e);
		}
		
		//public function get upState():Animation { return states.up; }
		//public function set upState(value:Animation):void {
			//states.addAnim = value;
			//if (states.currentAnimation == null) currentAnimation = "up";
		//}
		
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void {
			//trace(value);
			state = (value ? "selected" : "up");
			_selected = value;
		}
		
		public function get state():String { return (graphic as IAnimated).currentAnimation; }
		public function set state(value:String):void {
			(graphic as IAnimated).currentAnimation = value;
		}
		
	}
}