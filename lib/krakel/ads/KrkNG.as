package krakel.ads {
	import com.newgrounds.API;
	import flash.display.Stage;
	/**
	 * ...
	 * @author George
	 */
	public class KrkNG {
		
		static public function connect(stage:Stage, apiId:String, encryptionKey:String, movieVersion:String = null):void {
			API.connect(stage, apiId, encryptionKey, movieVersion);
		}
		
	}

}