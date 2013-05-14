package greed.levels {
	import greed.art.Button;
	import greed.art.CallbackTile;
	import greed.art.Door;
	import greed.art.Gold;
	import greed.art.Hero;
	import greed.art.Treasure;
	import greed.tiles.FadeTile;
	import krakel.helpers.StringHelper;
	import krakel.KrkLevel;
	import krakel.KrkSprite;
	import krakel.KrkText;
	import krakel.KrkTile;
	import krakel.KrkTilemap;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
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
			CLASS_REFS.Avatar = Hero;
			
			//CLASS_REFS.flipScheme = TileScheme;
			
			//CLASS_REFS.Arrow = Arrow;
			//CLASS_REFS.HoldSign = HoldSign;
			
			KrkTilemap.TILE_TYPES.spring = CallbackTile;
			//KrkTilemap.TILE_TYPES.button = Button;
			KrkTilemap.TILE_TYPES.ladder = CallbackTile;
			KrkTilemap.TILE_TYPES.fade = FadeTile;
		}
		
		protected var hero:Hero;
		protected var buttonsLeft:int;
		
		protected var isThief:Boolean,
					gameOver:Boolean;
		
		public var endLevel:Function;
		
		public var totalCoins:uint,
					totalTreasure:uint;
					
		private var _coins:uint,
					_treasure:uint;
		
		public var name:String;
		
		public function GreedLevel(levelData:XML, csv:Class = null, tiles:Class = null) {
			buttonsLeft = 0;
			coins = 0;
			super(levelData, csv, tiles);
			gameOver = false;
		}
		
		override protected function createLayer(layer:XML):void {
			if (layer.sprite.(@type.toString() == "Avatar").length() > 0) {
				var heroNode:XML = layer.sprite.(@type.toString() == "Avatar")[0];
				add(hero = new Hero(Number(heroNode.@x), Number(heroNode.@y)));
				FlxG.camera.follow(hero);
				delete layer.sprite.(@type.toString() == "Avatar")[0];
			}
			super.createLayer(layer);
		}
		override protected function parseSprite(node:XML):FlxSprite {
			var sprite:FlxSprite = super.parseSprite(node);
			
			if (sprite is Button) buttonsLeft++;
			if (sprite is Treasure) {
				sprite.play(Treasure.ORDER[totalTreasure]);
				totalTreasure++;
			}
			else if (sprite is Gold) totalCoins++;
			
			if (node.@recenter.toString() == "true") {
				sprite.x += sprite.offset.x;
				sprite.y += sprite.offset.y;
			}
			
			return sprite;
		}
		
		override public function preUpdate():void {
			super.preUpdate();
			cloudsEnabled = !hero.jumpScheme.d;
		}
		
		override public function update():void {
			super.update();
			FlxG.collide(hero, solidGroup);
			FlxG.overlap(hero, overlapGroup, hitSprite);
		}
		override public function postUpdate():void {
			super.postUpdate();
			if (FlxG.keys.justReleased("R"))
				hero.kill();
			
			if (!hero.alive || !hero.onScreen(FlxG.camera)) reset();
			if (gameOver) endLevel();
		}
		protected function hitSprite(hero:Hero, obj:FlxSprite):void {
			//if (this.hero == null) {
				// --- QUICK BUG FIXER
				//trace("hitsprite");
				//return;
			//}
			if (obj is Button && (obj as Button).state == "up") {
				groups[(obj as Button).target].kill()
			} else if (obj is Door && isLevelComplete) {
				gameOver = true;
			} else if (obj is Gold) {
				isThief = true;
				if (obj is Treasure) treasure++;
				else coins++;
			}
			
			hero.hitObject(obj);
		}
		
		private function get isLevelComplete():Boolean {
			return hero.isTouching(FlxObject.FLOOR) && (
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
			
			map.revive();
			
			coins = 0;
			treasure = 0;
			hero.revive();
			isThief = false;
		}
		
		override public function destroy():void {
			trace("destroy");
			super.destroy();
			
			endLevel = null;
			hero = null;
		}
		
		public function get coins():int { return _coins; }
		public function set coins(value:int):void { _coins = value; }
		
		public function get treasure():uint { return _treasure; }
		public function set treasure(value:uint):void { _treasure = value; }
		
		override public function toString():String {
			if(name == null)
				return super.toString();
			return name;
		}
	}

}