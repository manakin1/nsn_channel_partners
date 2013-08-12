package com.nsn.channel.view.pages 
{
	
	import flash.display.MovieClip ;
	import flash.display.Sprite ;
	import flash.events.MouseEvent ;
	import flash.utils.Dictionary ;
	
	import com.nsn.channel.model.Constants ;
	import com.nsn.channel.control.MainController ;
	import com.nsn.channel.view.GridColumn ;
	import com.nsn.channel.view.MainView ;
	import com.nsn.channel.model.MainModel ;
	import com.nsn.channel.events.ApplicationEvent ;
	
	/*
	 * A page template that lays out the items in a 2x2 grid.
	 */
	
	public class GridPage extends Page
	{
		
		private var _separators:Array ;
		private var _maxContentHeight:Number			= 425 ;
		
		public function GridPage( cat_id:String, data:XML ) 
		{
			super( cat_id, data ) ;
		}
		
		// PUBLIC METHODS
		
		override public function saveData( ):void
		{
			if ( !_presentationData )
			{
				_presentationData = new Array( ) ;
				
			}
		}
		
		// PRIVATE METHODS
		
		override protected function render( ):void
		{
			renderTitle( ) ;
			renderHeader( ) ;
			renderItems( ) ;
			renderColumns( ) ;
			renderSeparators( ) ;
			setTooltip( ) ;
		}
		
		override protected function renderTitle( ):void
		{
			_title = MainView.getTextField( ) ;
			_title.width = 600 ;
			_title.htmlText = _data.title.text.text( ) ;	
			
			_title.x = 15 ;
			_title.y = 25 ;
			
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
		
		protected function renderColumns( ):void
		{
			_columns = new Array( ) ;
						
			for ( var i in _data.column )
			{
				_columns[i] = new GridColumn( _id, _data.column[i] ) ;
				_columns[i].populate( getColumnChildren( i ) ) ;
				addChild( _columns[i] ) ;
				
				if( i == 0 ) _columns[i].x = _title.x ;
				
				else
				{
					if ( int( _data.column[i].@x ) > 0 )
					{
						_columns[i].x = int( _data.column[i].@x ) ;
					}
					
					else _columns[i].x = _title.x ;
				}
				
				if ( int( _data.column[i].@y ) > 0 )
				{
					_columns[i].y = int( _data.column[i].@y ) ;	
				}
				
				else
				{
					_columns[i].y = _title.y + _title.textHeight + 10 ;
				}
			}
		}
		
		private function renderSeparators( ):void
		{
			_separators = new Array( ) ;
			
			for ( var i in _data.separator )
			{			
				_separators[i] = new Separator( ) ;
				_separators[i].x = int( _data.separator[i].@x ) ;
				_separators[i].height = _maxContentHeight ;
				addChild( _separators[i] ) ;
				
				if( _header ) _separators[i].y = _header.y + _header.textHeight + 20 ;
				else _separators[i].y = _title.y + _title.textHeight + 20 ;
			}
		}
		
		override protected function showInfo( e:MouseEvent ):void
		{
			dispatchEvent( new ApplicationEvent( ApplicationEvent.SHOW_INFO, _data.title.info.text( ), true ) ) ;
		}
		
	}
	
}