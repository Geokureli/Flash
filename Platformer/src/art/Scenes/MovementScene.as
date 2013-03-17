package art.Scenes 
{
	import relic.art.Asset;
	import relic.art.Scene;
	import relic.data.shapes.Box;
	import relic.data.BoundMode;
	import relic.data.Vec2;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author George
	 */
	public class MovementScene extends Scene 
	{
		private var hero:Asset;
		static private const speed:int = 1;
		public function MovementScene() { super(); }
		override protected function addStaticChildren():void 
		{
			super.addStaticChildren();
			hero = new Asset();
			hero.friction = 1;
			hero.shape = new Box(0, 0, 50, 50);
			hero.shape.debugDraw(hero.graphics);
			hero.boundMode = BoundMode.LOCK;
			addChild(hero);
		}
		override protected function init(e:Event = null):void 
		{
			super.init(e);
			hero.bounds.width = stage.stageWidth;
			hero.bounds.height = stage.stageHeight-200;
			hero.friction = 0;// .05;
			hero.x = (stage.stageWidth - hero.width) / 2;
			hero.y = (stage.stageHeight - hero.height - 100) / 2;
		}
		override public function update():void 
		{
			super.update();
			hero.acc.x = hero.acc.y = 0;
			if (right) hero.acc.x = speed;
			if (left) hero.acc.x = -speed;
			if (up) hero.acc.y = -speed;
			if (down) hero.acc.y = speed;
			hero.update();
			var pos:Vec2 = new Vec2(hero.x+(hero.shape as Box).height/2, hero.y+(hero.shape as Box).width/2);
			graphics.clear();
			if(hero.acc.length2 > 0)
				drawArrow(pos, pos.sum(hero.acc.scale(10)), 0xFF00);
			if(hero.vel.length2 > 0)
				drawArrow(pos, pos.sum(hero.vel.scale(10)), 0xFF0000);
		}
	}
}