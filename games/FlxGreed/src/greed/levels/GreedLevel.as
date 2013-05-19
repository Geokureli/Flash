package greed.levels {
	import greed.art.Button;
	import greed.art.CallbackTile;
	import greed.art.Door;
	import greed.art.Gold;
	import greed.art.Hero;
	import greed.art.Treasure;
	import greed.art.WeightForm;
	import greed.tiles.FadeTile;
	import krakel.helpers.StringHelper;
	import krakel.KrkLevel;
	import krakel.KrkSprite;
	import krakel.KrkText;
	import krakel.KrkTile;
	import krakel.KrkTilemap;
	import krakel.Trigger;
	import org.flixel.FlxBasic;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author George
	 */
	public class GreedLevel extends KrkLevel {
		{
			CLASS_REFS.Gold = Gold;
			CLASS_REFS.Treasure = Treasure;
			CLASS_REFS.Door = Door;
			CLASS_REFS.Button = Button;
			CLASS_REFS.hero = Hero;
			CLASS_REFS.weightForm = WeightForm;
			
			//CLASS_REFS.flipScheme = TileScheme;
			
			//CLASS_REFS.Arrow = Arrow;
			//CLASS_REFS.HoldSign = HoldSign;
			
			KrkTilemap.TILE_TYPES.spring = CallbackTile;
			//KrkTilemap.TILE_TYPES.button = Button;
			KrkTilemap.TILE_TYPES.ladder = CallbackTile;
			KrkTilemap.TILE_TYPES.fade = FadeTile;
		}
		
		protected var _hero:Hero;
		protected var buttonsLeft:int;
		
		protected var isThief:Boolean,
					gameOver:Boolean,
					cameraSet:Boolean;
		
		public var endLevel:Function;
		
		public var totalCoins:uint,
					totalTreasure:uint;
		
		private var _coins:uint,
					_treasure:uint;
		
		public var name:String;
		
		public function GreedLevel(csv:String, tiles:Class) {
			buttonsLeft = 
				coins = 0;
			
			super(csv, tiles);
			gameOver = false;
			cameraSet = false;
		}
		
		override protected function createLayer(layer:XML):void {
			super.createLayer(layer);
		}
		override protected function parseSprite(node:XML):FlxSprite {
			var sprite:FlxSprite = super.parseSprite(node);
			
			if (sprite is Hero) {
				FlxG.camera.follow(_hero = sprite as Hero);
				var w:Number = 32;
				var h:Number = FlxG.height/3;
				FlxG.camera.deadzone = new FlxRect((FlxG.width-w)/2,(FlxG.height-h)/2 - h*0.25,w,h);
			}
			if (sprite is Button) buttonsLeft++;
			if (sprite is Treasure) {
				sprite.play(Treasure.ORDER[totalTreasure]);
				totalTreasure++;
			} else if (sprite is Gold) totalCoins++;
			
			return sprite;
		}
		
		override public function preUpdate():void {
			super.preUpdate();
			cloudsEnabled = !_hero.jumpScheme.d;
		}
		
		override public function postUpdate():void {
			super.postUpdate();
			if (FlxG.keys.justReleased("R"))
				_hero.kill();
			
			if (!cameraSet && _hero.onScreen(FlxG.camera)) cameraSet = true;
			if (!_hero.alive || (!_hero.onScreen(FlxG.camera) && cameraSet)) reset();
			if (gameOver && endLevel != null) endLevel();
		}
		override protected function hitSprite(obj1:KrkSprite, obj2:KrkSprite):void {
			super.hitSprite(obj1, obj2);
			
			if (obj2 is Door && isLevelComplete) {
				gameOver = true;
			} else if (obj2 is Gold) {
				isThief = true;
				if (obj2 is Treasure) treasure++;
				else coins++;
			}
		}
		
		override public function hitTrigger(trigger:Trigger, collider:FlxObject):void {
			if (!(trigger is Button) && trigger.alive)
				trigger.bounce(-16);
			super.hitTrigger(trigger, collider);
		}
		
		
		private function get isLevelComplete():Boolean {
			return _hero.isTouching(FlxObject.FLOOR) && (
				(isThief && treasure == totalTreasure) || !isThief
			);
		}
		
		override protected function reset():void {
			super.reset();
			//var obj:FlxBasic;
			//for each(obj in overlapGroup.members)
				//if (!obj.alive) {
					//obj.revive();
					//if (obj is Button) buttonsLeft++;
				//}
			cameraSet = false;
			map.revive();
			
			coins = 0;
			treasure = 0;
			_hero.revive();
			isThief = false;
		}
		
		override public function destroy():void {
			trace("destroy");
			super.destroy();
			
			FlxG.camera.follow(null);
			
			endLevel = null;
			_hero = null;
		}
		
		public function get coins():int { return _coins; }
		public function set coins(value:int):void { _coins = value; }
		
		public function get treasure():uint { return _treasure; }
		public function set treasure(value:uint):void { _treasure = value; }
		
		public function get map():KrkTilemap { return maps[0]; }
		
		override public function toString():String {
			if(name == null)
				return super.toString();
			return name;
		}
	}

}