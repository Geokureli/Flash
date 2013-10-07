package algae.phases {
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import krakel.KrkSprite;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author George
	 */
	public class TideOutPhase extends Phase {
		
		public function TideOutPhase(target:FlxBasic) {
			super(target);
			title = "Lowering Tide";
		}
		
		override public function start(endCallBack:Function = null):void {
			super.start(endCallBack);
			TweenLite.to(tide, 2, { y:FlxG.height, ease:Linear.easeNone, onComplete:end } );
		}
		
		public function get tide():KrkSprite { return quadrat.tide; }
		
	}

}