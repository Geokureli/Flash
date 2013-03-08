package relic.data 
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import relic.art.Asset;
	import relic.art.Layer;
	/**
	 * ...
	 * @author George
	 */
	public class AssetManager {
		private var layers:Object, groups:Object, assets:Object, autoNames:Object;
		private var trash:Vector.<String>;
		private var autoGroups:Dictionary;
		private var target:DisplayObjectContainer;
		
		public function AssetManager(target:DisplayObjectContainer) {
			this.target = target;
			layers = { };
			groups = { };
			assets = { };
			autoGroups = new Dictionary();
			autoNames = { };
			trash = new Vector.<String>();
		}
		
		// ====================================================================
		// 								- Helpers -
		// ====================================================================
		
		/**
		 * Creates a new layer and adds it to the asset manager's control target
		 * @param	name: The key used to reference the layer.
		 * @return	The created Layer
		 */
		public function addLayer(name:String):Layer {
			var layer:Layer = new Layer();
			layer.name = name;
			target.addChild(layer);
			layers[name] = layer;
			return layer;
		}
		
		/**
		 * Changes the depth order of the 2 specified layers
		 * @param	layer1: The layer.
		 * @param	layer2: The other layer.
		 */
		public function swapLayers(layer1:String, layer2:String):void {
			target.swapChildren(layers[layer1], layers[layer2]);
		}
		
		/**
		 * Sends the specified layer to show above all other layers except the draw layer.
		 * @param	name: The name of the target layer.
		 */
		public function layerToFront(name:String):void { target.addChild(layers[name]); }
		
		/**
		 * Sends the specified layer behind all other layers. 
		 * @param	name: The name of the target layer.
		 */
		public function layerToBack(name:String):void {
			target.addChildAt(layers[name], 0);
		}
		
		/**
		 * Adds an autoGroup for a specified class type.
		 * @param	type: The type of assets that the group should automatically contain.
		 * @param	group: the corresponding group name.
		 */
		public function autoGroup(type:Class, group:String):void {
			autoGroups[type] = group;
		}
		
		public function autoName(base:String):void { autoNames[base] = 0; }
		
		/**
		 * Registers the asset in the asset manager.
		 * @param	asset: The target asset.
		 * @param	name: The key for which to access the asset (see autoName())
		 * @param	groups(optional): The groups this asset belongs to (see autoGroup()).
		 * @return	the asset that was added
		 */
		public function add(asset:Asset, name:String = null, groups:String = null):Asset {
			for (var key:Object in autoGroups) {
				if (asset is Class(key)) {
					if (groups == null) groups = autoGroups[key];
					else { groups += ',' + groups; }
				}
			}
			if (name == null) {
				if (asset.name in autoNames)
					name = asset.name + '_' + autoNames[asset.name]++;
				else if (groups != null) {
					// --- SET UNIQUE NAME FROM MAIN GROUP
					name = groups.split(',')[0];
					name += groups[name].length;
					if(name in assets) throw new ArgumentError("No asset name defined");
				} else throw new ArgumentError("No asset name defined");
			}
			asset.name = name;
			if (groups != null) {
				for each(var group:String in groups.split(',')) {
					// --- CHECK IF GROUP EXISTS
					if (!(group in this.groups))
						this.groups[group] = new Vector.<Asset>();// --- ADD GROUP
					this.groups[group].push(asset); // --- ADD TO GROUPS
				}
			}
			assets[name] = asset;
			return asset;
		}

		/**
		 * Adds the target
		 * @param	parent: If a string is specified, a layer or asset with a matching name will be used. 
		 * If a DisplayObjectContainer is specified, it is used.
		 * @param	name: the name of the target asset.
		 * @param	params(optional): an object containing variables that will be set on the target asset(for awesome 1 line defs).
		 * @return	The asset that was Added.
		 */
		public function place(parent:Object, name:String, params:Object = null):Asset {
			// --- GET PARENT
			if (parent is String){
				if (parent in layers) parent = layers[parent];
				else if (parent in assets) parent = assets[parent];
				else throw new ArgumentError("parent string must the key of a layer or asset");
			}
			
			// --- SET PARAMS
			for (var i:String in params)
				assets[name][i] = params[i];
				
			// --- ADD TO PARENT
			parent.addChild(assets[name]);
			return assets[name];
		}
		
		/**
		 * Retrieves the asset registered to the specified key.
		 * @param	name: The identifier of the asset.
		 * @return the target asset.
		 */
		public function getAsset(name:String):Asset { return assets[name]; }
		
		/**
		 * Removes an asset from it's parent.
		 * @param	name: the name the asset is registered to.
		 * @return	The asset that was removed.
		 */
		public function remove(name:String):Asset {
			var asset:Asset = assets[name];
			asset.parent.removeChild(asset);
			return asset;
		}
		
		/**
		 * Removes the asset 
		 * @param	name: the name the asset is registered to.
		 * @return	The asset that was killed
		 */
		public function kill(name:String):Asset {
			var asset:Asset = remove(name);
			for (var g:String in groups) {
				var index:int = groups[g].indexOf(asset);
				if (index != -1) groups[g].splice(index, 1);
			}
			delete assets[name];
			asset.destroy();
			return asset;
		}
		
		/**
		 * Retrieves the target group.
		 * @param	name: the identifier of the group.
		 * @return the target group
		 */
		public function group(name:String):Vector.<Asset> { return groups[name]; }
		
		/**
		 * Kills all of the assets in a group. Kills them good.
		 * @param	name: Target group name to obliterate.
		 */
		public function killGroup(name:String):void {
			for each(var g:String in name.split(',')) {
				if(g in groups){
					var group:Vector.<Asset> = groups[g];
					while (group.length > 0) kill(group[0].name);
				}
			}
		}
		
		// ====================================================================
		// 								- Events -
		// ====================================================================
		
		/**
		 * Removes trash, updates all assets.
		 */
		public function update():void {
			clearTrash();
			for (var assetName:String in assets) {
				if (assets[assetName].live) assets[assetName].update();
				if (assets[assetName].trash) trash.push(assetName);
			}
		}
		
		private function clearTrash():void {
			while (trash.length > 0) kill(trash.shift());
		}
		
		/**
		 * Removes all references and allows the asset manager and its contents to be garbage collected
		 */
		public function destroy():void {
			clearTrash();
			for each(var layer:Layer in layers) {
				layer.destroy();
				target.removeChild(layer);
			}
			layers = null;
			target = null;
			trash = null;
		}
		
	}

}