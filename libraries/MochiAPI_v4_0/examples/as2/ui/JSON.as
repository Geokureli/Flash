class ui.JSON
{
    public static function stringify( o ):String
    {
        if( o === null )
            return 'null';

        if( typeof(o) == 'number' || o === true || o === false )
            return o.toString();

        if( typeof(o) == 'string' )
            return escapeString(o);

        var out:String = '';
        var a:Array = new Array();
    
        if( o instanceof Array )
        {
            for( var i:Number = 0; i < o.length; i++ )
                a.push( stringify(o[i]) );
            return "[ " + a.join(", ") + " ]";
        }        
        else
        {
            for( var k:String in o )
                a.push( stringify(k) + ": " + stringify(o[k]) );
            return "{ " + a.join(", ") + " }";
        }
    }

    private static function escapeString( o:String ):String
    {
        var output:String = '';
    
        for( var i:Number = 0; i < o.length; i++ )
        {
            var ch:String = o.charAt(i);
        
            switch( ch )
            {
                case '"':
                    ch = '\\"';
                case '\n':
                    ch = '\\n';
                    break ;
                case '\r':
                    ch = '\\r';
                    break ;
                case '\t':
                    ch = '\\t';
                    break ;
                default:
                    // Encode non-printable, and non-ascii characters
                    if( ch.charCodeAt(0) < 0x20 || ch.charCodeAt(0) >= 0x80 )
                    {
                        ch = ch.charCodeAt(0).toString(16);
                        while( ch.length < 4 )
                            ch = '0' + ch;
                        ch = '\\u' + ch;
                    }
                    break ;
            }
        
            output += ch;
        }
    
    
        return '"' + output + '"';
    }
}
