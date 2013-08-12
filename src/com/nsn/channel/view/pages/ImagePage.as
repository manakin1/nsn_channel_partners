package com.nsn.channel.view.pages 
{

	import flash.display.Bitmap ;
	import flash.events.Event;
	
	import com.nsn.channel.model.MainModel ;
	
	/*
	 * A page template that displays a single image.
	 */
	 
	public class ImagePage extends Page
	{
		
		private var _image:Bitmap ;
		
		public function ImagePage( cat_id:String, data:XML ) 
		{
			super( cat_id, data ) ;
		}
		
		// PRIVATE METHODS
		
		override protected function render( ):void
		{
			renderText( ) ;
			renderTitle( ) ;
			renderImage( ) ;
		}
		
		private function renderImage( ):void
		{
			_image = MainModel.getImage( String( _data.@image ) ) ;
			addChild( _image ) ;
			_image.x = _title.x ;
			_image.y = _title.y + _title.textHeight + 20 ;		
		}
		
	}
	
}