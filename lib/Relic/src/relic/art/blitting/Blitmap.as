package relic.art.blitting {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import relic.art.Asset;
	import relic.art.IScene;
	
	/**
	 * ...
	 * @author George
	 */
	public class Blitmap extends Bitmap {
		
		protected var up:Boolean, down:Boolean, left:Boolean, right:Boolean, 
						updateBlits:Boolean;
		private var layerOrder:Vector.<BlitLayer>;
		private var layers:Object, blits:Object, autoNames:Object, groups:Object;
		private var trash:Vector.<String>;
		private var autoGroups:Dictionary;
		public var bgColor:uint;
		
		public function Blitmap(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false) {
			super(bitmapData, pixelSnapping, smoothing);
			setDefaultValues();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function setDefaultValues():void {
			layerOrder = new Vector.<BlitLayer>();
			trash = new Vector.<String>();
			autoGroups = new Dictionary();
			autoNames = { };
			layers = { };
			blits = { };
			groups = { };
			updateBlits = true;
		}
		
		/** Called when added to stage
		 * 
		 * @param	e: fuck it
		 */
		protected function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addListeners();
		}
		
		/** Called by init() (super() encouraged)
		 * 
		 */
		protected function addListeners():void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandle);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyHandle);
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
		
		/**
		 * Adds an autoGroup for a specified class type.
		 * @param	type: The type of assets that the group should automatically contain.
		 * @param	group: the corresponding group name.
		 */
		public function autoGroup(type:Class, group:String):void {
			autoGroups[type] = group;
		}
		
		/**
		 * Sets a watcher that renames certain blits to a unique name. If you set an autoName for "apple" and add 
		 * to blits named apple will have a number appended to it corresponding to the order they were added in.
		 * @param	base:The name to look for and replace with a unique name.
		 */
		public function autoName(base:String):void { autoNames[base] = 0; }
		
		/**
		 * Registers the blit in the blit manager.
		 * @param	blit: The target blit.
		 * @param	name: The identifier for which to access the blit (see autoName())
		 * @param	groups(optional): The groups this blit belongs to. to add to multiple groups, spearate by commas. (see autoGroup()).
		 * @return	The blit that was added
		 */
		public function add(blit:Asset, name:String = null, groups:String = null):Asset {
			for (var key:Object in autoGroups) {
				if (blit is Class(key)) {
					if (groups == null) groups = autoGroups[key];
					else { groups += ',' + groups; }
				}
			}
			if (name == null) {
				if (blit.name in autoNames)
					name = blit.name + '_' + autoNames[blit.name]++;
				else throw new ArgumentError("No blit name defined");
			}
			blit.name = name;
			if (groups != null) {
				for each(var group:String in groups.split(',')) {
					// --- CHECK IF GROUP EXISTS
					if (!(group in this.groups))
						this.groups[group] = new Vector.<Blit>();// --- ADD GROUP
					this.groups[group].push(blit); // --- ADD TO GROUPS
				}
			}
			blits[name] = blit;
			return blit;
		}
		
		/**
		 * Adds the target
		 * @param	layer: The name of the layer to add the blit to.
		 * @param	blit: The target blit to be placed. if a string is passed, the blit with the matching identifier is used. Otherwise pass in the actual blit.
		 * @param	params(optional): an object containing variables that will be set on the target asset(for awesome 1 line defs).
		 * @return	The blit that was Added.
		 */
		public function place(layer:Object, blit:Object, params:Object = null):Asset {
			// --- GET BLIT
			if (blit is String) blit = blits[blit];
			
			blit.setParameters(params);
			
			// --- ADD TO LAYER
			layers[layer].add(blit);
			return blit as Blit;
		}
		
		/**
		 * Retrieves the blit registered to the specified key.
		 * @param	name: The identifier of the blit.
		 * @return the target blit.
		 */
		public function getBlit(name:String):Blit { return blits[name]; }
		
		/**
		 * Removes the target asset from the specified group or groups
		 * @param	blit: The blit to remove.
		 * @param	group: The group to remove it from. To remove from multiple groups, separate by commas 
		 */
		public function removeFromGroup(blit:Blit, groups:String):void {
			for each(var group:String in groups.split(',')){
				var index:int = this.groups[group].indexOf(blit);
				if (index != -1) this.groups[group].splice(index, 1);
			}
		}
		
		/**
		 * Removes an blit from it's parent.
		 * @param	name: The name the blit is registered to, or the actual blit itself.
		 * @return	The blit that was removed.
		 */
		public function remove(blit:Object):Blit {
			if (blit is String) blit = blits[blit];
			blit._layer.remove(blit);
			return blit as Blit;
		}
		
		/**
		 * Removes the blit
		 * @param	name: the name the blit is registered to, or the actual blit itself.
		 * @return	The blit that was killed.
		 */
		public function kill(blit:Object):Blit {
			blit = remove(blit);
			for (var g:String in groups) {
				var index:int = groups[g].indexOf(blit);
				if (index != -1)
					groups[g].splice(index, 1);
			}
			
			delete blits[blit.name];
			blit.destroy();
			return blit as Blit;
		}
		
		/**
		 * Retrieves the target group.
		 * @param	name: the identifier of the group.
		 * @return the target group
		 */
		public function group(name:String):Vector.<Blit> { return groups[name]; }
		
		/**
		 * Kills all of the blits in a group. Kills them good.
		 * @param	name: Target group name to obliterate.
		 */
		public function killGroup(name:String):void {
			for each(var g:String in name.split(',')) {
				if(g in groups){
					var group:Vector.<Blit> = groups[g];
					while (group.length > 0) kill(group[0].name);
				}
			}
		}
		
		
		// ====================================================================
		// 								- Events -
		// ====================================================================
		
		/**
		 * Removes trash, updates all blits.
		 */
		public function update():void {
			clearTrash();
			if(updateBlits){
				for (var blitName:String in blits) {
					if (blits[blitName].live) blits[blitName].update();
					if (blits[blitName].trash) trash.push(blitName);
				}
			}
			draw();
		}
		
		private function draw():void {
			bitmapData.fillRect(bitmapData.rect, bgColor);
			for each(var layer:BlitLayer in layerOrder) {
				for each(var child:Blit in layer.children)
					child.drawToStage(bitmapData);
			}
		}
		
		private function clearTrash():void {
			while (trash.length > 0) kill(trash.shift());
		}
		
		protected function keyHandle(e:KeyboardEvent):void {
			switch(e.keyCode) {
				case 37: left	= e.type == KeyboardEvent.KEY_DOWN; break;
				case 38: up		= e.type == KeyboardEvent.KEY_DOWN; break;
				case 39: right	= e.type == KeyboardEvent.KEY_DOWN; break;
				case 40: down	= e.type == KeyboardEvent.KEY_DOWN; break;
			}
		}
		
		/**
		 * Removes all references and allows the asset manager and its contents to be garbage collected
		 */
		public function destroy():void {
			removeListeners();
			clearTrash();
			while (layerOrder.length > 0)
				layerOrder.shift().destroy();
			
			layerOrder = null;
			layers = null;
			autoGroups = null;
			blits = autoNames = null;
			layerOrder = null;
			trash = null;
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