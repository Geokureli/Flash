package krakel {
	/**
	 * ...
	 * @author George
	 */
	public class KrkGameState extends KrkState {
		public var resetOnFail:Boolean;
		
		override public function create():void {
			super.create();
			
			setLevelProperties();
			initLayers();
			addSounds();
			
			startGame();
		}
		
		protected function setLevelProperties():void { }
		
		protected function initLayers():void {
			addBG();
			addMG();
			addFG();
			addUI();
		}
		
		/** Add your background assets here */
		protected function addBG():void { }
		
		/** Add your background assets here */
		protected function addMG():void { }
		
		/** Add your midground assets here */
		protected function addFG():void { }
		
		/** Add your UI assets here */
		protected function addUI():void { }
		
		/** Add your sounds here */
		protected function addSounds():void { }
		
		protected function startGame():void { startGameIntro(); }
		protected function startGameIntro():void { endGameIntro(); }
		protected function endGameIntro():void { startRound(); }
		
		protected function startRound():void { startRoundIntro(); }
		protected function startRoundIntro():void { endRoundIntro(); }
		protected function endRoundIntro():void { }
		
		protected function endRound():void { startRoundOutro(); }
		protected function startRoundOutro():void { endRoundOutro(); }
		protected function endRoundOutro():void { }
		
		protected function roundFail():void {
			clearRound();
			resetOnFail ? resetRound()
						: nextRound();
		}
		
		protected function clearRound():void {}
		protected function resetRound():void { startRound(); }
		protected function nextRound():void { startRoundTransition(); }
		protected function startRoundTransition():void {}
		
		protected function endGame():void { startGameOutro(); }
		protected function startGameOutro():void { endGameOutro(); }
		protected function endGameOutro():void { }
	}

}