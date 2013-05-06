package krakel.jump {
	import krakel.KrkProp;
	import krakel.xml.KrkControlScheme;
	
	/**
	 * ...
	 * @author George
	 */
	public class JumpScheme extends KrkControlScheme {
		
		public var l:Boolean, _l:Boolean,
					r:Boolean, _r:Boolean,
					u:Boolean, _u:Boolean,
					d:Boolean, _d:Boolean;
		
		public function JumpScheme(target:KrkProp) { super(target); }
		
	}

}