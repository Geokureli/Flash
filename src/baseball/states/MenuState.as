package baseball.states {
	import baseball.Imports;
	import baseball.states.editor.EditorState;
	import baseball.states.play.ChargeState;
	import baseball.states.play.GameState;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import krakel.ads.AdBox;
	import krakel.audio.SoundManager;
	import krakel.KrkButtonGroup;
	import krakel.KrkSound;
	import krakel.KrkState;
	import mochi.as3.MochiAd;
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
		
		[Embed(source = "../../../res/baseball/sprites/ts_gfx.png")] static private const TITLE:Class;
		[Embed(source="../../../res/baseball/sprites/Charge_txt.png")] static private var CHARGE_TXT:Class;
		
		static private const LEVELS:Vector.<String> = Vector.<String>(["tmottbg", "test", "test", "test"]);
		
		static private const LVL_BTN_Y:Number = 234;
		static private const HAS_EDITOR:Boolean = FlxG.debug;
		static private const LVL_BTN_GAP:Number = 50;
		
		static public var CHARGE_UNLOCKED:Boolean = true;
		
		public var title:FlxSprite,
					chargeBtn:FlxButton,
					editorBtn:FlxButton;
		
		public var buttons:KrkButtonGroup;
		
		private var game:GameState;
		private var editor:EditorState;
		private var charge:ChargeState;
		private var targetState:FlxState;
		
		private var levelsUnlocked:Number;
		private var chargeUnlocked:Boolean;
		public var isFromLevel:Boolean;
		
		public function MenuState() {
			super();
			
			levelsUnlocked = 1;
			chargeUnlocked = true;
			
			editor = new EditorState();
			editor.level = Imports.getLevel("tmottbg");
			game = new GameState();
			charge = new ChargeState();
			isFromLevel = false;
		}
		override public function create():void {
			super.create();
			
			checkUnlocks();
			
			add(title = new FlxSprite(182, 48, TITLE));
			title.scale.x = title.scale.y = 2;
			// --- BUTTONS
			add(buttons = new KrkButtonGroup());
			
			LevelButton.ID_COUNT = 0;
			var btnLevel:LevelButton;
			var x:Number = (FlxG.stage.stageWidth - LVL_BTN_GAP * LEVELS.length) / 2;
			
			for (var i:int = 0; i < LEVELS.length; i++) {
				
				buttons.addButton( btnLevel = new LevelButton(
					x,
					LVL_BTN_Y,
					playLevel,
					levelsUnlocked > i || FlxG.debug ? 1 : .5
				));
				x += LVL_BTN_GAP;
			}
			buttons.addButton(chargeBtn = new FlxButton(260, LVL_BTN_Y + 35, null, chargeClick), 1);
			chargeBtn.loadGraphic(CHARGE_TXT);
			chargeBtn.scale.x = 2;
			// --- EDITOR
			if (HAS_EDITOR)
				buttons.addButton(editorBtn = new FlxButton(250, LVL_BTN_Y + 75, "Editor", editorClick), 2);
			
			FlxG.bgColor = 0xFFa4e4fc;
			
			if (isFromLevel && !FlxG.debug)
				showAd();
			else if(!FlxG.debug)
				startPanIn();
			else if (KrkSound.enabled)
				playMusic();
		}
		
		private function showAd():void {
			exists =
				title.exists =
				buttons.exists = false;
			AdBox.showInterLevelAd(startPanIn);
		}
		
		private function checkUnlocks():void {
			if (game.won){
				levelsUnlocked++;
				AdBox.submitScore("levelsCleared", levelsUnlocked);
			}
		}
		
		private function startPanIn():void {
			TweenMax.allFrom([title].concat(buttons.members), 1, { y:"-350", ease:Cubic.easeOut } );
			exists =
				title.exists =
				buttons.exists = true;
			playMusic();
		}
		
		private function playMusic():void {
			FlxG.playMusic(Imports.getSong("menu"));
			FlxG.music.survive = false;
		}
		
		private function startPanOut(nextState:FlxState):void {
			targetState = nextState;
			isFromLevel = true;
			if (!FlxG.debug) {
				removeButtonListeners();
				TweenMax.allTo([title].concat(buttons.members), 1, { y:"-350", ease:Cubic.easeIn, onComplete:panOutDone } );
			} else panOutDone();
		}
		
		private function panOutDone():void { FlxG.switchState(targetState); }
		
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
			isFromLevel = false;
			FlxG.switchState(editor);
		}
		
		override public function destroy():void {
			super.destroy();
			title = chargeBtn = editorBtn = null;
			targetState = null;
			FlxG
			
		}
	}

}
import org.flixel.FlxButton;
class LevelButton extends FlxButton {
	
	[Embed(source="../../../res/baseball/sprites/1_ball.png")] static private const BALL_1:Class;
	[Embed(source="../../../res/baseball/sprites/2_ball.png")] static private const BALL_2:Class;
	[Embed(source="../../../res/baseball/sprites/3_ball.png")] static private const BALL_3:Class;
	[Embed(source="../../../res/baseball/sprites/4_ball.png")] static private const BALL_4:Class;
	[Embed(source="../../../res/baseball/sprites/5_ball.png")] static private const BALL_5:Class;
	[Embed(source="../../../res/baseball/sprites/6_ball.png")] static private const BALL_6:Class;
	[Embed(source="../../../res/baseball/sprites/7_ball.png")] static private const BALL_7:Class;
	[Embed(source="../../../res/baseball/sprites/8_ball.png")] static private const BALL_8:Class;
	[Embed(source="../../../res/baseball/sprites/9_ball.png")] static private const BALL_9:Class;
	
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