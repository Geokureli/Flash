package relic.art.blitting {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import relic.Asset;
	import relic.art.IScene;
	import relic.AssetManager;
	import relic.IAssetHolder;
	
	/**
	 * ...
	 * @author George
	 */
	public class Blitmap extends Bitmap implements IAssetHolder {
		static private const NULL_BG:uint = 0x01FFFFFF;
		
		private var autoLayers:Dictionary;
		private var layerOrder:Vector.<BlitLayer>;
		private var layers:Object;
		
		protected var _assets:AssetManager;
		
		public var bgColor:uint;
		public var transparent:Boolean;
		
		public function Blitmap(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false) {
			super(bitmapData, pixelSnapping, smoothing);
			
			setDefaultValues();
			createLayers();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function setDefaultValues():void {
			assets = defaultAssetManager;
			layerOrder = new Vector.<BlitLayer>();
			layers = { };
			bgColor = NULL_BG;
			transparent = false;
			autoLayers = new Dictionary();
		}
		
		private function get defaultAssetManager():AssetManager { return new AssetManager(this); }
		
		/** Called when added to stage
		 * 
		 * @param	e: 
		 */
		protected function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//if(bgColor == NULL_BG) bgColor = stage.color;
			if (bitmapData == null)
				bitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, transparent || bgColor > 0xFFFFFF, bgColor);
			addListeners();
		}
		
		/** Called automatically by constructor
		 * Override this to create custom layers, you do not have to call super.
		 * super will create a back, mid, and front layer. After this method is finished
		 * (whether super is called or not) a draw layer will be added to the front
		 */
		protected function createLayers():void {
			addLayer("BG");
			addLayer("back");
			addLayer("mid");
			addLayer("front");
			addLayer("UI");
		}

		protected function addListeners():void {
			
		}
		
		protected function autoLayer(layer:String, type:Class, ...args):void {
			args.push(type);
			
			for each(var type:Class in args)
				autoLayers[type] = layer;
		}
		
		/**
		 * Creates a new layer and adds it to the asset manager's control target
		 * @param	name: The key used to reference the layer.
		 * @return	The created Layer
		 */
		public function addLayer(name:String):void {
			var layer:BlitLayer = new BlitLayer();
			layerOrder.push(layer);
			layer.parent = this;
			layers[name] = layer;
		}
		
		public function a(id:String):Asset{
			return assets.a(id);
		}
		
		/**
		 * Adds the target
		 * @param	layer: The name of the layer to add the blit to.
		 * @param	blit: The target blit to be placed. if a string is passed, the blit with the matching identifier is used. Otherwise pass in the actual blit.
		 * @param	params(optional): an object containing variables that will be set on the target asset(for awesome 1 line defs).
		 * @return	The blit that was Added.
		 */
		public function place(asset:Asset):Asset {
			var layer:String = "front";
			
			for (var key:Object in autoLayers)
				if (asset is Class(key))
					layer = autoLayers[key];
			
			return placeOnLayer(layer, asset);
		}
		
		public function placeOnLayer(layer:Object, asset:Asset):Asset {
			if (layer is String) layer = layers[layer];
			layer.place(asset);
			return asset;
		}
		
		/**
		 * Removes an blit from it's parent.
		 * @param	name: The name the blit is registered to, or the actual blit itself.
		 * @return	The blit that was removed.
		 */
		public function remove(asset:Asset):Asset {
			asset.parent.remove(asset);
			return asset;
		}
		
		// ====================================================================
		// 								- Events -
		// ====================================================================
		
		/**
		 * Removes trash, updates all blits.
		 */
		public function update():void {
			assets.update();
			draw();
		}
		
		private function draw():void {
			bitmapData.fillRect(bitmapData.rect, bgColor);
			for each(var layer:BlitLayer in layerOrder) {
				for each(var child:Asset in layer.children)
					child.draw();
			}
		}
		
		/**
		 * Removes all references and allows the asset manager and its contents to be garbage collected
		 */
		public function destroy():void {
			removeListeners();
			while (layerOrder.length > 0)
				layerOrder.shift().destroy();
			
			autoLayers = null;
			layerOrder = null;
			layers = null;
			
		}
		
		/**
		 * Removes listeners from the scene.
		 */
		protected function removeListeners():void { }
		
		public function get assets():AssetManager { return _assets; }
		public function set assets(value:AssetManager):void { _assets = value; }
	}

}