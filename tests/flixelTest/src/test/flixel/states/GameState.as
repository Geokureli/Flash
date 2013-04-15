package test.flixel.states {
	import flash.geom.Point;
	import org.flixel.FlxCamera;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	import org.flixel.system.input.Keyboard;
	import test.flixel.art.Hero;
	import test.flixel.art.TileMap;
	import test.flixel.Imports;
	
	/**
	 * ...
	 * @author George
	 */
	public class GameState extends FlxState {
		
		private var hero:Hero;
		
		private var tileMap:TileMap;
		
		public function GameState() { super(); }
		override public function create():void {
			super.create();
			
			FlxG.bgColor = 0xFFFFFFFF;
			
			add(hero = new Hero());
			
			add(tileMap = new TileMap());
			
			//cam.zoom = 2;
			FlxG.worldBounds.width = TileMap.TILES.x * 16;
			FlxG.worldBounds.height = TileMap.TILES.y * 16;
			cam.follow(hero, FlxCamera.STYLE_PLATFORMER);
			cam.bounds = new FlxRect(0, 0, FlxG.worldBounds.width/2, FlxG.worldBounds.height/2);
		}
		
		override public function update():void {
			super.update();
			FlxG.collide(hero, tileMap, onCollision);
			if (FlxG.mouse.pressed()){
				if (keys.CONTROL)
					tileMap.setTile(tileX, tileY, 0);
				else if (keys.SPACE)
					tileMap.setTile(tileX, tileY, 2);
				else if(keys.SHIFT)
					tileMap.setTile(tileX, tileY, 3);
				else 
					tileMap.setTile(tileX, tileY, 1);
			}
		}
		
		private function onCollision(hero:Hero, map:FlxTilemap):void {
			var tilePos:FlxPoint = new FlxPoint(0, 0);
			var tileSize:FlxPoint = new FlxPoint(
				tileMap.width / tileMap.widthInTiles,
				tileMap.height / tileMap.heightInTiles
			);
			tilePos.x = hero.x > hero.last.x ? hero.right+tileSize.x*2 : hero.x-tileSize.x*2;
			tilePos.y = hero.y > hero.last.y ? hero.bottom+tileSize.y*2 : hero.y-tileSize.y*2;
			
			tilePos.x /= tileSize.x;
			tilePos.y /= tileSize.y;
			
			var tile:uint = map.getTile(int(tilePos.x), int(tilePos.y));
			//trace(tile, int(tilePos.x), int(tilePos.y)+1);
			//map.setTileProperties()
		}
		
		
		
		public function get tileX():int { return (FlxG.mouse.screenX + cam.scroll.x) / tileMap.width * tileMap.widthInTiles; }
		public function get tileY():int { return (FlxG.mouse.screenY + cam.scroll.y) / tileMap.height * tileMap.heightInTiles; }
		
		override public function destroy():void {
			super.destroy();
			hero = null;
		}
		public function get cam():FlxCamera { return FlxG.camera; }
		public function get keys():Keyboard { return FlxG.keys; }
	}

}