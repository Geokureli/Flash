package krakel.xml.dame.delegates {
	import krakel.xml.XMLParser;
	/**
	 * ...
	 * @author George
	 */
	public class ChildDelegate {
		
		public var caster:Function;
		public var target:String;
		public var name:String;
		
		public function ChildDelegate(name:String, target:String, caster:Function = null) {
			this.name = name;
			this.target = target;
			this.caster = caster;
			
		}
		
		public function find(data:XML, parent:Object):void {
			
			if (caster == null) {
				
				if (data[name].attributes().length() > 0)
					XMLParser.setProperties(parent[target], data[name]);
				else
					XMLParser.setProperty(parent, target, data[name]);
				
			} else
				parent[target] = caster(data[name]);
		}
		
	}

}