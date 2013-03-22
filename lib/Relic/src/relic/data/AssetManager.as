package relic.data 
{
	import baseball.art.obstacles.Bomb;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import relic.art.Asset;
	import relic.art.Layer;
	/**
	 * ...
	 * @author George
	 */
	public class AssetManager {
		private var groups:Object, assets:Object, autoNames:Object;
		private var garbage:Vector.<String>;
		private var autoGroups:Dictionary;
		private var target:IAssetHolder;
		
		public function AssetManager(target:IAssetHolder) {
			this.target = target;
			groups = { };
			assets = { };
			autoGroups = new Dictionary();
			autoNames = { };
			garbage = new Vector.<String>();
		}
		
		// ====================================================================
		// 								- Helpers -
		// ====================================================================
		
		/**
		 * Adds an autoGroup for a specified class type.
		 * @param	type: The type of assets that the group should automatically contain.
		 * @param	group: the corresponding group name.
		 */
		public function autoGroup(type:Class, group:String):void { autoGroups[type] = group; }
		
		/**
		 * Sets a watcher that renames certain assets to a unique name. If you set an autoName for "apple" and add 
		 * to assets named apple will have a number appended to it corresponding to the order they were added in.
		 * @param	base:The name to look for and replace with a unique name.
		 */
		public function autoID(base:String):void { autoNames[base] = 0; }
		
		/**
		 * Registers the asset in the asset manager.
		 * @param	asset: The target asset.
		 * @param	name: The key for which to access the asset (see autoName())
		 * @param	groups(optional): The groups this asset belongs to (see autoGroup()).
		 * @return	the asset that was added
		 */
		public function add(asset:Asset, id:String = null, groups:String = null):Asset {
			if (id in assets) trace("asset already named " + id);
			for (var key:Object in autoGroups) {
				if (asset is Class(key)) {
					if (groups == null) groups = autoGroups[key];
					else { groups += ',' + autoGroups[key]; }
				}
			}

			if (asset.id in autoNames)
				id = asset.id + '_' + autoNames[asset.id]++;
			//else if (groups != null) {
				// --- SET UNIQUE NAME FROM MAIN GROUP
				//id = groups.split(',')[0];
				//id += groups[id].length;
				//if(id in assets) throw new ArgumentError("No asset name defined");
			//} else throw new ArgumentError("No asset id defined, and no appropriate autoID");
			asset.id = id;
			
			if (groups != null) {
				for each(var group:String in groups.split(',')) {
					// --- CHECK IF GROUP EXISTS
					if (!(group in this.groups))
						this.groups[group] = new Vector.<Asset>();// --- ADD GROUP
					this.groups[group].push(asset); // --- ADD TO GROUPS
				}
			}
			assets[id] = asset;
			return asset;
		}

		/**
		 * Retrieves the asset registered to the specified key.
		 * @param	name: The identifier of the asset.
		 * @return the target asset.
		 */
		public function a(id:String):Asset { return assets[id]; }
		
		/**
		 * Removes the asset 
		 * @param	name: the name the asset is registered to.
		 * @return	The asset that was killed
		 */
		protected function kill(id:String):Asset {
			var asset:Asset = a(id);
			for (var g:String in groups) {
				var index:int = groups[g].indexOf(asset);
				if (index != -1) groups[g].splice(index, 1);
			}
			delete assets[id];
			asset.destroy();
			return asset;
		}
		
		/**
		 * Retrieves the target group.
		 * @param	name: the identifier of the group.
		 * @return the target group
		 */
		public function group(id:String):Vector.<Asset> { return groups[id]; }

		public function setGroupParams(id:String, params:Object):void {
			for each(var asset:Asset in groups[id])
				asset.setParameters(params);
		}
		/**
		 * Kills all of the assets in a group. Kills them good.
		 * @param	name: Target group name to obliterate.
		 */
		public function trashGroup(id:String):void {
			for each(var g:String in id.split(',')) {
				if(g in groups){
					var group:Vector.<Asset> = groups[g];
					for each(var asset:Asset in group) trash(asset);
				}
			}
		}
		
		
		public function removeFromGroup(asset:Asset, string:String):void {
			for each(var g:String in string.split(',')){
				var index:int = groups[g].indexOf(asset);
				if (index != -1) groups[g].splice(index, 1);
			}
		}
		
		public function trash(asset:Object):Asset {
			if (asset is String) asset = a(asset as String);
			asset.trash = true;
			return asset as Asset;
		}
		
		// ====================================================================
		// 								- Events -
		// ====================================================================
		/**
		 * Removes trash, updates all assets.
		 */
		public function update():void {
			clearTrash();
			for (var id:String in assets)
				if (assets[id].live) assets[id].preUpdate();
			
			// --- PRE UPDATE
			for (id in assets)
				if (assets[id].live) assets[id].preUpdate();
			// --- UPDATE
			for (id in assets) {
				if (assets[id].live) assets[id].update();
				if (assets[id].trash) garbage.push(id);
			}
		}
		
		private function clearTrash():void {
			while (garbage.length > 0) kill(garbage.shift());
		}
		
		/**
		 * Removes all references and allows the asset manager and its contents to be garbage collected
		 */
		public function destroy():void {
			clearTrash();
			target = null;
			garbage = null;
		}
		
	}

}