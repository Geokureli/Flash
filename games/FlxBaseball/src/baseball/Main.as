package baseball{
	import baseball.states.editor.EditorState;
	import baseball.states.MenuState;
	import baseball.states.play.GameState;
	import flash.display.Sprite;
	import flash.events.Event;
	import krakel.KrkGame;
	import krakel.KrkState;
	import org.flixel.FlxG;
	import krakel.beat.BeatKeeper;
	import org.flixel.plugin.photonstorm.FlxMouseControl;
	import org.flixel.plugin.photonstorm.FlxScrollZone;
	
	/**
	 * ...
	 * @author George
	 */
	[Frame(factoryClass="baseball.Preloader")]
	public class Main extends KrkGame {
		
		public function Main() {
			
			super(600, 340, MenuState);
		}
		override protected function create(e:Event):void {
			super.create(e);
			FlxG.addPlugin(new FlxScrollZone());
			FlxG.addPlugin(new FlxMouseControl());
			stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
            stage.removeEventListener(Event.ACTIVATE, onFocus);
			FlxG.mouse.show();
			xmlTest();
		}
		override protected function switchState():void {
			super.switchState();
		}
public function xmlTest():void {
// --- DEFINE XML OBJECT
var xmlData:XML = 
	<foobar x="10">
		<man name="Jim" weight="140"/>
		<man name="Joe" weight="180"/>
		<woman name="Jill" weight="don't ask"/>
		<woman name="Jane" weight="don't ask"/>
	</foobar>;
// --- READ foobar ATTRIBUTE x
var x:int = int(xmlData.@x);
trace(x);// output: 10
// --- READ CHILD NODES
trace(xmlData.children()[0].toXMLString());//outputs: <man name="Jim" height=""/>.
// --- NOTICE: "children()" parenthesis 
trace(xmlData.children()[0].@name); // output:Jim\
// --- FIND FIRST WOMAN
trace(xmlData.woman[0].@name); // output:Jill
// --- XMLLIST
var menList:XMLList = xmlData.man; // --- LIST OF ALL CHILDNODES NAMED "man"
trace(menList.toXMLString());
// output:	<man name="Jim" weight="140"/>
//			<man name="Joe" weight="180"/>
trace(menList[1].@weight);//output: 180
// --- SEARCH MEN WITH NAME OF JIM, OUTPUT JIM'S WEIGHT
trace(menList.(@name.toString() == "Jim")[0].@weight);// output: 140

}
	}
	
}