package ui
{
    public class JSON
    {
        public static function stringify( o:* ):String
        {
            if( o === null )
                return 'null';

            if( o is Number || o === true || o === false )
                return o.toString();

            if( o is String )
                return escapeString(o as String);

            var out:String = '';
            var a:Array = new Array();
        
            if( o is Array )
            {
                for each( var e:* in o as Array )
                    a.push( stringify(e) );
                return "[ " + a.join(", ") + " ]";
            }        
            if( o is Object )
            {
                for( var k:String in o )
                    a.push( stringify(k) + ": " + stringify(o[k]) );
                return "{ " + a.join(", ") + " }";
            }
            
            throw new Error( "Unable to decode type: " + typeof(o) );
        }
    
        private static function escapeString( o:String ):String
        {
            var output:String = '';
        
            for( var i:int = 0; i < o.length; i++ )
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
}