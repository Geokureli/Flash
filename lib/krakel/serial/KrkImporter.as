package krakel.serial {
	/**
	 * ...
	 * @author George
	 */
	public class KrkImporter {
		
		static public var graphics:Object = { };
		static public var maps:Object = { };
		static public var audio:Object = { };
		
		static public function getFile(path:String):Class {
			var split:Array = path.split('/');
			
			var type:String = split[0];
			while(type == ".." || type == "levels")
				type = split.shift();
			
			path = split.join('/').split('.')[0];
			switch(type) {
				case "graphics": return getChild(path, graphics);
				case "maps": return getChild(path, maps);
				case "audio": return getChild(path, audio);
			}
			return null;
		}
		
		static private function getChild(path:String, target:Object):Class {
			var split:Array = path.split('/');
			for (var i:int = 0; i < split.length; i++) {
				if (split[i] in target)
					target = target[split[i]];
				else if (i + 1 == split.length) return null;
				else {
					trace("");
				}
			}
			return target as Class;
		}
	}

}