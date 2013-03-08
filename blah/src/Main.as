/**
 * ...
 * @author George
 */
class Main 
{
	private var bubMC:MovieClip;
	
	public static function main(swfRoot:MovieClip):Void 
	{
		// entry point
	}
	
	public function Main() 
	{
		bubMC = new MovieClip();
		bubMC.beginFill(0);
		
	}
	
	
	oyenteSalto.onKeyDown = function():Void
	{
		if (bubMC.hitTest(fase_mc)) grounded = true
		function saltoPulsado() {
			/*si el jugador pulsa la barra de espacio mientras el personaje estÃ¡ pisando
			el suelo*/
			if(Key.getCode()==32&&grounded==true)botnSalto =false;
		}
		//si el jugador suelta la barra de espacio
		if (Key.getCode() == 32 && grounded == true)
			botnSalto = true;
		}
		onEnterFrame = function () {
			//mueve al personaje acorde a su velocidad
			if(!grounded)verticalSpeed += 2;//gravedad
			bubMC.y+=bubMC.verticalSpeed;
			//mientras el jugador pulsa la barra espaciadora, se incrementa su velocidad en y
			if (botnSalto) bubMC.verticalSpeed+=5;
			/*si hay mucha velocidad, se desactiva el botÃ³nSalto.
			El jugador no puede empezar de nuevo hasta que el personaje no toque el suelo.*/
			if (bubMC.verticalSpeed >= 20)
				botnSalto=false;
		};
	Key.addListener(oyenteSalto);
}
}