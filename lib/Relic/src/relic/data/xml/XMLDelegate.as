package relic.data.xml {
	import relic.data.helpers.StringHelper;
	/**
	 * ...
	 * @author George
	 */
	public class XMLDelegate {
		static public const USE_XML:String = "useXML",
							USE_OBJECT:String = "useObject",
							NONE:String = null;
		private var method:Function;
		public var type:String;
		private var thisArg:Object;
		public function XMLDelegate(method:Function, type:String = USE_XML, thisArg:Object = null) {
			this.method = method;
		}
		public function call(node:XML, thisArg:Object = null):*{
			var args:Array = [];
			if (thisArg == null)
				thisArg = this.thisArg;
			switch(type) {
				case USE_XML:
					return method.apply(thisArg, node);
				case USE_OBJECT:
					return method.apply(thisArg, XMLParser.setProperties({}, node));
				default:
					for each(var arg:String in type.split(','))
						args.push(StringHelper.autoTypeString(node["@" + arg].toString()));
					return method.apply(thisArg, args);
			}
		}
	}

}