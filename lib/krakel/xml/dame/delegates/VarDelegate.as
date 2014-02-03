package krakel.xml.dame.delegates {
	import krakel.xml.XMLParser;
	/**
	 * ...
	 * @author George
	 */
	public class VarDelegate extends ChildDelegate {
		
		public function VarDelegate(name:String, target:String = null, caster:Function=null) {
			super (
				name,
				target == null ? name : target,
				caster
			);
			
		}
		
		override public function find(data:XML, parent:Object):void {
			//super.find(data, parent);
			
			if (caster == null) {
				
				if (data[name].attributes().length() > 0)
					XMLParser.setProperties(parent[target], data[name][0]);
				else
					XMLParser.setProperty(parent, target, data[name][0]);
			}
			else
				parent[target] = caster(data[name][0]);
		}
		
	}

}