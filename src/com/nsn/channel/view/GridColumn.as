package com.nsn.channel.view 
{

	import flash.display.MovieClip;
	import flash.display.Sprite ;
	import flash.text.TextField ;
	import flash.events.Event ;
	import flash.events.MouseEvent ;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName ;
	
	import com.nsn.channel.view.forms.Form ;
	import com.nsn.channel.interfaces.IForm;
	import com.nsn.channel.events.ApplicationEvent ;
	
	/*
	 * A column container used on the Grid page.
	 */
	
	public class GridColumn extends Sprite
	{
		
		protected var _data:XML ; 
		protected var _id:String ;
		protected var _items:Array ;
		protected var _infoButton:MovieClip ;
		protected var _title:TextField ;
		protected var _spacer:Number				= 0 ;
		
		public function GridColumn( page_id:String, data:XML ) 
		{
			_data = data ;
			_id = page_id + "_" + data.@id ;
			setTitle( ) ;
			setTooltip( ) ;
		}
		
		// PUBLIC METHODS
		
		public function getTitleHeight( ):Number
		{
			return _title.textHeight ;
		}
		
		public function populate( item_arr:Array ):void
		{
			_items = item_arr ;
			var w:Number = 0 ;
			
			for ( var i in _items )
			{
				addChild( _items[i] ) ;
				_items[i].x = 20 ;
				
				if ( _items[i].width > w ) w = _items[i].width ;
				
				if ( i == 0 ) _items[i].y = 0 ;
				else _items[i].y = _items[ i - 1 ].y + _items[ i - 1 ].getHeight( ) + _spacer ;
			}
		}
		
		// PRIVATE METHODS
		
		protected function setTitle( ):void
		{
			_title = MainView.getTextField( true ) ;
			_title.width = 300 ;
			_title.htmlText = _data.title.text( ) ;
			addChild( _title ) ;
		}
		
		private function setTooltip( ):void
		{
			if ( String( _data.info.text( ) ).length > 0 )
			{
				_infoButton = MainView.getInfoButton( this ) ;
				_infoButton.x = _title.textWidth + 10 ;
				addChild( _infoButton ) ;
			}
		}
		
		// EVENT HANDLERS
		
		public function showInfo( e:Event = null ):void
		{
			dispatchEvent( new ApplicationEvent( ApplicationEvent.SHOW_INFO, _data.info.text( ), true ) ) ;
		}
		
		
	}
	
}