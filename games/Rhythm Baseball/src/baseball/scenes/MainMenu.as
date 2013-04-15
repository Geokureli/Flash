package baseball.scenes 
{
	import baseball.Imports;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import relic.art.blitting.BlitScene;
	import relic.art.Text;
	import relic.events.SceneEvent;
	import relic.Global;
	/**
	 * ...
	 * @author George
	 */
	public class MainMenu extends BlitScene {
		public function MainMenu() { super(); }
		override protected function addStaticChildren():void {
			super.addStaticChildren();
			
			place(assets.add(new Text("This is a test, 123. '!$' "), "header")).setParameters( { x:150, y:10} );
			
			place(assets.add(new Btn("Level Editor"	), "btn_editor"	)).setParameters( { y:50  } ).addEventListener(MouseEvent.CLICK, btnClick );
			place(assets.add(new Btn("TMOTTBG"		), "btn_test"	)).setParameters( { y:100 } ).addEventListener(MouseEvent.CLICK, testClick);
			place(assets.add(new Btn("Charge Mode"	), "btn_charge"	)).setParameters( { y:150 } ).addEventListener(MouseEvent.CLICK, btnClick );
		}
		
		private function testClick(e:MouseEvent):void {
			Global.VARS.userLevel = new XML(new Imports.Level1);
			dispatchEvent(new SceneEvent(SceneEvent.SCENE_CHANGE, { next:e.currentTarget.name } ));
		}
		
		private function btnClick(e:MouseEvent):void {
			dispatchEvent(new SceneEvent(SceneEvent.SCENE_CHANGE, { next:e.currentTarget.name } ));
		}
	}

}
import baseball.Imports;
import relic.art.blitting.AnimatedBlit;
import relic.art.Button;
class Btn extends Button {
	
	public function Btn(txt:String) {
		super(new AnimatedBlit(Imports.BtnTemplate));
	}
	
	override protected function setDefaultValues():void {
		super.setDefaultValues();
		x = 200;
		y = 50;
		width = 200;
		height = 30;
	}
}