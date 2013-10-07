package algae.phases {
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import krakel.KrkSprite;
	import org.flixel.FlxBasic;
	
	/**
	 * ...
	 * @author George
	 */
	public class TideInPhase extends Phase {
		
		public function TideInPhase(target:FlxBasic) {
			super(target);
			title = "Raising Tide";
		}
		
		override public function start(endCallBack:Function = null):void {
			super.start(endCallBack);
			
			TweenLite.to(tide, 2, { y:64, ease:Linear.easeNone, onComplete:end} );
			//transition.play(true);
			//music_main.fadeOut(1, true);
		}
		
		public function get tide():KrkSprite { return quadrat.tide; }
		
	}

}