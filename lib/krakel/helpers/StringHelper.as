package krakel.helpers {
	import krakel.KrkSprite;
	import org.flixel.FlxObject;
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
							IS_OBJECT:RegExp = /^\s*{+\s*(.*)\s*}+\s*$/,
							LETTERS:RegExp = /[a-z]+/,
							COMMAS:RegExp = /\s*,\s*/g,
							OUTER_BRACKETS:RegExp = /(^\s*{\s*)|(\s*}\s*$)/g,
							FILEPATH_NAME:RegExp = /(?<=\/)[^\/]*(?=\..*$)/;
		
		static public const CONSTANTS:Object = {
			"true"	:true,
			"false"	:false,
			CEILING	:FlxObject.CEILING,
			FLOOR	:FlxObject.FLOOR,
			ANY		:FlxObject.ANY,
			WALL	:FlxObject.WALL,
			LEFT	:FlxObject.LEFT,
			RIGHT	:FlxObject.RIGHT,
			DOWN	:FlxObject.DOWN,
			UP		:FlxObject.UP,
			NONE	:FlxObject.NONE,
			PATH_FORWARD			:FlxObject.PATH_FORWARD,
			PATH_BACKWARD			:FlxObject.PATH_BACKWARD,
			PATH_LOOP_FORWARD		:FlxObject.PATH_LOOP_FORWARD,
			PATH_LOOP_BACKWARD		:FlxObject.PATH_LOOP_BACKWARD,
			PATH_YOYO				:FlxObject.PATH_YOYO,
			PATH_HORIZONTAL_ONLY	:FlxObject.PATH_HORIZONTAL_ONLY,
			PATH_VERTICAL_ONLY		:FlxObject.PATH_VERTICAL_ONLY,
			TILE:		KrkSprite.TILE,
			STRETCH:	KrkSprite.STRETCH
		};
		
		static public const UNIT_CONVERSIONS:Object = {
			s:1000,
			f:1000 / 30
		}
		static public function AutoTypeString(value:String):Object {
			if (value.match(IS_FORCE_STRING)) return value.substring(1, -1);
			if (value in CONSTANTS) return CONSTANTS[value];
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
			var arr:Array = value.match(IS_OBJECT)[1].split(COMMAS);
			var obj:Object = { };
			var groups:Array;
			
			for (var i:String in arr) {
				groups = arr[i].match(/^\s*([^:]*)\s*:\s*(.*)\s*$/);
				obj[groups[1]] = AutoTypeString(groups[2]);
			}
			return obj;
		}
		static public function splitTopLevel(value:String):Array {
			var open:int, close:int, comma:int, i:int = 0, stack:int = 0;
			var before:String;
			open = value.indexOf("{");
			close = value.indexOf("}");
			if (open == -1) return value.split(COMMAS);
			var commas:Vector.<int>;
			while (i < open) {
				i = value.indexOf(',', i);
				if (i == -1) break;
				commas.push(i);
				i++;
			}
			// --- parse top level commas
			return null
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