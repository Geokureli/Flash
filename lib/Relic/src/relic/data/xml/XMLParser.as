package relic.data.xml {
	import relic.data.StringHelper;
	/**
	 * ...
	 * @author George
	 */
	public class XMLParser {
		static private const DEFAULT_METHODS:Object = { };
		static public const DEFAULT_ATTRIBUTES:XML = <defaults/>;
		
		protected var methods:Object;
		protected var classes:Object;
		protected var defaultAttributes:XML;
		
		protected var target:Object;
		
		protected var source:XML;
		
		public function XMLParser(source:XML, target:Object) {
			this.target = target;
			this.source = source
			setDefaultProperies()
			preParse();
		}
		
		protected function setDefaultProperies():void {
			methods = { };
			classes = { };
			defaultAttributes = <defaults/>;
		}
		public function preParse():void { }
		public function parse(entry:String = null):void {
			if (entry == null) parseNode(source);
			else parseNode(source.children().(name().toString() == entry))[0];
		}
		protected function parseNode(node:XML):void {
			setDefaultAttributes(node);
			for each(var child:XML in node.children())
				parseNode(child);
		}
		
		
		public function setDefaultAttributes(node:XML):void {
			if (node.name().toString() in defaultAttributes) 
				XMLParser.addAttributes(node, defaultAttributes[node.name().toString()][0]);
			XMLParser.setDefaultAttributes(node);
		}
		
		public function destroy():void {
			methods = null;
			classes = null;
			source = null;
			defaultAttributes = null;
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
			setDefaultAttributes(node);
			for each(var att:XML in node.attributes())
				obj[att.name().toString()] = StringHelper.autoTypeString(att.toString());
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
		static public function setDefaultAttributes(node:XML):void {
			if (node.name().toString() in DEFAULT_ATTRIBUTES) 
				XMLParser.addAttributes(node, DEFAULT_ATTRIBUTES[node.name().toString()][0]);
		}
		
		static public function addAttributes(node:XML, params:XML):void {
			for each(var att:XML in params.attributes())
				node["@" + att.name().toString()] = att.toString();
		}
	}
}