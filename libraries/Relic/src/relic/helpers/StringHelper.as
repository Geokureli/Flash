package relic.helpers {
	/**
	 * ...
	 * @author George
	 */
	public class StringHelper {
		static public const IS_NUMBER:RegExp = /^\s*[0-9]*(\.{1}[0-9]+|[0-9]+)\s*$/,
							IS_UNITS:RegExp = /^\s*[0-9]*(\.{1}[0-9]+|[0-9]+)\s*[a-z]+\s*$/,
							IS_COLOR:RegExp = /^(0x|#)[0-9A-Fa-f]{1,8}$/,
							IS_FORCE_STRING:RegExp = /^\s*['"].*['"]\s*$/,
							IS_FORCE_XML:RegExp = /^\s*xml:.+$/,
							IS_ARRAY:RegExp = /^.+,.+,.+$/,
							IS_OBJECT:RegExp = /^\s*{+(\s*\w+\s*+:\s*\w+\s*(,|}))+\s*$/,
							LETTERS:RegExp = /[a-z]+/,
							COMMAS:RegExp = /\s*,\s*/g,
							OUTER_BRACKETS:RegExp = /(^\s*{\s*)|(\s*}\s*$)/g;
		
		static public const UNIT_CONVERSIONS:Object = {
			s:1000,
			f:1000 / 30
		}
		static public function AutoTypeString(value:String):Object {
			if (value.match(IS_FORCE_STRING)) return value.substring(1, -1);
			if (value.match(IS_FORCE_XML)) return value.substring(4, -1);
			if (value.match(IS_NUMBER)) return Number(value);
			if (value.match(IS_COLOR)) return parseInt(value.split(/^(0x|#)/)[1], 16);
			if (value.match(IS_UNITS)) return ConvertUnits(value);
			if (value.match(IS_ARRAY)) return ConvertToArray(value);
			if (value.match(IS_OBJECT)) return ConvertToObject(value);
			
			return value;
		}
		static public function ConvertUnits(value:String):Number {
			var result:Object = LETTERS.exec(value);
			var num:Number = Number(value.substr(0, result.index));
			return num * UNIT_CONVERSIONS[result[0]];
		}
		static public function ConvertToArray(value:String):Array {
			var arr:Array = value.split(COMMAS);
			
			for (var i:String in arr)
				arr[i] = AutoTypeString(arr[i]);
			
			return arr;
		}
		static public function ConvertToObject(value:String):Object {
			var arr:Array = value.split(OUTER_BRACKETS)[1].split(COMMAS);
			var obj:Object = { };
			var split:Array;
			
			for (var i:String in arr) {
				
				split = arr[i].split(/\s*:\s*/);
				obj[split[0]] = AutoTypeString(split[1]);
			}
			return obj;
		}
		static public function getArray(target:Object, params:String):Array {
			var arr:Array = [];
			
			for each(var param:String in params.split(COMMAS))
				arr.push(target[param]);
				
			return arr;
		}
		static public function parseID(id:String):String {
			return id.split('_').pop();
		}
	}

}