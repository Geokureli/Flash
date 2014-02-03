package krakel.xml.dame.delegates {
	/**
	 * ...
	 * @author George
	 */
	public class InnerListDelegate extends ChildDelegate {
		
		public var childName:String;
		
		public function InnerListDelegate(name:String, target:String, childName:String, caster:Function = null) {
			super(name, target, caster);
			this.childName = childName;
			
		}
		
		override public function find(data:XML, parent:Object):void {
			//super.find(data, parent);
			
			if (caster == null)
				parent[target] = data[name][childName];
			else
				parent[target] = caster(data[name][childName]);
		}
	}
}