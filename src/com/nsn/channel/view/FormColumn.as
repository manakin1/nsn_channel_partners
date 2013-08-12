package com.nsn.channel.view 
{

	import flash.text.TextField ;
	import flash.display.Sprite ;
	import flash.utils.getDefinitionByName ;
	
	import com.nsn.channel.view.forms.Form ;
	import com.nsn.channel.interfaces.IForm ;
	
	/*
	 * A column container that can be equalized to match the layout of other columns on the page.
	 */
	
	public class FormColumn extends Column
	{
		
		public function FormColumn( page_id:String, data:XML ) 
		{
			super( page_id, data ) ;
		}
		
		// PUBLIC METHODS
		
		public function setFormPosition( item_y:Number, item_h = 0 ):void
		{
			for ( var i in _items )
			{
				if ( item_h == 0 ) item_h = _items[i].getHeight( ) + 15 ;
				if ( i == 0 ) _items[i].y = item_y ;
				else _items[i].y = _items[0].y + ( i * item_h ) ;	
			}
			
			_title.y = _items[0].y - _items[0].getLabelHeight( ) - _title.textHeight - 5 ;
		}
		
		// PRIVATE METHODS
		
		override public function populate( item_arr:Array ):void
		{
			_items = item_arr ;
			var w:Number = 0 ;
			
			for ( var i in _items )
			{
				addChild( _items[i] ) ;
				
				if ( _items[i].getWidth( ) > w ) w = _items[i].getWidth( ) ;
			}
			
			_title.width = w ;
			setFormPosition( _title.textHeight ) ;
		}
		
	}
	
}