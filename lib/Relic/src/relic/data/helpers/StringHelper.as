package relic.data.helpers {
	/**
	 * ...
	 * @author George
	 */
	public class StringHelper {
		static public const IS_NUMBER:RegExp = /^[0-9]*(\.{1}[0-9]+|[0-9]+)$/,
							IS_UNITS:RegExp = /^[0-9]*(\.{1}[0-9]+|[0-9]+)[a-z]+$/,
							IS_FORCE_STRING:RegExp = /^".*"$/,
							LETTERS:RegExp = /[a-z]+/,
							COMMAS:RegExp = /, */g;
		
		static public const UNIT_CONVERSIONS:Object = {
			s:1000,
			f:1000 / 30
		}
		static public function autoTypeString(value:String):Object {
			if (value.match(IS_FORCE_STRING)) return value.substring(1, -1); 
			if (value.match(IS_NUMBER)) return Number(value);
			if (value.match(IS_UNITS)) return convertUnits(value);
			
			return value;
		}
		static public function convertUnits(value:String):Number {
			var result:Object = LETTERS.exec(value);
			var num:Number = Number(value.substr(0, result.index));
			return num * UNIT_CONVERSIONS[result[0]];
		}
		static public function getArray(target:Object, params:String):Array {
			var arr:Array = [];
			for each(var param:String in params.split(COMMAS))
				arr.push(target[param]);
			return arr;
		}
	}

}