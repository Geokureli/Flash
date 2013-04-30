package krakel.ads {
	import com.greensock.TweenMax;
	import flash.events.MouseEvent;
	import krakel.KrkGame;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author George
	 */
	public class FlxMochiBox extends MochiBox {
		public var game:KrkGame;
		private var trackFocus:Boolean;
		
		public function FlxMochiBox(id:String) {
			super(id);
		}
		override public function clickAwayAd(onComplete:Function):void {
			super.clickAwayAd(onComplete);
			TweenMax.from(clickContainer, .5, { alpha:0, onComplete:bgTweenDone} );
			
			if (game != null) {	
				trackFocus = game.trackFocus;
				game.trackFocus = false;
			}
		}
		override protected function clickAwayLoaded(width:Number, height:Number):void {
			super.clickAwayLoaded(width, height);
		}
		protected function bgTweenDone():void {
			FlxG.pauseSounds();
		}
		override protected function dismissClickAway(e:MouseEvent):void {
			super.dismissClickAway(e);
			FlxG.resumeSounds();
			if (game != null)
				game.trackFocus = trackFocus;
		}
	}

}