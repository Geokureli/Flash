package relic.serial {
	import relic.xml.XMLParser;
	import relic.xml.XMLDelegate;
	/**
	 * ...
	 * @author George
	 */
	
	public class ClassDef {
		public var constructor:String;
		public var type:Class;
		public function ClassDef(type:Class, contructor:String = null) {
			this.type = type;
			this.constructor = constructor;
		}
		public function create(params:Object):Object {
			if (params is XML)
				var node:XML = params as XML;
			switch(constructor) {
				case XMLDelegate.USE_XML:		return new type(node);
				case XMLDelegate.USE_OBJECT:	return new type(XMLParser.setProperties( { }, node));
				case XMLDelegate.NONE:
					var obj:IXMLParam = new type();
					obj.setParameters(params);
					return obj;
				default:
					if(/,/.test(constructor)) throw new Error("Multiple constructor arguments isn't possible yet");
					//for each(var arg:String in type.split(','))
						//args.push(StringHelper.autoTypeString(node["@" + arg].toString()));
					return new type(node['@'+constructor]);
			}
		}
	}

}