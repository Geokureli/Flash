package relic.art.blitting {
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import relic.Asset;
	import relic.art.IAnimated;
	import relic.events.AnimationEvent;
	import relic.helpers.StringHelper;
	
	/**
	 * ...
	 * @author George
	 */
	public class AnimatedBlit extends Blit implements IAnimated {
		
		private var animations:Object;
		
		private var _currentAnimation:String;
		
		private var _frame:int;
		
		private var _defaultAnimation:String;
		
		public var isPlaying:Boolean;
		
		public function AnimatedBlit(child:BitmapData = null) {
			super(child);
			defaultAnimation = "idle";
		}
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			animations = { };
			frame = 0;
			isPlaying = true;
			defaultAnimation = "idle";
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			
			if (!(defaultAnimation in animations) && sheet != null)
				addAnimationSet(sheet);
		}
		
		public function addAnimation(name:String, anim:Animation):void {
			if (currentAnimation == null) 
				currentAnimation = name;
			
			animations[name] = anim;
		}
		
		public function addAnimationSet(sheet:SpriteSheet, group:String = null):void {
			child = sheet;
			if ((asset == null || asset.id == null) && group == null)
				return;
			
			if (group == null) group = StringHelper.parseID(asset.id);
			if (!(group in sheet.groups)) group = "default";
			if (!(group in sheet.groups)) return;
			
			if (defaultAnimation in sheet.groups[group])
				currentAnimation = defaultAnimation;
			
			for (var i:String in sheet.groups[group])
				addAnimation(i, sheet.groups[group][i]);
			
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
		
		override protected function drawBorder():void {
			if (border != null && "default" in border.groups && currentAnimation != null)
				border.groups["default"][currentAnimation].drawFrame(frame, map.bitmapData, position);
			else
				super.drawBorder();
		}
		
		override protected function drawTile(position:Point, xIndex:int, yIndex:int):void {
			
			if (sheet != null && (currentAnimation in animations || defaultAnimation in animations))
				(currentAnimation in animations ? anim : animations[defaultAnimation] ).drawFrame(frame, map.bitmapData, position);
			else
				super.drawTile(position, xIndex, yIndex);
			
		}
		
		override public function destroy():void {
			animations = null;
			_currentAnimation = null;
			super.destroy();
		}
		
		public function hasAnimation(name:String):Boolean { return name in animations; }
		
		public function get anim():Animation { return animations[currentAnimation]; }
		
		override public function set asset(value:Asset):void {
			
			var init:Boolean = asset == null && sheet != null && value != null;
			super.asset = value;
			
			if (init)
				addAnimationSet(sheet);
			
		}
		
		override public function set sheet(value:SpriteSheet):void {
			super.sheet = value;
			if(asset != null) addAnimationSet(value);
		}
		
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
		
		public function get defaultAnimation():String { return _defaultAnimation; }
		public function set defaultAnimation(value:String):void { _defaultAnimation = value; }
		
	}

}