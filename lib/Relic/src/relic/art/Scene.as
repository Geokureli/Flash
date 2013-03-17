package relic.art {
	import flash.display.DisplayObjectContainer;
	import relic.data.AssetManager;
	//import relic.data.events.AssetEvent;
	import relic.data.Vec2;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author George
	 */
	public class Scene extends Sprite implements IScene {
		protected var assets:AssetManager;
		protected var up:Boolean, down:Boolean, left:Boolean, right:Boolean, 
						updateAssets:Boolean;
		protected var defaultUpdate:Function;
		
		public function Scene() {
			super();
			
			
			setDefaultValues();
			createLayers();
			assets.addLayer("draw");
			addStaticChildren();
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/** Called automatically by constructor
		 * Override to set initial values of properties.
		 */
		protected function setDefaultValues():void {
			assets = defaultAssetManager;
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
			assets.addLayer("back");
			assets.addLayer("mid");
			assets.addLayer("front");
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
			up = left = down = right = false;
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
		 * @param	parent: If a string is specified, a layer or asset with a matching name will be used. 
		 * If a DisplayObjectContainer is specified, it is used.
		 * @param	asset: If a string is provided, it must be the identifier of the target asset. Otherwise use the actual asset
		 * @param	params(optional): an object containing variables that will be set on the target asset(for awesome 1 line defs).
		 * @return	The asset that was Added.
		 */
		public function place(parent:Object, asset:Object, params:Object = null):Asset {
			if (asset is Asset) return assets.place(parent, asset.name, params);
			return assets.place(parent, asset as String, params);
		}
		
		/**
		 * Removes the asset 
		 * @param	name: the name the asset is registered to.
		 * @return	The asset that was killed
		 */
		protected function kill(asset:String):Asset { return assets.kill(asset); }
		
		/**
		 * Retrieves the target group.
		 * @param	name: the identifier of the group.
		 * @return the target group
		 */
		protected function asset(name:String):Asset { return assets.getAsset(name); }
		
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
			
			defaultUpdate = null;
		}
		
		/**
		 * Removes listeners from the scene.
		 */
		protected function removeListeners():void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandle);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyHandle);
		}
	}

}
