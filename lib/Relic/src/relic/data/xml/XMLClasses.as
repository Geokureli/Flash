package relic.data.xml {
	import relic.art.Asset;
	import relic.art.blitting.Blit;
	/**
	 * ...
	 * @author George
	 */
	public class XMLClasses {
		static public const CLASS_REFS:Object = {
			Asset:	new XMLClassDef(Asset),
			Blit:	new XMLClassDef(Blit)
		}
		static public function addRef(type:Class, name:String):void {
			CLASS_REFS[name] = new XMLClassDef(type);
		}
		static public function createObject(node:XML):Object {
			return CLASS_REFS[node.name().toString()].create(node);
		}
	}

}