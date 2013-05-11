package krakel {
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author George
	 */
	public class HUD extends FlxGroup {
		
		override public function add(obj:FlxBasic):FlxBasic {
			if (obj is FlxSprite) (obj as FlxSprite).scrollFactor = new FlxPoint();
			return super.add(obj);
			
		}
		
	}

}