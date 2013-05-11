package greed.art {
	import krakel.KrkTile;
	import org.flixel.FlxSprite;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author George
	 */
	public class CallbackTile extends KrkTile {
		
		public function CallbackTile(tile:FlxTile, data:XML) {
			super(tile, data);
		}
		
		
		override public function hitObject(obj:FlxSprite):void {
			super.hitObject(obj);
			if (obj is Hero)
				(obj as Hero).hitObject(this);
		}
	}

}