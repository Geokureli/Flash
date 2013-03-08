package art.Scenes 
{
	import art.Asset;
	import art.Bomb;
	import art.Scene;
	import art.ScrollingBG;
	import art.SpriteSheet;
	import data.shapes.Box;
	import data.Vec2;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author George
	 */
	public class GameScene extends Scene
	{
		
		
		private var hero:Hero;
		private var bg:ScrollingBG;
		private var scrollSpeed:Number;
		private var bomb:Bomb;
		
		public function GameScene() {
			super();
			//trace((164).toString(16), (228).toString(16), (252).toString(16)); // --- A4E4FC
		}
		
		override protected function addStaticChildren():void 
		{
			super.addStaticChildren();
			var bgSheet:SpriteSheet = new SpriteSheet(new Imports.Ground().bitmapData);
			bgSheet.createGrid(64, 64);
			bg = new ScrollingBG(800, 64, false);
			bg.tile = bgSheet.frames[0];
			bg.y = 280+64;
			addChild(bg);
			
			hero = new Hero();
			addChild(hero);
			addChild(bomb = new Bomb());
			bomb.y = 200;
		}
		override protected function init(e:Event = null):void 
		{
			super.init(e);
			scrollSpeed = stage.stageWidth / 3000;
			
		}
		override protected function enterFrame(e:Event):void 
		{
			super.enterFrame(e);
			hero.u = up;
			hero.d = down;
			hero.l = left;
			hero.r = right;
			hero.update();
			bg.pos = -getTimer() * scrollSpeed;
			bomb.x = 100;// stage.stageWidth - getTimer() * scrollSpeed;
			bg.update();
			bomb.update();
		}
		
	}

}
import art.Asset;
import art.SpriteSheet;
import data.AnimationEvent;
import data.BoundMode;
import data.shapes.Box;
import flash.events.Event;
class Hero extends Asset {
	static private var sheet:SpriteSheet;
	{
		sheet = new SpriteSheet(new Imports.Hero().bitmapData);
		sheet.clearBG();
		sheet.createGrid(64, 64);
		sheet.addAnimation("idle", Vector.<int>([0, 1, 2, 3, 4, 5, 6, 7]));
		sheet.addAnimation("duck", Vector.<int>([8, 9, 9, 9, 9, 9, 9, 8]));
		sheet.addAnimation("slide", Vector.<int>([10, 11, 11, 11, 11, 11, 11, 10]));
		sheet.addAnimation("jump", Vector.<int>([12, 12, 12, 12, 12, 12, 12, 12]));
		sheet.addAnimation("swing", Vector.<int>([13, 14, 15, 16, 17]));
		sheet.addAnimation("hit", Vector.<int>([8, 9]), false);
	}
	public var u:Boolean, d:Boolean, l:Boolean, r:Boolean;
	public function Hero() {
		super();
		friction = .05;
		shape = new Box(0, 0, 64, 64);
		//shape.debugDraw(graphics);
		//boundMode = BoundMode.LOCK;
		addAnimationSet(sheet);
	}
	override protected function init(e:Event):void 
	{
		super.init(e);
	
		currentAnimation = "idle";
		bounds.width = stage.stageWidth;
		bounds.height = stage.stageHeight;
		x = 100;
		y = 250+64;
	}
	override public function update():void {
		super.update();
		if (currentAnimation == "idle") {
			if (d) {
				currentAnimation = "duck";
				addEventListener(AnimationEvent.COMPLETE, animEnd);
			}
			if (u) {
				currentAnimation = "jump";
				addEventListener(AnimationEvent.COMPLETE, animEnd);
			}
			if (l) {
				currentAnimation = "swing";
				addEventListener(AnimationEvent.COMPLETE, animEnd);
			}
			
			if (r) {
				currentAnimation = "slide";
				addEventListener(AnimationEvent.COMPLETE, animEnd);
			}
		}
	}
	
	private function animEnd(e:AnimationEvent):void 
	{
		removeEventListener(AnimationEvent.COMPLETE, animEnd);
		currentAnimation = "idle";
	}
}