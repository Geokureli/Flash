import mochi.as2.*;
import ui.*;

class Coins
{
    public static var inventory:Object;
    public static var giftables:Array;
    
    public static function init():Void
    {
        // We create an empty bundle
        inventory = new Object();

        MochiSocial.addEventListener( MochiSocial.LOGGED_IN, clearInventory );
        MochiSocial.addEventListener( MochiSocial.LOGGED_OUT, clearInventory );

        MochiCoins.addEventListener( MochiCoins.ITEM_NEW, onNewItems );
        MochiCoins.addEventListener( MochiCoins.ITEM_OWNED, onItemOwned );
        MochiCoins.addEventListener( MochiCoins.STORE_ITEMS, onStoreInfo );                        

        MochiCoins.getStoreItems();
    }

    public static function get menu():Menu
    {
        var menu:Array = [ 
            new MenuItem( sellEverything, 'Show the game store' ),
            new MenuItem( doFundingRequest, 'Offer user coins' ),
            new MenuItem( Core.returnToMain, 'Return to Main Menu' )                
         ];
        
        for( var id:String in inventory )
        {
            var item:Object = inventory[id];
         
            if( item.demoVideo )
                menu.unshift( itemVideoOption( id ) );
            
            menu.unshift( itemMenuOption( id ) );
        }

        return new Menu( "MochiCoins API Demonstration", menu );
    }
    
    public static function doFundingRequest():Void
    {
        MochiCoins.requestFunding({});
    }
    
    private static function sellEverything():Void
    {
        MochiCoins.showStore({});
    }

    private static function itemMenuOption( id:String ):MenuItem
    {
        var funct:Function = function():Void
        { 
            MochiCoins.showItem( { 
                item: id
            } );
        };
        
        return new MenuItem( funct, "Buy " + Coins.inventory[id].name, Coins.inventory[id].imgURL );
    }
    
    private static function itemVideoOption( id:String ):MenuItem
    {
        var funct:Function = function():Void
        { 
            MochiCoins.showVideo( {
                item: id
            } ); 
        };
        
        return new MenuItem( funct, "Watch video for " + Coins.inventory[id].name );
    }
    
    private static function clearInventory( args:Object ):Void
    {
        // We clear the number of owned items to zero
        // NOTE: We do not reset inventory, as we keep our store information here
        if( !inventory )
            return ;
        
        for( var key:String in inventory )
            inventory[key].count.value = 0;
    }

    private static function onStoreInfo( store:Array ):Void
    {
        // Note: This gives an accurate snapshot of the user's inventory
        inventory = new Object();
        giftables = new Array();
        
        for( var i:Number = 0; i < store.length; i++ )
        {
            var item:Object = store[i];
            var id:String = item.id;
            
            inventory[id] = new Object();

            if( item.privateProperties.gift_item )
                giftables.push(id);

            // Copy over all the known properties of the item
            for( var key:String in item )
            {
                // We protect our numerical values from memory tampering!
                if( typeof(item[key]) == 'number' )
                    inventory[id][key] = new MochiDigits( item[key] );
                else
                    inventory[id][key] = item[key];
            }
            
            if( !inventory[id].count )
                inventory[id].count = new MochiDigits( 0 );
        }
    }

    private static function onNewItems( item:Object ):Void
    {
        // New items are items purchased while the game is running.  We
        // increment existing inventory by count purchased.  Likewise,
        // we will be create an empty entry if one does not yet exist
        
        Core.popup( "Purchased " + item.count + "x " + inventory[item.id].name + "(s)!" );
        
        if( !inventory[item.id] )
            inventory[item.id] = { count: new MochiDigits(item.count) };
        else            
            inventory[item.id].count.value += item.count;

        // Refresh the menu
        Menu.menu = menu;
    }
    
    private static function onItemOwned( item:Object ):Void
    {
        // Item owned is sent when an existing item was purchased in a prior
        // session.  the item object will contain the absolute number of items
        // owned, rather than the ammount gained
        
        if( !inventory[item.id] )
            inventory[item.id] = { count: new MochiDigits(item.count) };            
        else
            inventory[item.id].count.value = item.count;
    }
}
