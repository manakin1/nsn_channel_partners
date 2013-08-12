package com.nsn.channel.view.pages 
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip ;
	import flash.display.Sprite ;
	import flash.events.MouseEvent ;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField ;
	import flash.utils.Dictionary;
	
	import com.nsn.channel.control.MainController ;
	import com.nsn.channel.model.Constants ;
	import com.nsn.channel.model.MainModel ;
	import com.nsn.channel.view.MainView ;
	import com.nsn.channel.view.Column ;
	import com.nsn.channel.view.forms.TextArea;
	import com.nsn.channel.view.forms.Graph ;
	
	/*
	 * A page that displays the x/y graph.
	 */
	
	public class GraphPage extends Page
	{
		
		private var _info:TextField ;
		private var _graph:Graph ;
		
		public function GraphPage( cat_id:String, data:XML ) 
		{
			super( cat_id, data ) ;
		}
		
		// PUBLIC METHODS
		
		/*
		 * Saves the graph's bitmap data for the PDF visualization.
		 * 
		 * @TODO All text should be moved inside the Graph class instead of the template page, so that we can
		 * save the Graph itself as a bitmap instead of taking a screenshot of the page.
		 */
		
		override public function saveData( ):void
		{
			_graph.finalize( ) ;
			
			var data:BitmapData = new BitmapData( 1200, 600 ) ;
			data.draw( this, new Matrix( ) ) ;
			var bmp:Bitmap = new Bitmap( data ) ;
			
			var data2:BitmapData ;
			data2 = new BitmapData( 500, 500 ) ;
			
			var begin_x = 270 ;
			var begin_y = 0 ;
			
			data2.copyPixels( data, new Rectangle( begin_x, begin_y, 550, 500 ), new Point( 0, 0 ) ) ;
			
			_graph.setValue( new Bitmap( data2 ) ) ;
		}
		
		// PRIVATE METHODS
		
		override protected function render( ):void
		{
			renderTitle( ) ;
			renderHeader( ) ;
			renderItems( ) ;
			placeItems( ) ;
			renderText( ) ;
		}
		
		private function placeItems( ):void
		{
			_graph = _items[0] ;
			_graph.x = 320 ;
			_graph.y = _header.y ;
			addChild( _graph ) ;
		}
		
		override protected function renderItems( ):void
		{
			_items = new Array( ) ;
			
			var graph_data:XML = new XML( _data.item.( @type == "Graph" ) ) ;
			var item_id:String = _id + "_" + graph_data.@id ;
			
			if ( MainModel.getForm( item_id ) ) 
			{
				_items[0] = MainModel.getForm( item_id ) ;
			}
				
			else 
			{
				_items[0] = MainView.createForm( _id, graph_data ) ;
			}
		}
		
		override protected function renderText( ):void
		{
			_info = MainView.getTextField( true ) ;
			_info.width = 240 ;
			_info.htmlText = _data.header.info.text( ) ;
			_info.x = _title.x ;
			_info.y = _header.y + _header.textHeight + 10 ;
			
			var left_header:TextField = MainView.getTextField( ) ;
			left_header.htmlText = _data.title2.text( ) ;
			left_header.rotation = -90 ;
			left_header.x = _graph.x - 35 ;
			left_header.y = _graph.y + ( _graph.height * .5 ) + ( left_header.textWidth * .5 ) ;
			
			var bottom_header:TextField = MainView.getTextField( ) ;
			bottom_header.htmlText = _data.title3.text( ) ;
			bottom_header.x = _graph.x + _graph.width * .5 - bottom_header.textWidth * .5 ;
			bottom_header.y = 450 ;
			
			var high1:TextField = getTextField( "high" ) ;
			var high2:TextField = getTextField( "high" ) ;
			var low1:TextField = getTextField( "low" ) ;
			
			high1.x = _graph.x - high1.textWidth - 10 ;
			high1.y = _graph.y ;
			
			low1.x = _graph.x - low1.textWidth - 10 ;
			low1.y = _graph.y + _graph.height + 5 ;
			
			high2.x = _graph.x + _graph.width - high2.width ;
			high2.y = low1.y ;
			
			addChild( high1 ) ;
			addChild( high2 ) ;
			addChild( low1 ) ;
			
			addChild( _info ) ;
			addChild( left_header ) ;
			addChild( bottom_header ) ;
		}
		
		private function getTextField( value:String ):TextField
		{
			var tf:TextField = MainView.getTextField( ) ;
			tf.htmlText = "<p class='small'>" + value + "</p>" ;
			tf.width = tf.textWidth + 5 ;
			return tf ;
		}
		
		override protected function renderHeader( ):void
		{
			if ( String( _data.header.text.text( ) ).length > 0 )
			{
				_header = MainView.getTextField( true ) ;
				_header.width = 240 ;
				_header.htmlText = _data.header.text.text( ) ;
				_header.x = _title.x ;
				_header.y = _title.y + _title.height + 10 ;
				addChild( _header ) ;
				
				if ( String( _data.header.info.text( ) ).length > 0 )
				{
					_infoButton = new InfoButton( ) ;
					addChild( _infoButton ) ;
					_infoButton.x = _header.x + _header.textWidth + 10 ;
					_infoButton.y = _header.y ;
					_infoButton.addEventListener( MouseEvent.CLICK, showInfo ) ;
				}
			}
		}
		
		
	}
	
}