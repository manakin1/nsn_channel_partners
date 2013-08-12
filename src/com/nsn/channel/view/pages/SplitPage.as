package com.nsn.channel.view.pages 
{
	
	import flash.display.MovieClip ;
	import flash.display.Sprite ;
	import flash.utils.Dictionary ;
	
	import com.nsn.channel.model.Constants ;
	import com.nsn.channel.control.MainController ;
	import com.nsn.channel.view.Column ;
	import com.nsn.channel.model.MainModel ;
	
	/*
	 * A page template that is split into two or more columns.
	 */
	
	public class SplitPage extends Page
	{
		
		private var _separators:Array ;
		private var _maxContentHeight:Number			= 375 ;
		
		public function SplitPage( cat_id:String, data:XML ) 
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
		}
		
		protected function renderColumns( ):void
		{
			_columns = new Array( ) ;
						
			for ( var i in _data.column )
			{
				_columns[i] = new Column( _id, _data.column[i] ) ;
				_columns[i].populate( getColumnChildren( i ) ) ;
				addChild( _columns[i] ) ;
				
				if( i == 0 ) _columns[i].x = _title.x ;
				
				else
				{
					if ( int( _data.column[i].@x ) > 0 )
					{
						_columns[i].x = int( _data.column[i].@x ) ;
					}
					
					else _columns[i].x = 420 ;
				}
				
				if ( _header ) _columns[i].y = _header.y + _header.textHeight + 20 ;
				else _columns[i].y = _title.y + _title.textHeight + 20 ;
			}
		}
		
		private function renderSeparators( ):void
		{
			_separators = new Array( ) ;
			
			for ( var i in _data.separator )
			{			
				_separators[i] = new Separator( ) ;
				_separators[i].x = int( _data.separator[i].@x ) ;
				_separators[i].height = Math.max( _columns[0].height, _columns[1].height ) ;
				_separators[i].height = Math.min( _maxContentHeight, _separators[i].height ) ;
				addChild( _separators[i] ) ;
				
				if( _header ) _separators[i].y = _header.y + _header.textHeight + 20 ;
				else _separators[i].y = _title.y + _title.textHeight + 20 ;
			}
		}
		
		
	}
	
}