package relic.data.xml {
	import relic.art.Asset;
	import relic.art.blitting.Blit;
	/**
	 * ...
	 * @author George
	 */
	public class XMLClasses {
		static public const CLASS_REFS:Object = {
			Asset:	new ClassRef(Asset),
			Blit:	new ClassRef(Blit)
		}
		static public function createObject(node:XML):Object {
			return CLASS_REFS[node.name().toString()].create(node);
		}
	}

}
class CLassDef {
	public var constructor:String;
	public var type:Class;
	public function ClassDef(type:Class, contructor:String = XMLDelegate.NONE) {
		this.type = type;
		this.constructor = constructor;
	}
	public function create(node:XML):Object {
		var params:Object = XMLParser.setProperties({}, node);
		switch(constructor) {
			case USE_XML:		return new type(node);
			case USE_OBJECT:	return new type(XMLParser.setProperties( { }, node));
			case NONE:
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