package com.nsn.channel.view.pages 
{
	
	import flash.display.MovieClip ;
	
	import com.nsn.channel.model.Constants ;
	import com.nsn.channel.view.FormColumn ;

	/*
	 * A page template that lays out the items in a number of columns.
	 */
	
	public class ColumnPage extends Page
	{
		
		private var _spacer:int					= 10 ;
		
		public function ColumnPage( cat_id:String, data:XML ) 
		{
			super( cat_id, data ) ;
		}
		
		// PUBLIC METHODS
		
		// PRIVATE METHODS
		
		override protected function render( ):void
		{
			renderTitle( ) ;
			renderHeader( ) ;
			renderItems( ) ;
			renderColumns( ) ;
		}
		
		private function renderColumns( ):void
		{
			_columns = new Array( ) ;
			var item_y:Number = 30 ;
			
			for ( var i in _data.column )
			{
				_columns[i] = new FormColumn( _id, _data.column[i] ) ;
				_columns[i].y = 180 ;
				_columns[i].populate( getColumnChildren( i ) ) ;
				addChild( _columns[i] ) ;
				
				if ( i == 0 ) _columns[i].x = _title.x ; 
				else _columns[i].x = _columns[ i - 1 ].x + _columns[ i - 1 ].width + _spacer ;
				if ( _columns[i].getTitleHeight( ) > item_y ) item_y = _columns[i].getTitleHeight( ) ;
			}
			
			equalizeColumns( item_y + 10 ) ;
		}
		
		/*
		 * Give every column's first item the same y position. This is because every column may have a different
		 * title height.
		 */
		
		private function equalizeColumns( item_y:Number, item_h:Number = 35 ):void
		{
			for ( var i in _columns )
			{
				_columns[i].setFormPosition( item_y, item_h ) ;
			}
		}
		
	}
	
}