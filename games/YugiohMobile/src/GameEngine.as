package  {
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunk.SPEngine;
	import starling.events.TouchEvent;
	/**
	 * ...
	 * @author George Kurelic
	 */
	public class GameEngine extends SPEngine {
		
		public function GameEngine() { super(); }
		override public function init():void {
			super.init();
			SP.world = new PlayingField();
			addEventListener(TouchEvent.TOUCH, mouseHandle);
		}
		
		private function mouseHandle(e:TouchEvent):void {
			if (SP.world is PlayingField)
				(SP.world as PlayingField).onTouch(e);
		}
	}

}
import art.Card;
import com.saia.starlingPunk.SPWorld;
import flash.geom.Point;
import starling.display.DisplayObject;
import starling.events.EventDispatcher;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

class PlayingField extends SPWorld {
	private var card:Card;
	private var drag:Boolean;
	
	public function PlayingField() {
		super();
		add(card = new Card());
		card.scaleX = card.scaleY = .25;
		drag = false;
	}
	override public function begin():void {
		super.begin();
		trace(parent);
	}
	public function onTouch(e:TouchEvent):void {
		var target:DisplayObject = e.target as DisplayObject;
		var touch:Touch = e.getTouch(target);
		if (touch == null) return;
		var pos:Point = new Point(touch.globalX, touch.globalY);
		switch(touch.phase) {
			case TouchPhase.BEGAN:
				if (pos.x >= card.x && pos.x < card.x + card.width && pos.y >= card.y && pos.y < card.y + card.height) {
					drag = true;
				}
				break;
			case TouchPhase.MOVED:
				if (drag) {
					card.x = pos.x;
					card.y = pos.y;
				}
				break;
			case TouchPhase.ENDED:
				drag = false;
				break;
		}
		trace(touch);
	}
	
}