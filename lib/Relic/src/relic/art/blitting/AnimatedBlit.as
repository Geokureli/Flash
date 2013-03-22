package relic.art.blitting {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import relic.art.Animation;
	import relic.art.IAnimated;
	import relic.art.SpriteSheet;
	import relic.data.events.AnimationEvent;
	
	/**
	 * ...
	 * @author George
	 */
	public class AnimatedBlit extends Blit implements IAnimated {
		
		private var animations:Object;
		
		private var _currentAnimation:String;
		
		private var _frame:int;
		
		public var isPlaying:Boolean;
		
		public function AnimatedBlit(sheet:SpriteSheet = null) {
			super();
			if(sheet != null) addAnimationSet(sheet);
		}
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			animations = { };
			frame = 0;
			isPlaying = true;
		}
		
		public function addAnimationSet(sheet:SpriteSheet):void {
			if ("idle" in sheet.animations && currentAnimation == null)
				currentAnimation = "idle"
			for (var i:String in sheet.animations){
				animations[i] = sheet.animations[i];
				if (currentAnimation == null)
					currentAnimation = "idle";
			}
			setGraphicBounds();
		}
		
		override public function update():void {
			super.update();
			if (anim == null) return;
			if (frame > anim.numFrames * anim.rate)
				dispatchEvent(new AnimationEvent(AnimationEvent.COMPLETE, { name:currentAnimation } ));
			//if (graphicBounds == null) setGraphicBounds();
		}
		
		override public function draw():void {
			super.draw();
			
			if(isPlaying)
				frame++;
		}
		override protected function drawTile(position:Point, xIndex:int, yIndex:int):void {
			if (anim != null) 
				anim.drawFrame(frame, map.bitmapData, position);
			else
				super.drawTile(position, xIndex, yIndex);
			
		}
		override public function destroy():void {
			animations = null;
			_currentAnimation = null;
			super.destroy();
		}
		
		public function get anim():Animation { return animations[currentAnimation]; }
		
		public function get currentAnimation():String { return _currentAnimation; }
		public function set currentAnimation(value:String):void {
			_currentAnimation = value;
			frame = 0;
		}
		
		public function get frame():int { return _frame; }
		public function set frame(value:int):void { _frame = value; }
		
		override public function get numFrames():int {
			if (anim != null) return anim.numFrames;
			return super.numFrames;
		}
		
		override public function get rect():Rectangle {
			if (anim != null) return anim.getFrameRect(frame);
			return super.rect;
		}
	}

}