package baseball.states {
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author George
	 */
	public class IntroState extends FlxState {
		
		[Embed(source = "../../../res/sprites/logo.png")] static private const LOGO:Class;
		
		private var timer:FlxTimer;
		
		private var logo:FlxSprite;
		
		override public function create():void {
			super.create();
			
			FlxG.bgColor = 0xFFa4e4fc;
			
			add(logo = new FlxSprite(0, 0, LOGO));
			logo.x = (FlxG.width - logo.width) / 2;
			logo.y = FlxG.height - logo.height - 10;
			
			timer = new FlxTimer();
			
			TweenMax.from(logo, 1, { y:FlxG.height, ease:Cubic.easeOut, onComplete:onLogoIn } );
		}
		
		private function onLogoIn():void {
			timer.start(2.2, 1, startLogoLeave);
		}
		
		private function startLogoLeave(timer:FlxTimer):void {
			TweenMax.to(logo, 1, { y:-logo.height, ease:Cubic.easeIn, onComplete:onLogoOut } );
		}
		
		private function onLogoOut():void {
			FlxG.switchState(new MenuState());
		}
		
		override public function destroy():void {
			super.destroy();
			
			timer.destroy();
			timer = null;
		}
	}

}