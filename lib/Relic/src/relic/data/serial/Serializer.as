package relic.data.serial {
	import relic.art.Asset;
	import relic.art.blitting.AnimatedBlit;
	import relic.art.blitting.Blit;
	import relic.data.serial.ClassDef;
	/**
	 * ...
	 * @author George
	 */
	public class Serializer {
		static public const CLASS_REFS:Object = {
			//STRING		CLASS
			Asset:			new ClassDef(Asset),
			Blit:			new ClassDef(Blit),
			AnimatedBlit:	new ClassDef(AnimatedBlit)
		}
		static public function addRef(type:Class, name:String):void {
			CLASS_REFS[name] = new ClassDef(type);
		}
		static public function createXMLObject(node:XML):Object {
			return createObject(node.name().toString(), node);
		}
		static public function createObject(type:String, params:Object):Object {
			return CLASS_REFS[type].create(params);
		}
		
		static public function checkEquality(obj1:Object, obj2:Object):Boolean {
			for (var i:String in obj1)
				
				if (!(i in obj2) || obj1[i] != obj2[i]) return false;
			
			return true;
		}
	}

}