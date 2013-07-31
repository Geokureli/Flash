package krakel {
	import greed.art.Gold;
	import krakel.helpers.StringHelper;
	import krakel.xml.XMLParser;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPath;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author George
	 */
	public class KrkLevel extends KrkState {
		
		static public const CLASS_REFS:Object = { KrkSprite:KrkSprite, text:KrkText };
		public var width:int, height:int;
		
		public var maps:Vector.<KrkTilemap>;
		
		public var resetGroup:KrkGroup,
					solidGroup:KrkGroup,
					overlapGroup:KrkGroup,
					cloudGroup:KrkGroup,
					antiCloudGroup:KrkGroup;
		
		public var gravity:Number;
		
		public var bounds:FlxRect;
		
		public var endLevel:Function;
		
		private var levelData:XML;
		
		private var _cloudsEnabled:Boolean;
		
		protected var groups:Object;
		protected var paths:Vector.<FlxPath>
		protected var links:Vector.<KrkSprite>
		
		protected var hud:HUD;
		
		public function KrkLevel() {
			super();
			
			groups = { };
			resetGroup = new KrkGroup();
			cloudGroup = new KrkGroup();
			solidGroup = new KrkGroup();
			overlapGroup = new KrkGroup();
			antiCloudGroup = new KrkGroup();
			
			maps = new <KrkTilemap>[];
			
			bounds = new FlxRect();
			
			width = height = 0;
			
			_cloudsEnabled = true;
			
		}
		
		public function setParameters(data:XML):void {
			this.levelData = data.copy();
			
			XMLParser.setProperties(this, data);
			
			checkPaths();
			initLinks();
			
			for each (var layer:XML in levelData.layer)
				createLayer(layer);
				
			if (maps.length == 1)
				solidGroup.add(maps[0]);
				
			addHUD();
			setLinks();
		}
		
		private function checkPaths():void {
			paths = new Vector.<FlxPath>();
			var path:FlxPath;
			for each(var pathData:XML in levelData..path) {
				if ("@type" in pathData) {
					path = new CLASS_REFS[pathData.@type.toString()]() as FlxPath;
				} else path = new FlxPath();
				for each(var node:XML in pathData.nodes[0].node)
					path.add(
						StringHelper.AutoTypeString(node.@x.toString()) as Number,
						StringHelper.AutoTypeString(node.@y.toString()) as Number
					)
				paths.push(path);
			}
		}
		
		private function initLinks():void {
			links = new <KrkSprite>[];
			if (levelData.links.length() == 0)
				return;
			
			var numLinks:int = 0;
			for each (var link:XML in levelData.links[0].link) {
				if (int(link.@from) > numLinks) numLinks = int(link.@from);
				if (int(link.@to) > numLinks) numLinks = int(link.@to);
			}
			while (links.length <= numLinks)
				links.push(null);
		}
		
		protected function createLayer(layer:XML):void {
			var name:String = layer.@name.toString();
			
			if (layer.sprite.length() > 0 || layer.shape.length() > 0) {
				var group:KrkGroup = new KrkGroup();
				var resets:Boolean = layer.@resets.toString() == "true";
				var exists:Boolean = layer.@exists.toString() != "false";
				
				for each (var node:XML in layer.sprite) {
					if (resets) node.@resets = true;
					if (!exists)
						node.@exists = false;
					group.add(parseSprite(node));
				}
				
				for each (node in layer.shape) {
					if(node.@type == "text")
					group.add(parseText(node));
				}
				
				if (name.charAt(0) == '@')
					this[name.substr(1)] = group;
				
				// --- IGNORE PATH GROUPS
				if(group.length > 0){
					add(group);
					groups[name] = group;
				}
				
			} else if (layer.path.length() > 0) {
				var pathGroup:PathDrawer = new PathDrawer()
				for each (var pathNode:XML in layer.path) {
					if(pathNode.@draw.toString() == "true")
						pathGroup.addPath(paths[int(pathNode.childIndex())]);
				}
				add(pathGroup);
			}
			
			var map:KrkTilemap;
			for each (node in layer.map) {
				add(map = createTileMap(node));
				maps.push(map);
				if (name.charAt(0) == '@')
					this[name.substr(1)] = map;
			}
		}
		
		protected function parseSprite(node:XML):FlxSprite {
			node = node.copy();
			
			var sprite:KrkSprite;
			if (node.@type.toString() in CLASS_REFS) {
				sprite = new CLASS_REFS[node.@type.toString()]();
			} else if (node.@type.toString() in KrkSprite.GRAPHICS) {
				sprite = new KrkSprite();
				node.@graphic = node.@type.toString();
			}
			
			if (!("type" in sprite)) delete node.@type;
			
			if ("@group" in node) {
				setGroup(sprite, node.@group.toString());
				delete node.@group;
			}
			if (node.@resets.toString() == "true") {
				resetGroup.add(sprite);
				delete node.@resets;
			}
			if (node.@passClouds == "true") {
				antiCloudGroup.add(sprite);
				delete node.@solid;
			}
			if (node.@cloud.toString() == "true") {
				cloudGroup.add(sprite);
				sprite.allowCollisions = FlxObject.CEILING;
				delete node.@cloud;
				node.@solid = true;
			}
			if (node.@solid.toString() == "true") {
				solidGroup.add(sprite);
				delete node.@solid;
				node.@collides = true;
			}
			if (node.@callback.toString() == "true") {
				overlapGroup.add(sprite);
			}
			
			if ("@group" in node) {
				setGroup(sprite, node.@group.toString())
				delete node.@group;
			}
			
			if ("@linkId" in node)
				links[int(node.@linkId)] = sprite;
			
			if ("@pathId" in node) {
				var path:FlxPath = paths[int(node.@pathId)];
				var pathMode:uint = FlxObject.PATH_LOOP_FORWARD;
				var pathSpeed:Number = 30;
				if ("@pathMode" in node) {
					pathMode = StringHelper.AutoTypeString(node.@pathMode.toString()) as uint;
					delete node.@pathMode;
				}
				if ("@pathSpeed" in node) {
					pathSpeed = StringHelper.AutoTypeString(node.@pathSpeed.toString()) as uint;
					delete node.@pathSpeed;
				}
				sprite.followPath(path, pathSpeed, pathMode);
				delete node.@pathId;
			}
			
			if (Number(node.@xScale) == 1)
				delete node.@xScale;
			
			if (Number(node.@yScale) == 1)
				delete node.@yScale;
			
			if (sprite.falls || node.@falls.toString() == "true")
				sprite.acceleration.y = gravity;
			
			if (sprite is KrkSprite)
				(sprite as KrkSprite).setParameters(node);
			else XMLParser.setProperties(sprite, node);
			
			return sprite;
		}
		
		private function parseText(node:XML):FlxText {
			var txt:FlxText = new FlxText(
				Number(node.@x),
				Number(node.@y),
				Number(node.@width),
				node.@text.toString()
			);
			txt.alignment = node.@align.toString()
			return txt;
		}
		
		private function setGroup(sprite:FlxSprite, group:String):void {
			if (!(group in groups)) groups[group] = new KrkGroup();
			groups[group].add(sprite);
		}
		
		protected function createTileMap(mapData:XML):KrkTilemap {		
			
			var map:KrkTilemap = new KrkTilemap(mapData);
			
			if (map.width > width) width = map.width;
			if (map.height > height) height = map.height;
			return map;
		}
		
		protected function addHUD():void { add(hud = new HUD()); }
		
		private function setLinks():void {
			if (levelData.links.length() == 0)
				return;
			
			for each(var link:XML in levelData.links[0].link)
				links[int(link.@from)].links.push(links[int(link.@to)]);
		}
		
		// --- --- --- --- EVENTS --- --- --- --- 
		
		override public function preUpdate():void {
			super.preUpdate();
		}
		
		override public function update():void {
			
			checkCollisions();
			
			super.update();
		}
		
		protected function checkCollisions():void {
			
			FlxG.collide(antiCloudGroup, solidGroup,  hitSolidSprite);
			
			if (!_cloudsEnabled)
				cloudsEnabled = true;
			
			FlxG.collide(solidGroup, solidGroup, hitSolidSprite);
			
			if (!_cloudsEnabled)
				cloudsEnabled = false;
			
			FlxG.overlap(overlapGroup, overlapGroup, hitSprite, processHit);
		}
		
		protected function hitSolidSprite(obj1:FlxObject, obj2:FlxObject):void {
			
			if (
				(obj1.immovable || obj2.immovable)
				&& obj1 is KrkSprite && (obj1 as KrkSprite).callback
				&& obj2 is KrkSprite && (obj2 as KrkSprite).callback
				&& processHit(obj1 as KrkSprite, obj2 as KrkSprite)
			)
				hitSprite(obj1 as KrkSprite, obj2 as KrkSprite);
		}
		
		protected function processHit(obj1:KrkSprite, obj2:KrkSprite):Boolean {
			return obj1.checkHit(obj2) && obj2.checkHit(obj1);
		}
		
		protected function hitSprite(obj1:KrkSprite, obj2:KrkSprite):void {
			if (obj1.alive && obj1.action != null) 
				parseActions(obj1.action);
			
			if (obj2.alive && obj2.action != null) 
				parseActions(obj2.action);
			
			obj1.hitObject(obj2);
			obj2.hitObject(obj1);
		}
				
		public function parseActions(actions:String):void {
			var actionList:Array = actions.split(/\s*;\s*/);
			var args:Array;
			var target:FlxBasic;
			
			for each (var action:String in actionList) {
				
				args = action.split(/\s*:\s*/);
				if (args[0] != "this") {
					
					target = groups[args[0]];
					
					if (/\(\)$/.test(args[1]))
						target[args[1].substring(0, args[1].length-2)]();
				}
			}
		}
		
		protected function reset():void {
			
			for each(var obj:FlxObject in resetGroup.members) {
				if (obj != null) {
					obj.revive();
					if (obj is KrkSprite && (obj as KrkSprite).data.@exists.toString() == "false")
						obj.kill();
				}
				
			}
			
		}
		
		override public function destroy():void {
			super.destroy();
			
			maps = null;
			
			endLevel = null;
			levelData = null;
		}
		
		public function get cloudsEnabled():Boolean { return _cloudsEnabled; }
		
		public function set cloudsEnabled(value:Boolean):void {
			_cloudsEnabled = value;
			
			for each(var map:KrkTilemap in maps)
				map.cloudsEnabled = value;
			
			cloudGroup.setAll("allowCollisions", value ? FlxObject.CEILING : FlxObject.NONE);
 		}
	}

}
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPath;
class PathDrawer extends FlxGroup {
	public var paths:Vector.<FlxPath>;
	public function PathDrawer():void {
		paths = new <FlxPath>[];
	}
	public function addPath(path:FlxPath):void {
		paths.push(path);
	}
	override public function draw():void {
		super.draw();
		for each (var path:FlxPath in paths)
			path.drawDebug(FlxG.camera);
	}
}