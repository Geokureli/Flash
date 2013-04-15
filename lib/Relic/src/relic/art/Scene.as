package relic.art {
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import relic.AssetManager;
	//import relic.events.AssetEvent;
	import relic.Vec2;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author George
	 */
	public class Scene extends Sprite implements IScene {
		private var autoLayers:Dictionary;
		
		private var _assets:AssetManager;
		protected var layers:Object;
		
		protected var up:Boolean, down:Boolean, left:Boolean, right:Boolean, 
						updateAssets:Boolean;
						
		protected var defaultUpdate:Function;
		
		public function Scene() {
			super();
			
			setDefaultValues();
			createLayers();
			addStaticChildren();
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/** Called automatically by constructor
		 * Override to set initial values of properties.
		 */
		protected function setDefaultValues():void {
			assets = defaultAssetManager;
			autoLayers = new Dictionary();
		}
		
		/** Called automatically by constructor
		 * 
		 */
		protected function get defaultAssetManager():AssetManager {
			return new AssetManager(this);
		}
		
		/** Called automatically by constructor
		 * Override this to create custom layers, you do not have to call super.
		 * super will create a back, mid, and front layer. After this method is finished
		 * (whether super is called or not) a draw layer will be added to the front
		 */
		protected function createLayers():void {
			layers = { };
			addLayer("back");
			addLayer("mid");
			addLayer("front");
		}
		
		/**
		 * Creates a new layer and adds it to the asset manager's control target
		 * @param	name: The key used to reference the layer.
		 * @return	The created Layer
		 */
		public function addLayer(name:String):Layer {
			var layer:Layer = new Layer();
			
			layer.name = name;
			addChild(layer);
			layers[name] = layer;
			return layer;
		}
		
		protected function autoLayer(layer:String, type:Class, ...args):void {
			args.push(type);
			
			for each(var type:Class in args)
				autoLayers[type] = layer;
		}
		
		/**
		 * Changes the depth order of the 2 specified layers
		 * @param	layer1: The layer.
		 * @param	layer2: The other layer.
		 */
		public function swapLayers(layer1:String, layer2:String):void {
			swapChildren(layers[layer1], layers[layer2]);
		}
		
		/**
		 * Sends the specified layer to show above all other layers except the draw layer.
		 * @param	name: The name of the target layer.
		 */
		public function layerToFront(name:String):void { addChild(layers[name]); }
		
		/**
		 * Sends the specified layer behind all other layers. 
		 * @param	name: The name of the target layer.
		 */
		public function layerToBack(name:String):void {
			addChildAt(layers[name], 0);
		}
		
		/** Called automatically by constructor
		 * 
		 */
		protected function addStaticChildren():void { }
		
		/** Called when added to stage
		 * 
		 * @param	e
		 */
		protected function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			updateAssets = true;
			addListeners();
		}
		
		/** Called by init() (super() encouraged)
		 * 
		 */
		protected function addListeners():void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandle);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyHandle);
		}
		
		/** Called by main game (super() manditory)
		 * 
		 */
		public function update():void {
			if (assets != null && updateAssets) assets.update();
			
			if (defaultUpdate != null) defaultUpdate();
		}
		
		/**
		 * The main default key handler of the scene
		 * @param	e: The event dispatched
		 */
		protected function keyHandle(e:KeyboardEvent):void {
			switch(e.keyCode) {
				case 37: left	= e.type == KeyboardEvent.KEY_DOWN; break;
				case 38: up		= e.type == KeyboardEvent.KEY_DOWN; break;
				case 39: right	= e.type == KeyboardEvent.KEY_DOWN; break;
				case 40: down	= e.type == KeyboardEvent.KEY_DOWN; break;
			}
		}
		
		/**
		 * Registers the asset in the asset manager.
		 * @param	asset: The target asset.
		 * @param	name: The key for which to access the asset (see autoName())
		 * @param	groups(optional): The groups this asset belongs to (see autoGroup()).
		 * @return	the asset that was added
		 */
		public function add(asset:Asset, name:String = null, groups:String = null):Asset {
			return assets.add(asset, name, groups);
		}
		
		/**
		 * Adds the target
		 * @param	asset: The target asset to be placed. if a string is passed, the asset with the matching identifier is used. Otherwise pass in the actual asset.
		 * @return	The asset that was Added.
		 */
		public function place(asset:Asset):Asset {
			var layer:String = "front";
			
			for (var key:Object in autoLayers)
				if (asset is Class(key))
					layer = autoLayers[key];
			
			return placeOnLayer(layer, asset);
		}
		
		/**
		 * Adds the target
		 * @param	layer: The name of the layer to add the asset to.
		 * @param	asset: The target asset to be placed. if a string is passed, the asset with the matching identifier is used. Otherwise pass in the actual asset.
		 * @return	The asset that was Added.
		 */
		public function placeOnLayer(layer:Object, asset:Asset):Asset {
			if(layer is String) layer = layers[layer]
			// --- ADD TO LAYER
			layer.place(asset);
			return asset;
		}
		
		/**
		 * Removes an asset from it's parent.
		 * @param	name: The name the asset is registered to, or the actual asset itself.
		 * @return	The asset that was removed.
		 */
		public function remove(asset:Asset):Asset {
			asset.parent.remove(asset);
			return asset;
		}
		
		/**
		 * Removes the asset 
		 * @param	name: the name the asset is registered to.
		 * @return	The asset that was killed
		 */
		protected function trash(asset:String):Asset { return assets.trash(asset); }
		
		/**
		 * Retrieves the target group.
		 * @param	name: the identifier of the group.
		 * @return the target group
		 */
		protected function a(name:String):Asset { return assets.a(name); }
		
		/**
		 * 
		 * @param	start
		 * @param	end
		 * @param	color
		 */
		protected function drawArrow(start:Vec2, end:Vec2, color:uint = 0x808080):void {
			var head:Vec2 = end.dif(start).unit;
			head.length = 10;
			graphics.beginFill(color);
			graphics.lineStyle(2, color);
			graphics.moveTo(start.x, start.y);
			graphics.lineTo(end.x, end.y);
			graphics.lineTo(end.x - head.x - head.y, end.y - head.y + head.x);
			graphics.lineTo(end.x - head.x + head.y, end.y - head.y - head.x);
			graphics.lineTo(end.x, end.y);
		}
		
		protected function drawLine(p1:Vec2, p2:Vec2, color:uint = 0x808080, extend:Boolean = false):void {
			var start:Vec2 = new Vec2(0, 0), end:Vec2 = new Vec2(stage.stageWidth, stage.stageHeight);
			if (p2.y == p1.y) { 
				start.y = p1.y;
				end.y = p2.y;
			} else {
				var dir:Vec2 = p2.dif(p1);
				if (dir.y > 0) {
					start.x = p1.x - dir.x * p1.y / dir.y;
					end.x = p2.x + dir.x * (end.y - p2.y) / dir.y;
				} else {
					start.x = p2.x + dir.x * p2.y / -dir.y;
					end.x = p1.x - dir.x * (end.y - p1.y) / -dir.y;
				}
			}
			graphics.lineStyle(2, color);
			graphics.moveTo(start.x, start.y);
			graphics.lineTo(end.x, end.y);
		}
		
		/**
		 * Removes all references within the scene, and calls destroy on them as well.
		 * When overriding, call super() last
		 */
		public function destroy():void {
			removeListeners();
			assets.destroy();
			
			autoLayers = null;
			defaultUpdate = null;
		}
		
		/**
		 * Removes listeners from the scene.
		 */
		protected function removeListeners():void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandle);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyHandle);
		}
		
		public function get assets():AssetManager { return _assets; }
		public function set assets(value:AssetManager):void { _assets = value; }
	}

}
