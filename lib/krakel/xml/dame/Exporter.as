package krakel.xml.dame {
	/**
	 * Serializes and exports all data in a .dam
	 * @author George
	 */
	public class Exporter extends DameParser {
		private var exportPath:String;
		
		public function Exporter(project:XML, exportPath:String) {
			super(project);
			this.exportPath = exportPath;
			
		}
	}
}