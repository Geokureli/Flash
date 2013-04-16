package relic {
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import relic.Asset;
	import relic.art.Button;
	import relic.art.Layer;
	import relic.collision.CollisionWatch;
	import relic.events.CollisionEvent;
	/**
	 * ...
	 * @author George
	 */
	public class AssetManager {
		
		private var target:IAssetHolder;
		
		private var groups:Object,
					assets:Object,
					autoNames:Object,
					toolGroups:Object;
		
		private var autoGroups:Dictionary;
		
		private var hitWatchers:Vector.<CollisionWatch>;
		private var garbage:Vector.<String>;
		
		public function AssetManager(target:IAssetHolder) {
			this.target = target;
			groups = { };
			assets = { };
			autoNames = { };
			toolGroups = { };
			
			autoGroups = new Dictionary();
			
			hitWatchers = new Vector.<CollisionWatch>();
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
			
			//else if (groups != null) 
			//{
			// --- SET UNIQUE NAME FROM MAIN GROUP
			//id = groups.split(',')[0];
			//id += groups[id].length;
			//}
			else if(asset.id == null)
				asset.id = id;
			
			if (groups != null) {
				addToGroups(asset, groups)
			}
			assets[asset.id] = asset;
			return asset;
		}

		/**
		 * Retrieves the asset registered to the specified key.
		 * @param	name: The identifier of the asset.
		 * @return the target asset.
		 */
		public function a(id:String):Asset { return assets[id]; }
		
		public function addOverlapWatch(attacker:Object, victim:Object, rebound:Boolean, listener:Function, args:Object = null):void {
			
			if (attacker is String) {
				// --- GROUP ID
				if (attacker in groups)
					attacker = groups[attacker];
				// --- ASSET ID
				else attacker = a(attacker as String);
			}
			// --- GROUP OF 1
			if (attacker is Asset) attacker = Vector.<Asset>([attacker]);
			
			if (victim is String) {
				// --- GROUP ID
				if (victim in groups)
					victim = groups[victim];
				// --- ASSET ID
				else victim = a(victim as String);
			}
			// --- GROUP OF 1
			if (victim is Asset) victim = Vector.<Asset>([victim]);
			
			hitWatchers.push(new CollisionWatch(attacker as Vector.<Asset>, victim as Vector.<Asset>, rebound, listener, args));
		}
		
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
		
		public function setGroupAsTools(id:String, listener:Function = null):void {
			
			var buttons:Vector.<Button> = new Vector.<Button>();
			
			for each(var button:Button in group(id))
				buttons.push(button);
				
			toolGroups[id] = new ToolGroup(buttons, listener);
		}
		
		public function addToolToGroup(id:String, btn:Button, ... args):void {
			
			args.unshift(btn);
			if (!(id in toolGroups))
				toolGroups[id] = new ToolGroup(Vector.<Button>(args));
				
			else for each(btn in args)
				toolGroups[id].push(btn);
		}
		
		public function addToolEvent(setID:String, listener:Function):void {
			toolGroups[setID].listener = listener;
		}
		
		public function removeToolGroup(id:String):void {
			toolGroups[id].destroy();
			delete toolGroups[id];
		}
		
		public function addToGroups(asset:Object, groups:String):void {
			
			for each(var group:String in groups.split(',')) {
				// --- CHECK IF GROUP EXISTS
				if (!(group in this.groups))
					// --- ADD GROUP
					this.groups[group] = new Vector.<Asset>();
				// --- ADD TO GROUPS
				this.groups[group].push(asset); 
			}
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
			// --- COLLISION
			for each(var watcher:CollisionWatch in hitWatchers) 
				watcher.update();
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

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import relic.Asset;
import relic.art.Button;
import relic.events.CollisionEvent;

class ToolGroup extends EventDispatcher{

	private var buttons:Vector.<Button>;
	private var _listener:Function;
	
	public function ToolGroup(buttons:Vector.<Button> = null, listener:Function = null) {
		
		this.listener = listener;
		
		if (buttons == null) {
			
			buttons = new Vector.<Button>();
			return;
		}
		this.buttons = buttons;
		
		if (buttons.length > 0) {
			
			for each(var button:Button in buttons) {
				
				button.isToggle = true;
				button.selected = false;
				
				button.addEventListener(MouseEvent.CLICK, onToolClick)
			}
			buttons[0].selected = true;
		}
		
	}
	
	public function push(button:Button):void {
		button.isToggle = true;
		button.selected = buttons.length == 0;
		
		buttons.push(button);
		button.addEventListener(MouseEvent.CLICK, onToolClick)
	}
	
	private function onToolClick(e:MouseEvent):void {
		
		if (buttons.indexOf(e.currentTarget) != -1)
			deselectTools();
		
		e.currentTarget.selected = true;
		
		if(listener != null)
			listener(e)
	}
	
	private function deselectTools():void {
		
		for each(var button:Button in buttons)
			button.selected = false;
	}
	
	public function destroy():void {
		
		while (buttons.length > 0)
			buttons.pop().removeEventListener(MouseEvent.CLICK, onToolClick);
		
		listener = null;
	}
	
	public function get listener():Function { return _listener; }
	public function set listener(value:Function):void {
		if (listener !== null)
			removeEventListener(MouseEvent.CLICK, listener)
		
		_listener = value;
		
		if(value != null)
			addEventListener(MouseEvent.CLICK, listener)
	}
}