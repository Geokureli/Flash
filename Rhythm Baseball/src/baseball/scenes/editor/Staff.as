package baseball.scenes.editor {
	import baseball.art.Obstacle;
	import baseball.beat.BeatKeeper;

	import relic.art.Asset;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author George
	 */
	public class Staff extends Asset {
		static private const FORMAT:TextFormat = new TextFormat("Arial", 12, 0, true, null, null, null, null, TextFormatAlign.CENTER);
		
		public var beatsPerMeasure:int;
		public var texts:Vector.<TextField>;
		public var textsUsed:int;
		public var drag:Playback;
		private var _playback:Number;
		
		public function Staff() { super(); }
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			beatsPerMeasure = 4;
			texts = new Vector.<TextField>();
			textsUsed = 0;
			addChild(drag = new Playback());
			drag.x = Obstacle.HERO.x;
			drag.y = Obstacle.HERO.y - 120;
			_playback = 0;
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			draw();
		}
		public function draw():void {
			clear();
			var measure:int = BeatKeeper.toBeatPixels( -Obstacle.SCROLL) / 4 * beatsPerMeasure;
			graphics.lineStyle(2);
			var beat:int = BeatKeeper.beat;
			graphics.moveTo(0, Obstacle.HERO.y-100);
			graphics.lineTo(stage.stageWidth, Obstacle.HERO.y-100);
			graphics.moveTo(0, Obstacle.HERO.y+100);
			graphics.lineTo(stage.stageWidth, Obstacle.HERO.y+100);
			for (var x:int = Obstacle.HERO.x  - (BeatKeeper.beat % (beatsPerMeasure / 4)) * measure; x < stage.stageWidth; x += measure) {
				setText(beat.toString(), x);
				graphics.moveTo(x, Obstacle.HERO.y-100);
				graphics.lineTo(x, Obstacle.HERO.y+100);
				beat++;
			}
			drag.x = Obstacle.HERO.x + BeatKeeper.toBeatPixels(Obstacle.SCROLL) * (BeatKeeper.beat - playback);
			
		}
		private function setText(beat:String, x:Number):void {
			var text:TextField = getText();
			text.text = beat;
			addChild(text);
			text.x = x - text.width / 2;
			text.y = Obstacle.HERO.y - 120;
		}
		private function getText():TextField {
			if (textsUsed == texts.length) {
				var text:TextField = new TextField();
				text.defaultTextFormat = FORMAT;
				text.selectable = false;
				texts.push(text);
			}
			return texts[textsUsed++];
		}
		
		private function clear():void {
			graphics.clear();
			for each(var t:TextField in texts)
				if (t.parent != null) removeChild(t);
		}
		
		public function get playback():Number {
			return _playback;
		}
		
		public function set playback(value:Number):void {
			_playback = value;
			drag.x = Obstacle.HERO.x + BeatKeeper.toBeatPixels(Obstacle.SCROLL) * (BeatKeeper.beat - value);
		}
		public function get songStart():int {
			return playback * 60000 / BeatKeeper.beatsPerMinute;
		}
	}

}
import flash.display.Shape;
class Playback extends Shape {
	public function Playback() {
		super();
		graphics.lineStyle(3);
		graphics.beginFill(0);
		graphics.drawCircle(0, 0, 5);
		graphics.moveTo(0, 0);
		graphics.lineTo(0, 220);
	}
}