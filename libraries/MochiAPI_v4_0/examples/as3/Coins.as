package
{
    import mochi.as3.*;
    import ui.*;
    
    public class Coins
    {
        public static var inventory:Object;
        public static var giftables:Array;
        
        public static function init():void
        {
            // We create an empty bundle
            inventory = new Object();

            MochiSocial.addEventListener( MochiSocial.LOGGED_IN, clearInventory );
            MochiSocial.addEventListener( MochiSocial.LOGGED_OUT, clearInventory );

            MochiCoins.addEventListener( MochiCoins.ITEM_NEW, onNewItems );
            MochiCoins.addEventListener( MochiCoins.ITEM_OWNED, onItemOwned );
            MochiCoins.addEventListener( MochiCoins.STORE_ITEMS, onStoreInfo );                        
        }

        public static function get menu():Menu
        {
            MochiCoins.getStoreItems();

            var menu:Array = [ 
                new MenuItem( sellEverything, 'Show the game store' ),
                new MenuItem( doFundingRequest, 'Offer user coins' ),
                new MenuItem( Core.returnToMain, 'Return to Main Menu' )                
             ];
            
            for each( var item:Object in inventory )
            {
                if( item.demoVideo )
                    menu.unshift( itemVideoOption( item.id ) );
                
                if( item.consumable )
                    menu.unshift( itemConsumeOption( item.id ) );
                
                menu.unshift( itemMenuOption( item.id ) );
            }

            return new Menu( "MochiCoins API Demonstration", menu );
        }
        
        public static function doFundingRequest(e:* = null):void
        {
            MochiCoins.requestFunding({});
        }
        
        private static function sellEverything( e:* = null ):void
        {
            MochiCoins.showStore({});
        }

        private static function itemConsumeOption( id:String ):MenuItem
        {
            var funct:Function = function( e:* = null ):void
            { 
                // Eat an item!
                MochiCoins.inventory[id] -= 1;
                Core.MainMenu.menu = Coins.menu;
            };
            
            return new MenuItem( funct, "Consume " + Coins.inventory[id].name + " (have " + MochiCoins.inventory[id] + ")", Coins.inventory[id].imgURL );
        }
        
        private static function itemMenuOption( id:String ):MenuItem
        {
            var funct:Function = function( e:* = null ):void
            { 
                MochiCoins.showItem( { 
                    item: id
                } );
            };
            
            return new MenuItem( funct, "Buy " + Coins.inventory[id].name, Coins.inventory[id].imgURL );
        }
        
        private static function itemVideoOption( id:String ):MenuItem
        {
            var funct:Function = function( e:* = null ):void
            { 
                MochiCoins.showVideo( {
                    item: id
                } ); 
            };
            
            return new MenuItem( funct, "Watch video for " + Coins.inventory[id].name );
        }
        
        private static function clearInventory( args:Object ):void
        {
            // Force store update when inventory is cleared
            MochiCoins.getStoreItems();

            // We clear the number of owned items to zero
            // NOTE: We do not reset inventory, as we keep our store information here
            if( !inventory )
                return ;
            
            for( var key:String in inventory )
                inventory[key].count.value = 0;
        }

        private static function onStoreInfo( store:Array ):void
        {
            // Note: This gives an accurate snapshot of the user's inventory
            inventory = new Object();
            giftables = new Array();
            
            for each( var item:Object in store )
            {
                var id:String = item.id;
                
                inventory[id] = new Object();

                if( item.privateProperties.gift_item )
                    giftables.push(id);

                insertItem( id, item );
            }
        }
        
        private static function insertItem( id:String, item:Object ):void
        {
            if( inventory[item.id] === undefined )
                inventory[item.id] = {}

            // Copy over all the known properties of the item
            for( var key:String in item )
            {
                // We protect our numerical values from memory tampering!
                if( item[key] is Number )
                    inventory[id][key] = new MochiDigits( item[key] );
                else
                    inventory[id][key] = item[key];
            }

            if( !item.count )
                inventory[item.id].count = new MochiDigits( 0 );
        }

        private static function onNewItems( item:Object ):void
        {
            // New items are items purchased while the game is running.  We
            // increment existing inventory by count purchased.  Likewise,
            // we will be create an empty entry if one does not yet exist
            
            Core.popup( "Purchased " + item.count + "x " + inventory[item.id].name + "(s)!" );
            
            if( !inventory[item.id] )
            {
                inventory[item.id] = { count: new MochiDigits(item.count) };
            }
            else            
                inventory[item.id].count.value += item.count;

            // Refresh the menu
            Core.MainMenu.menu = menu;
        }
        
        private static function onItemOwned( item:Object ):void
        {
            // Item owned is sent when an existing item was purchased in a prior
            // session.  the item object will contain the absolute number of items
            // owned, rather than the ammount gained
            
            insertItem( item.id, item );
        }
    }
}