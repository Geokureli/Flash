package krakel {
	import krakel.serial.KrkImporter;
	/**
	 * ...
	 * @author George
	 */
	public class KrkLevelManager extends KrkState {
		
		private var currentLevel:KrkLevel;
		
		public var defaultLevelClass:Class;
		public function KrkLevelManager() {
			super();
			
			defaultLevelClass = KrkLevel;
		}
		
		protected function startLevel(levelData:XML):void {
			var level:KrkLevel
			if ("@class" in levelData) {
				level = new KrkData.CLASS_REFS[levelData["@class"].toString()]();
			} else {
				level = new defaultLevelClass();
			}
			
			level.setParameters(new XML(levelData));
			
			if (currentLevel != null)
				currentLevel.endLevel();
			
			level.endLevel = onLevelEnd;
			add(currentLevel = level);
		}
		
		protected function onLevelEnd():void {			
			remove(currentLevel);
			currentLevel = null;
		}
	}

}