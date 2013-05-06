package krakel {
	/**
	 * ...
	 * @author George
	 */
	public class KrkScheme {
		private var target:KrkProp;
		
		public function KrkScheme(target:KrkProp) {
			this.target = target;
		}
		
		public function preUpdate():void { }
		public function update():void { }
		public function postUpdate():void { }
		
		public function destroy():void {
			target = null;
		}
	}

}