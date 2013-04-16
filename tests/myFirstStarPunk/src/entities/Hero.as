package entities {
	/**
	 * ...
	 * @author George
	 */
	import com.saia.starlingPunk.SPEntity;
	import com.saia.starlingPunk.utils.Key;
	import com.saia.starlingPunk.utils.SPInput;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.textures.TextureAtlas;
	import starling.textures.Texture;

	public class Hero extends SPEntity {
		[Embed(source = "../../res/textureAtlas.png")] static private const SHEET:Class;
		[Embed(source = "../../res/textureAtlas.xml", mimeType = "application/octet-stream")]static private const SHEET_DATA:Class;
		static private const MAX_HOPS:int = 1;
		
		private var image:Image;
		private var vel:Point,
					acc:Point,
					friction:Point,
					maxVel:Point;
		
		private var r:Boolean, l:Boolean, u:Boolean, _u:Boolean;
		private var onGround:Boolean;
		private var hopsLeft:int;
		
		
		public function Hero(x:Number = 0, y:Number = 0) {
			super(x, y);
			setupGraphic();
			
			acc = new Point(0, 1);
			vel = new Point();
			friction = new Point(.9, 1);
			maxVel = new Point(-1, -1);
			onGround = false;
			
			SPInput.define("right", [Key.RIGHT]);
			SPInput.define("left", [Key.LEFT]);
			SPInput.define("up", [Key.UP]);
			
		}
		private function setupGraphic():void {
			var atlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new SHEET()), XML(new SHEET_DATA()));
			image = new Image(atlas.getTexture("burger"));
			addChild(image);
		}
		
		override public function update():void {
			super.update();
			checkKeys();
			
			acc.x = (r?2:0) - (l?2:0);
			
			if (u && _u && onGround) {
				vel.y = -10;
				onGround = false;
				_u = false;
			} else if (hopsLeft > 0 && u && _u) {
				vel.y = -10;
				hopsLeft--;
				_u = false;
			}
			
			vel.x += acc.x;
			vel.y += acc.y;
			
			if (maxVel.x >= 0) {
				if (vel.x > maxVel.x)		vel.x =  maxVel.x;
				else if (vel.x < -maxVel.x)	vel.x = -maxVel.x;
			}
			if (maxVel.y >= 0) {
				if (vel.y > maxVel.y)		vel.y =  maxVel.y;
				else if (vel.y < -maxVel.y)	vel.y = -maxVel.y;
			}
			
			x += vel.x;
			y += vel.y;
			if(isDecelX) vel.x *= friction.x;
			if(isDecelY ) vel.y *= friction.y;
			
			if (x < 0) {
				vel.x = 0;
				x = 0;
			}
			if (x + width > stage.stageWidth) {
				vel.x = 0;
				x = stage.stageWidth - width;
			}
			if (y + height > stage.stageHeight) {
				onGround = true;
				hopsLeft = MAX_HOPS;
				vel.y = 0;
				y = stage.stageHeight - height;
			}
		}
		
		private function get isDecelX():Boolean {
			return vel.x > 0 == acc.x < 0 && vel.x != 0;
		}
		private function get isDecelY():Boolean {
			return vel.y > 0 == acc.y < 0 && vel.y != 0;
		}
		
		private function checkKeys():void {
			r = SPInput.check("right");
			l = SPInput.check("left");
			u = SPInput.check("up");
			if (!u) _u = true;
		}
	}

}