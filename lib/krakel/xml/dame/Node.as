package krakel.xml.dame {
	import flash.xml.XMLNode;
	import krakel.xml.dame.delegates.ChildDelegate;
	import krakel.xml.XMLParser;
	/**
	 * ...
	 * @author George
	 */
	public class Node {
		
		public var childDelegates:Vector.<ChildDelegate>;
		
		public var data:XML;
		
		public function Node(data:XML) {
			this.data = data;
			
			setDefaults();
			
			setProperties();
		}
		
		protected function setDefaults():void { }
		
		protected function setProperties():void {
			XMLParser.setProperties(this, data);
			
			setChildDelegates();
			
			for each(var delegate:ChildDelegate in childDelegates) {
				
				delegate.find(data, this);
			}
		}
		
		protected function setChildDelegates():void {
			childDelegates = new <ChildDelegate>[];
		}
		
		protected function parseChildText(text:String):void {
			
		}	
	}
}