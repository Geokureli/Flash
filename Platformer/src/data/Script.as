package data 
{
	/**
	 * ...
	 * @author George
	 */
	public class Script 
	{
		static protected const METHODS:Object = {trace:trace};
		{
			METHODS["var"] = setVar;
		}
		protected var methods:Object;
		public var vars:Object;
		public function Script(control:Object) {
			vars = { };
		}
		public function loadScript(path:String):void {
			
		}
		public function runScript(entryPoint:String = "start"):void {
			
		}
		// --- STATIC SHIT
		
		static protected function setVar(xml:XML):void {
			
		}
	}

}