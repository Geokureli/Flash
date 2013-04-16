package baseball.states {
	import baseball.Imports;
	import baseball.states.editor.EditorState;
	import baseball.states.play.ChargeState;
	import baseball.states.play.GameState;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author George
	 */
	public class MenuState extends FlxState {
		
		[Embed(source = "../../../res/sprites/ts_gfx.png")] static private const TITLE:Class;
		[Embed(source="../../../res/sprites/1_ball.png")] static private const BALL_1:Class;
		[Embed(source="../../../res/sprites/2_ball.png")] static private const BALL_2:Class;
		[Embed(source="../../../res/sprites/3_ball.png")] static private const BALL_3:Class;
		[Embed(source="../../../res/sprites/4_ball.png")] static private const BALL_4:Class;
		
		public var title:FlxSprite,
					playBtn:FlxSprite,
					chargeBtn:FlxSprite,
					editorBtn:FlxSprite;
		
		public var editor:EditorState;
		
		
		public function MenuState() { super(); }
		override public function create():void {
			super.create();
			
			FlxG.bgColor = 0xFFFFFFFF;
			add(title = new FlxSprite(182, 64, TITLE));
			title.scale.x = title.scale.y = 2;
			
			add(playBtn = new FlxButton(200, 200, null, playClick).loadGraphic(BALL_1));
			add(playBtn = new FlxButton(250, 200).loadGraphic(BALL_2));
			playBtn.alpha = .5;
			add(playBtn = new FlxButton(300, 200).loadGraphic(BALL_3));
			playBtn.alpha = .5;
			add(playBtn = new FlxButton(350, 200).loadGraphic(BALL_4));
			playBtn.alpha = .5;
			add(chargeBtn = new FlxButton(200, 250, "Charge", chargeClick));
			add(editorBtn = new FlxButton(300, 250, "Editor", editorClick));
			
			editor = new EditorState();
			editor.level = Imports.getLevel("tmottbg");
		}
		
		private function playClick():void {
			var game:GameState = new GameState();
			game.level = Imports.getLevel("tmottbg");
			FlxG.switchState(game);
		}
		
		private function chargeClick():void {
			FlxG.switchState(new ChargeState());
		}
		
		private function editorClick():void {
			FlxG.switchState(editor);
		}
	}

}