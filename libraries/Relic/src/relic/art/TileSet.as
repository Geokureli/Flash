package relic.art {
	import flash.geom.Point;
	import relic.Asset;
	import relic.collision.CollisionData;
	import relic.helpers.StringHelper;
	import relic.shapes.Box;
	import relic.shapes.Shape;
	import relic.StretchMode;
	import relic.Vec2;
	import relic.xml.IXMLParam;
	
	/**
	 * ...
	 * @author George
	 */
	public class TileSet extends Asset {
		
		private var shapes:Vector.<Shape>;
		private var tileDefs:Object;
		private var tiles:Vector.<Vector.<Tile>>;
		
		public function TileSet(graphic:ITileSet = null) { super(graphic); }
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			
			graphic.stretchMode = StretchMode.TILE;
			
			moves = false;
			
		}
		override public function setParameters(params:Object):IXMLParam {
			super.setParameters(params);
			if (params is XML) {
				var def:TileDef;
				var frames:Object;
				
				if (params.tileDefs.length() > 0) {
					
					tileDefs = { };
					shape = new Box(0, 0, graphic.width / columns, graphic.height / rows);
					for each (var node:XML in params.tileDefs[0].tileDef) {
						def = new TileDef();
						tileDefs[node.@ref.toString()] = def;
						
						// --- TILE COLLISION
						if ("@solid" in node && node.@solid.toString() == "true")
							def.shape = shape;
						// --- TILE ANIMATIONS
						if ("@frames" in node) {
							def.animations = StringHelper.AutoTypeString(node.@frames.toString());
						}
						
					}
					//shape = null;
				}
				if (params.tiles.length() > 0) {
					tiles = new Vector.<Vector.<Tile>>();
					var i:int = 0;
					rows = params.tiles[0].row.length();
					trace(params.tiles[0].row[0].toString());
					columns = params.tiles[0].row[0].toString().length;
					
					for each(var row:XML in params.tiles[0].row) {
						tiles.push(new Vector.<Tile>);
						
						for (var j:int = 0; j < row.toString().length; j++)
							tiles[i].push(createTile(row.toString().charAt(j)));
						
						i++;
					}
					
					setTileFrames();
				}
				
			}
			return this;
		}
		
		private function setTileFrames():void {
			trace(rows, columns);
			graphic.tileMap = [];
			
			for (var row:String in tiles) {
				graphic.tileMap.push([]);
				
				for each(var tile:Tile in tiles[row]) {
					
					graphic.tileMap[row].push(tile.frame);
				}
				
			}
			
		}
		
		private function createTile(ref:String):Tile {
			if (ref in tileDefs)
				return tileDefs[ref].createTile();
				
			return null;
		}
		override public function update():void {
			super.update();
		}
		
		override public function draw():void {
			super.draw();
			// --- THIS IS A SHITTY WAY OF DOING IT BUT ITS FOR DEBUG SO WHATEVER
			if (DEBUG_DRAW || debugDraw && graphic != null) {
				var p:Point = new Point(x, y);
				for (var c:int = 0; c < columns; c++ ) {
					for (var r:int = 0; r < rows; r++) {
						
						if (tiles[c][r].shape != null){
							
							p.x = x + c * width / columns;
							p.y = y + r * height / rows;
							graphic.drawRect(p);
						}
					}
				}
			}
		}
		
		override public function isTouching(asset:Asset):CollisionData {
			if (asset.shape == null) return null;
			var collisions:Vector.<CollisionData> = new Vector.<CollisionData>();
			var data:CollisionData;
			var left:int = asset.left / tileWidth;
			var top:int = asset.top / tileHeight;
			var right:int = asset.right / tileWidth;
			var bottom:int = asset.bottom / tileHeight;
			
			if (right >= columns) right = columns - 1;
			if (bottom >= rows) bottom = rows - 1;
			
			for (var x:int = left; x <= right; x++) {
				for (var y:int = top; y <= bottom; y++) {
					if (tileShape(x, y) != null) {
						data = tileShape(x, y).hitShape(
							new Vec2(
								asset.left - x*tileWidth,
								asset.top - y*tileHeight
							),
							asset.shape
						);
						if (data != null) {
							data.attacker = this;
							data.victim = asset;
							
							collisions.push(data);
						}
					}
				}
			}
			return data;
		}
		
		public function getTile(column:int, row:int):Tile { return tiles[column][row]; }
		public function tileShape(column:int, row:int):Shape { return getTile(column, row).shape; }
		public function tileAt(x:Number, y:Number):Tile {
			if (x > width || x < 0 || y > height || y < 0)
				return null;
			return getTile(x / tileWidth, y / tileHeight);
		}
		public function tileShapeAt(x:Number, y:Number):Shape { return tileAt(x, y).shape; }
		
		public function get tileGraphic():ITileSet { return graphic as ITileSet; }
		
		public function get tileWidth():Number { return tileGraphic.tileSize.x; }
		public function get tileHeight():Number { return tileGraphic.tileSize.y; }
	}

}
import flash.events.EventDispatcher;
import relic.art.blitting.AnimatedBlit;
import relic.art.blitting.Animation;
import relic.art.blitting.Blit;
import relic.shapes.Shape;
import relic.xml.IXMLParam;
import relic.xml.XMLParser;
class TileDef extends EventDispatcher implements IXMLParam {
	
	private var _animations:Object;
	public var shape:Shape;
	
	public function TileDef() {
		_animations = { };
	}
	
	public function setParameters(params:Object):IXMLParam {
		if (params is XML) XMLParser.setProperties(this, params as XML);
		return this;
	}
	public function createTile():Tile {
		var tile:Tile = new Tile(animations as int);
		tile.shape = shape;
		return tile;
	}
	
	public function get animations():Object {
		return _animations["idle"][0];
	}
	
	public function set animations(value:Object):void {
		// --- SET SINGLE FRAME
		//if (value is Number)
			_animations["idle"] = [value];
		// --- SET SINGLE ANIMATION
		//else if (frames is Array)
			//_animations["idle"] = { idle:new Animation(null, value) };
		// --- SET ALL ANIMATIONS
		//else if (frames is Object) {
			//_animations = frames;
		//}
	}
}
class Tile {
	public var frame:int;
	public var shape:Shape;
	
	public function Tile(frame:int) {
		this.frame = frame;
	}
}