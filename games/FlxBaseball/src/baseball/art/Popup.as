package baseball.art {
	import krakel.KrkNest;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author George
	 */
	public class Popup extends KrkNest {
		private var back:FlxSprite;
		
		public function Popup(width:Number=0, height:Number=0) {
			super(x, y);
			
			add(back = new FlxSprite((FlxG.stage.stageWidth - width) / 2, (FlxG.stage.height - height) / 2));
			
			back.makeGraphic(width, height);
		}
		
	}

}