package baseball.states {
	import baseball.Imports;
	import baseball.states.editor.EditorState;
	import baseball.states.play.ChargeState;
	import baseball.states.play.GameState;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import krakel.audio.SoundManager;
	import krakel.KrkState;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author George
	 */
	public class MenuState extends KrkState {
		
		[Embed(source = "../../../res/sprites/ts_gfx - Copy.png")] static private const TITLE:Class;
		
		static private const LEVELS:Vector.<String> = Vector.<String>(["tmottbg", "test", "test", "test"]);
		
		static private const LVL_BTN_Y:Number = 234;
		static private const HAS_EDITOR:Boolean = true;
		static private const LVL_BTN_GAP:Number = 50;
		
		static public var CHARGE_UNLOCKED:Boolean = true;
		
		public var title:FlxSprite,
					chargeBtn:FlxSprite,
					editorBtn:FlxSprite;
		
		public var buttons:FlxGroup;
		
		private var game:GameState;
		private var editor:EditorState;
		private var charge:ChargeState;
		private var targetState:FlxState;
		
		private var levelsUnlocked:Number;
		private var chargeUnlocked:Boolean;
		public var pan:Boolean;
		
		public function MenuState() {
			super();
			
			levelsUnlocked = 1;
			chargeUnlocked = true;
			
			editor = new EditorState();
			editor.level = Imports.getLevel("tmottbg");
			game = new GameState();
			charge = new ChargeState();
			pan = false;
		}
		override public function create():void {
			super.create();
			
			checkUnlocks();
			
			add(title = new FlxSprite(182, 48, TITLE));
			title.scale.x = title.scale.y = 2;
			// --- BUTTONS
			add(buttons = new FlxGroup(LEVELS.length + 1 + int(HAS_EDITOR)));
			
			LevelButton.ID_COUNT = 0;
			var btnLevel:LevelButton;
			var x:Number = (FlxG.stage.stageWidth - LVL_BTN_GAP * LEVELS.length) / 2;
			
			for (var i:int = 0; i < LEVELS.length; i++) {
				
				buttons.add( btnLevel = new LevelButton(
					x,
					LVL_BTN_Y,
					playLevel,
					levelsUnlocked > i ? 1 : .5
				));
				x += LVL_BTN_GAP;
			}
			buttons.add(chargeBtn = new FlxButton(200, LVL_BTN_Y+50, "Charge", chargeClick));
			if(HAS_EDITOR) buttons.add(editorBtn = new FlxButton(300, LVL_BTN_Y+50, "Editor", editorClick));
			
			FlxG.bgColor = 0xFFa4e4fc;
			if (pan && !FlxG.debug) startPanIn();
			
			FlxG.setDebuggerLayout(FlxG.DEBUGGER_LEFT);
			SoundManager.play("menu");
		}
		
		private function checkUnlocks():void {
			if (game.won)
				levelsUnlocked++;
		}
		private function startPanOut(nextState:FlxState):void {
			targetState = nextState;
			pan = true;
			if (!FlxG.debug) {
				
				removeButtonListeners();
				TweenMax.allTo([title].concat(buttons.members), 1, { y:"-350", ease:Cubic.easeIn, onComplete:panOutDone } );
			} else panOutDone();
		}
		
		private function panOutDone():void { FlxG.switchState(targetState); }
		private function startPanIn():void {
			TweenMax.allFrom([title].concat(buttons.members), 1, { y:"-350", ease:Cubic.easeOut } );
		}
		
		private function removeButtonListeners():void {
			buttons.setAll("onUp", null);
		}
		private function playLevel(ID:int):void {
			game.level = Imports.getLevel(LEVELS[ID]);
			game.won = false
			startPanOut(game);
		}
		private function chargeClick():void { startPanOut(charge); }
		
		private function editorClick():void {
			pan = false;
			FlxG.switchState(editor);
		}
		
		override public function destroy():void {
			super.destroy();
			title = chargeBtn = editorBtn = null;
			targetState = null;
			SoundManager.pause("menu");
			
		}
	}

}
import org.flixel.FlxButton;
class LevelButton extends FlxButton {
	
	[Embed(source="../../../res/sprites/1_ball.png")] static private const BALL_1:Class;
	[Embed(source="../../../res/sprites/2_ball.png")] static private const BALL_2:Class;
	[Embed(source="../../../res/sprites/3_ball.png")] static private const BALL_3:Class;
	[Embed(source="../../../res/sprites/4_ball.png")] static private const BALL_4:Class;
	[Embed(source="../../../res/sprites/5_ball.png")] static private const BALL_5:Class;
	[Embed(source="../../../res/sprites/6_ball.png")] static private const BALL_6:Class;
	[Embed(source="../../../res/sprites/7_ball.png")] static private const BALL_7:Class;
	[Embed(source="../../../res/sprites/8_ball.png")] static private const BALL_8:Class;
	[Embed(source="../../../res/sprites/9_ball.png")] static private const BALL_9:Class;
	
	static private const BALLS:Vector.<Class> = Vector.<Class>([BALL_1, BALL_2, BALL_3, BALL_4, BALL_5, BALL_6, BALL_7, BALL_8, BALL_9]);
	
	static public var ID_COUNT:int;
	
	private var level:String;
	private var panFunc:Function;
	private var onClick:Function;
	
	public function LevelButton(x:Number = 0, y:Number = 0, onClick:Function = null, alpha:Number = 1) {
		super(x, y, null, click);
		
		this.alpha = alpha;
		this.onClick = onClick;
		this.panFunc = panFunc;
		this.level = level;
		ID = ID_COUNT++;
		loadGraphic(BALLS[ID]);
	}
	
	private function click():void { if(alpha == 1) onClick(ID); }
	override public function destroy():void {
		super.destroy();
		
	}
}