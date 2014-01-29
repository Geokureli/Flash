package picross {
	/**
	 * Hacky Enumerator
	 * @author George
	 */
	public class TileState {
		
		static public function get EMPTY():TileState {	return _empty; }
		static public function get ON():TileState {		return _on; }
		static public function get OFF():TileState {	return _off; }
		
		public var color:int;
		
		public function TileState(color:int, pvt:Class) { 
			if (pvt != PVT)
				throw new Error("Cannot instatiate TileState, use the static constants");
			
			this.color = color;
		}
		
		static private var _empty:TileState;
		static private var _on:TileState;
		static private var _off:TileState;
		
		/* STATIC INIT */ {
			_empty =	new TileState( 0xEEEEEE, PVT);
			_on =		new TileState( 0x000000, PVT);
			_off =		new TileState( 0x808080, PVT);
		}
	}

}

class PVT {}