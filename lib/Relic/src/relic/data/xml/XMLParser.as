package relic.data.xml {
	import relic.data.StringHelper;
	/**
	 * ...
	 * @author George
	 */
	public class XMLParser {
		static private const DEFAULT_METHODS:Object = { };
		protected var methods:Object;
		protected var classes:Object;
		
		protected var target:Object;
		
		protected var source:XML;
		
		public function XMLParser(source:XML, target:Object) {
			this.target = target;
			this.source = source
			setDefaultProperies()
			preParse();
		}
		
		private function setDefaultProperies():void { }
		public function preParse():void { }
		public function parse(entry:String = null):void {
			if (entry == null) parseNode(source);
			else parseNode(source.children().(name().toString() == entry))[0];
		}
		protected function parseNode(node:XML):void {
			for each(var child:XML in node.children())
				parseNode(child);
		}
		static public function removeFromParent(node:XML):XML {
			delete node.parent()[node.name()];
			return node;
		}
		static public function removeAttribute(node:XML, name:String):String {
			var value:String = node['@' + name];
			delete node['@'+name];
			return value;
		}
		static public function setProperties(obj:Object, node:XML):Object {
			if (obj == null) obj = { };
			for each(var at:XML in node.attributes()) 
				obj[at.name().toString().substr(1)] = StringHelper.autoTypeString(node);
			return obj;
		}
		static public function removeNodes(parent:XML, names:String):XMLList {
			var list:XMLList = new XMLList();
			for each(var name:String in names.split(','))
				list += removeFromParent(parent[name][0]);
			return list;
		}
		static public function removeAttributes(parent:XML, names:String):Object {
			var obj:Object = { };
			for each(var name:String in names.split(','))
				obj[name] = StringHelper.autoTypeString(removeAttribute(parent, name));
			return obj;
		}
	}
}