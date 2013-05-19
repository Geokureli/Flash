package greed.states {
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import greed.levels.GreedLevel;
	import greed.levels.LevelRef;
	import krakel.KrkState;
	import org.flixel.FlxBasic;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxRect;
	
	/**
	 * ...
	 * @author George
	 */
	public class LoaderState extends KrkState {
		
		private var loader:URLLoader;
		private var fileRef:FileReference;
		private var levelRef:LevelRef;
		private var sharedObject:SharedObject;
		
		public var buttons:FlxGroup;
		
		private var btn_load:FlxButton,
					btn_reload:FlxButton,
					btn_auto:FlxButton;
		
		private var levels:Object;
		private var settings:XML;
		private var currentLevel:GreedLevel;
		private var levelName:String;
		private var numLevels:int,
					numUtilBtns:int;
		
		private var savedLevels:Array;
		public var counter:int;
		
		//public function LoaderState() { super(); }
		
		override public function create():void {
			super.create();
			
			Imports.levels;
			
			levels = { };
			numLevels =
				counter = 0;
			add(buttons = new FlxGroup());
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onSettingsload);
			loader.load(new URLRequest("settings.xml"));
		}
		
		private function onSettingsload(e:Event):void {
			settings = new XML(e.target.data);
			
			LevelRef.ROOT_PATH = settings.rootPath.toString();
			
			sharedObject = SharedObject.getLocal("savedLevels");
			
			if (sharedObject.data.levels != null) {
				// --- COPY ARRAY;
				savedLevels = [].concat(sharedObject.data.levels);
				loadLevels();
			} else {
				sharedObject.data.levels = [];
				savedLevels = [];
			}
			
			buttons.add(btn_load = new FlxButton(5, FlxG.height-25, "Load", clk_load));
			buttons.add(btn_reload = new FlxButton(90, FlxG.height - 25, "Reload", clk_reload));
			buttons.add(btn_auto = new FlxButton(175, FlxG.height - 25, "Auto-load", clk_auto));
			
			numUtilBtns = buttons.length;
		}
		
		private function loadLevels():void {
			if (savedLevels.length == 0) return;
			
			var name:String = savedLevels[0];
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLevelLoaded);
			loader.load(new URLRequest(LevelRef.ROOT_PATH + name));
		}
		
		private function clk_load():void {
			fileRef = new FileReference();
			fileRef.browse([new FileFilter("Levels", "*.xml")]);
			fileRef.addEventListener(Event.SELECT, onLevelSelected);
		}
		
		private function onLevelSelected(e:Event):void {
			if (sharedObject.data.levels.indexOf(fileRef.name) == -1) {
				
				fileRef.addEventListener(Event.COMPLETE, onLevelLoaded);
				fileRef.load();
			}
		}
		
		private function onLevelLoaded(e:Event):void {
			var name:String;
			if (e.target is URLLoader) {
				name = savedLevels[0];
				savedLevels.shift();
			} else {
				name = e.target.name;
				sharedObject.data.levels.push(name);
				sharedObject.flush();
				trace("saved levels");
			}
			name = name.split('.')[0];
			
			levelRef = levels[name];
			if (levelRef == null) {
				levelRef = new LevelRef(name, new XML(e.target.data));
				buttons.add(
					new FlxButton(
						5 + 100*int(numLevels/10),
						5 + (numLevels%10) * 20,
						levelRef.name,
						function():void { runlevel(levelRef); }
					)
				).visible = false;
				levels[levelRef.name] = levelRef;
			} else
				levelRef.xml = new XML(e.target.data);
			
			levelRef.load(onMapLoaded);
			
		}
		
		private function onMapLoaded(ref:LevelRef):void {
			buttons.members[numUtilBtns + numLevels].visible = true;
			
			numLevels++;
			
			loadLevels();
		}
		
		public function clk_reload():void {
			if (sharedObject.data.levels != null) {
				buttons.setAll("visible", false);
				btn_load.visible = btn_reload.visible = btn_auto.visible = true;
				numLevels = 0;
				
				// --- COPY ARRAY;
				savedLevels = [].concat(sharedObject.data.levels);
				loadLevels();
			}
		}
		
		public function clk_auto():void {
			btn_auto.on = !btn_auto.on;
		}
		
		public function runlevel(levelRef:LevelRef):void {
			buttons.kill();
			
			currentLevel = levelRef.create();
			currentLevel.ID = counter++;
			add(currentLevel);
			trace(currentLevel.ID);
			FlxG.worldBounds.width = currentLevel.width;
			FlxG.worldBounds.height = currentLevel.height;
			
			FlxG.camera.bounds = new FlxRect(0, 0, currentLevel.width, currentLevel.height);
		}
		
		override public function update():void {
			super.update();
			
			if (FlxG.keys.ESCAPE && currentLevel) {
				remove(currentLevel);
				currentLevel.destroy();
				currentLevel = null;
				
				FlxG.camera.setBounds(0, 0, FlxG.width, FlxG.height, true);
				
				buttons.revive();
				var button:FlxBasic = buttons.getFirstDead();
				while (button != null) {
					button.revive();
					button = buttons.getFirstDead()
				}
			}
		}
		
		override public function destroy():void {
			super.destroy();
			btn_load = null;
			fileRef = null;
		}
		
	}

}