package relic.data.xml {
	/**
	 * ...
	 * @author George
	 */
	
	public class XMLClassDef {
		public var constructor:String;
		public var type:Class;
		public function XMLClassDef(type:Class, contructor:String = null) {
			this.type = type;
			this.constructor = constructor;
		}
		public function create(node:XML):Object {
			var params:Object = XMLParser.setProperties({}, node);
			switch(constructor) {
				case XMLDelegate.USE_XML:		return new type(node);
				case XMLDelegate.USE_OBJECT:	return new type(XMLParser.setProperties( { }, node));
				case XMLDelegate.NONE:
					var obj:IXMLParam = new type();
					obj.setParameters(node);
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