package baseball.scenes {
	import baseball.Imports;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import relic.Asset;
	import relic.art.blitting.AnimatedBlit;
	import relic.art.blitting.Blit;
	import relic.art.blitting.BlitScene;
	import relic.art.Button;
	import relic.art.Slider;
	import relic.helpers.BitmapHelper;
	import relic.art.Scene;
	import relic.Keys;
	import relic.Resources;
	
	/**
	 * ...
	 * @author George
	 */
	public class ButtonTestScene extends BlitScene {
		private var r:Rectangle
		
		public var up:Boolean, down:Boolean;
		public function ButtonTestScene() {
			super(new BitmapData(600,340));
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			r = new Rectangle(100, 100, 200, 100);
			up = down = false;
			//bgColor = 0xFFFF0000;
			Keys.autoWatch(Keyboard.UP, this, "up");
			Keys.autoWatch(Keyboard.DOWN, this, "down");
		}
		
		override protected function createLayers():void {
			super.createLayers();
			assets.autoGroup(Button, "buttons");
		}
		
		override protected function addStaticChildren():void {
			super.addStaticChildren();
			
			var btn:Button;
			var ids:Array = ["btn_bomb", "btn_rock", "btn_block", "btn_gap", "btn_remove"];
			
			var params:Object = {
				x:5, y:5, size:32,
				graphic: { back:Imports.BtnTemplate }
			}
			for (var id:String in ids) {
				
				place( assets.add(
					new Button(new AnimatedBlit(Imports.Buttons)), ids[id] )
				).setParameters(params);
				
				params.x += params.size + 5;
			}
			
			assets.setGroupAsTools("buttons", onToolClick);
			
		}
		
		private function onToolClick(e:MouseEvent):void {
			trace(e.currentTarget);
		}
	}
}