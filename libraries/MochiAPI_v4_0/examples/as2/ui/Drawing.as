class ui.Drawing {
    public static function drawBox( target:Object, x:Number, y:Number, w:Number, h:Number ):Void
    {
        target.moveTo(x, y);
        target.lineTo(x + w, y);
        target.lineTo(x + w, y+h);
        target.lineTo(x, y+h);
        target.lineTo(x, y);
    }

    public static function drawRoundedBox(target:Object, x:Number, y:Number, w:Number, h:Number, radius:Number ):Void
    {
        // Magic numbers ahoy!
        var inv_off:Number = 1 - 0.6;
        var inv_circ:Number = 1 - 0.707107;

        target.moveTo(x,y+radius);
        target.lineTo(x,y+h-radius);
        target.curveTo(x,y+(h-radius)+radius*inv_off,x+inv_circ*radius,y+h-inv_circ*radius);
        target.curveTo(x+radius-radius*inv_off,y+h,x+radius,y+h);

        target.lineTo(x+w-radius,y+h);
        target.curveTo(x+(w-radius)+radius*inv_off,y+h,x+w-inv_circ*radius,y+h-inv_circ*radius);
        target.curveTo(x+w,y+(h-radius)+radius*inv_off,x+w,y+h-radius);

        target.lineTo(x + w, y + radius);
        target.curveTo(x+w, y+radius-radius*inv_off,x+w-inv_circ*radius,y+inv_circ*radius);
        target.curveTo(x+(w-radius)+radius*inv_off,y,x+w-radius,y);

        target.lineTo(x+radius,y);
        target.curveTo(x+radius-radius*inv_off,y,x+inv_circ*radius,y+inv_circ*radius);
        target.curveTo(x, y+radius-radius*inv_off,x,y+radius);
    }
}
