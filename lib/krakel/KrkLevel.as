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
		
		static public const CLASS_REFS:Object = { KrkSprite:KrkSprite, text:KrkText, Trigger:Trigger };
		public var width:int, height:int;
		
		public var maps:Vector.<KrkTilemap>;
		
		public var resetGroup:KrkGroup,
					solidGroup:KrkGroup,
					overlapGroup:KrkGroup,
					cloudGroup:KrkGroup,
					antiCloudGroup:KrkGroup;
		
		public var gravity:Number;
		
		public var bounds:FlxRect;
		
		private var levelData:XML;
		private var csv:String;
		private var tiles:Class;
		
		private var _cloudsEnabled:Boolean;
		
		protected var groups:Object;
		protected var paths:Vector.<FlxPath>
		
		protected var hud:HUD;
		
		public function KrkLevel(csv:String, tiles:Class) {
			super();
			
			//this.levelData = levelData.copy();
			this.csv = csv;
			this.tiles = tiles;
			
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
			
			checkPaths()
			
			for each (var layer:XML in levelData.layer)
				createLayer(layer);
				
			if (maps.length == 1)
				solidGroup.add(maps[0]);
				
			addHUD();
		}
		
		private function checkPaths():void {
			paths = new Vector.<FlxPath>();
			var path:FlxPath;
			for each(var pathData:XML in levelData..path) {
				path = new FlxPath();
				for each(var node:XML in pathData.nodes[0].node)
					path.add(
						StringHelper.AutoTypeString(node.@x.toString()) as Number,
						StringHelper.AutoTypeString(node.@y.toString()) as Number
					)
				paths.push(path);
			}
		}
		
		protected function createLayer(layer:XML):void {
			var name:String = layer.@name.toString();
			
			if (layer.sprite.length() > 0 || layer.shape.length() > 0) {
				var group:KrkGroup = new KrkGroup();
				
				for each (var node:XML in layer.sprite)
					group.add(parseSprite(node));
				
				for each (node in layer.shape) {
					if(node.@type == "text")
					group.add(parseText(node));
				}
				
				if (name.charAt(0) == '@')
					this[name.substr(1)] = group;
				
				// --- IGNORE PATH GROUPS
				if(group.length > 0)
					add(group);
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
			
			var sprite:KrkSprite = new CLASS_REFS[node.@type.toString()]();
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
			
			if ("@pathId" in node) {
				sprite.followPath(paths[int(node.@pathId)], 30, FlxObject.PATH_LOOP_FORWARD);
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
			var map:KrkTilemap = new KrkTilemap(mapData, csv, tiles);
			
			if (map.width > width) width = map.width;
			if (map.height > height) height = map.height;
			return map;
		}
		
		protected function addHUD():void { add(hud = new HUD()); }
		
		override public function preUpdate():void {
			super.preUpdate();
		}
		override public function update():void {
			//var _cloudsEnabled:Boolean = cloudsEnabled;
			
			FlxG.overlap(overlapGroup, overlapGroup, hitSprite);
			
			FlxG.collide(antiCloudGroup, solidGroup, hitSolidSprite);
			
			if (!_cloudsEnabled)
				cloudsEnabled = true;
			
			FlxG.collide(solidGroup, solidGroup, hitSolidSprite);
			
			if (!_cloudsEnabled)
				cloudsEnabled = false;
			
			super.update();
		}
		
		protected function hitSolidSprite(obj1:FlxObject, obj2:FlxObject):void {
			
			if (obj1 is KrkSprite && (obj1 as KrkSprite).callback
				&& obj2 is KrkSprite && (obj2 as KrkSprite).callback
				&& (obj1.immovable || obj2.immovable))
				hitSprite(obj1 as KrkSprite, obj2 as KrkSprite);
		}
		protected function hitSprite(obj1:KrkSprite, obj2:KrkSprite):Boolean {
			if (!obj1.checkHit(obj2) || !obj2.checkHit(obj1))
				return false;
			
			if (obj1 is Trigger) 
				hitTrigger(obj1 as Trigger, obj2);
				
			if (obj2 is Trigger) 
				hitTrigger(obj2 as Trigger, obj1);
				
			obj1.hitObject(obj2);
			obj2.hitObject(obj1);
			return true;
		}
		
		public function hitTrigger(trigger:Trigger, collider:FlxObject):void {
			if (trigger.alive) {
				parseActions(trigger.action);
				trigger.onTrigger(collider);
			}
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
			
			for each(var obj:FlxObject in resetGroup.members)
				if (obj != null) obj.revive();
			
		}
		
		override public function destroy():void {
			super.destroy();
			
			maps = null;
		
			levelData = null;
			csv = null;
			tiles = null;
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
