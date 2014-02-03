package krakel.xml.dame {
	/**
	 * ...
	 * @author George
	 */
	public class Anim extends krakel.xml.dame.Node {
		
		public var name:String;
		public var fps:int;
		public var loops:Boolean;
		public var frames:Vector.<int>;
		
		public function Anim(data:XML) { super(data); }
		
		override protected function parseChildText(text:String):void {
			super.parseChildText(text);
			
			frames = Vector.<int>(text.split(','));
		}
	}
}