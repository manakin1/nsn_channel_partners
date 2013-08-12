package com.nsn.channel.view.forms
{
	
	import flash.display.Bitmap ;
	
	import com.nsn.channel.model.MainModel ;
	import com.nsn.channel.interfaces.IForm ;
	
	public class Image extends Form implements IForm
	{
		
		private var _image:Bitmap ;
		
		public function Image( col_id:String, data:XML ) 
		{
			super( col_id, data ) ;
		}
		
		// PUBLIC METHODS
		
		override public function getValue( ):* 
		{ 
			return _image ;
		}
		
		override public function setValue( val:* ):void { }
		
		// PRIVATE METHODS
		
		override protected function render( ):void
		{
			_image = MainModel.getImage( _data.@src ) ;
			addChild( _image ) ;
		}
		
		override protected function setProportions( ):void { }

		
	}
	
}