package krakel {
	/**
	 * ...
	 * @author George
	 */
	public class KrkLevelManager extends KrkState {
		
		private var currentLevel:KrkLevel;
		public function KrkLevelManager() {
			super();
			
		}
		
		public function addRef(levelData:XML):void {
			
		}
		
		protected function startLevel(level:KrkLevel):void {
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