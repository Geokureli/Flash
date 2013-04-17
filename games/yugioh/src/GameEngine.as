package  {
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunk.SPEngine;
	/**
	 * ...
	 * @author George
	 */
	public class GameEngine extends SPEngine {
		
		public function GameEngine() { super(); }
		override public function init():void {
			super.init();
			SP.world = new PlayingField();
		}
	}

}
import art.Card;
import com.saia.starlingPunk.SPWorld;
class PlayingField extends SPWorld {
	private var card:Card;
	public function PlayingField() {
		super();
		add(card = new Card());
		card.scaleX = card.scaleY = .25;
	}
}