package krakel {
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author George
	 */
	public class KrkProp extends FlxSprite {
		
		public var defaultUpdate:Function;
		public var scheme:KrkScheme;
		
		public function KrkProp(x:Number=0, y:Number=0, simpleGraphic:Class=null) {
			super(x, y, simpleGraphic);
			
		}
		override public function preUpdate():void {
			super.preUpdate();
			if (scheme != null) scheme.preUpdate();
		}
		override public function update():void {
			super.update();
			if (scheme != null) scheme.update();
		}
		override public function postUpdate():void {
			super.postUpdate();
			if (scheme != null) scheme.postUpdate();
		}
		
		override public function destroy():void {
			super.destroy();
			if (scheme != null) scheme.destroy();
			scheme = null;
		}
	}

}