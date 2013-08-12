package com.nsn.channel.view 
{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite ;
	import flash.events.Event;
	import flash.text.TextField ;
	import flash.events.MouseEvent ;
	
	import com.nsn.channel.view.MainView ;

	/*
	 * A number indicator used with the DataCollectionComponent.
	 */
	
	public class Indicator extends Sprite
	{
		
		private var _items:Array ;
		private var _currentItem:int ;
		
		public function Indicator( ) 
		{
			render( ) ;
		}
		
		// GETTERS/SETTERS
		
		public function get currentItem( ):int
		{
			return _currentItem ;
		}
		
		// PUBLIC METHODS
		
		/*
		 * Add a new number as a new page is created in the component.
		 */
		
		public function addItem( ):void
		{
			createItem( ) ;
		}
		
		// PRIVATE METHODS
		
		private function render( ):void
		{
			_items = new Array( ) ;
			createItem( ) ;
		}
		
		private function createItem( ):void
		{
			var item:Sprite = new Sprite( ) ;
			item.mouseChildren = false ;
			item.buttonMode = item.useHandCursor = true ;
			item.addEventListener( MouseEvent.CLICK, onItemClicked ) ;
			
			var tf:TextField = MainView.getTextField( ) ;
			tf.name = "tf" ;
			tf.htmlText = "<p class='small'>" ;
			
			_items.push( item ) ;
			
			if ( _items.length > 1 )
			{
				item.x = ( ( _items.length - 1 ) * 15 ) ;
			}
			
			tf.htmlText += String( _items.length ) + "</p>" ;
			tf.width = 10 ;
			
			item.addChild( tf ) ;
			addChild( item ) ;
			highlight( item ) 
		}
		
		private function highlight( obj:Object ):void
		{
			var tf:TextField = obj.getChildByName( "tf" ) as TextField ;
			tf.textColor = 0xfe9904 ;	
			
			for ( var i in _items )
			{
				if ( _items[i] != obj )
				{
					tf = _items[i].getChildByName( "tf" ) as TextField ;
					tf.textColor = 0x727072 ;
				}
			}	
		}
		
		// EVENT HANDLERS
		
		private function onItemClicked( e:MouseEvent ):void
		{
			var index:int = _items.indexOf( e.currentTarget ) ;
			_currentItem = index ;
			
			highlight( e.currentTarget ) ;
			
			dispatchEvent( new Event( "onIndicatorChange") ) ;
		}
		
		
	}
	
}