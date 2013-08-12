package com.nsn.channel.view.forms
{
	
	import flash.display.Sprite ;
	import flash.text.TextField ;
	import flash.text.TextFieldAutoSize ;
	
	import com.nsn.channel.view.MainView ;
	import com.nsn.channel.interfaces.IForm;
	
	/*
	 * A simple block of text, no user input possibility.
	 * @TODO The width/height should be made dynamic.
	 */
	
	public class TextBlock extends Form implements IForm
	{
		
		private var _tf:TextField ;
		
		public function TextBlock( page_id:String, data:XML ) 
		{
			super( page_id, data ) ;
		}
		
		// PUBLIC METHODS
		
		// PRIVATE METHODS
		
		override protected function render( ):void
		{
			_tf = MainView.getTextField( true ) ;
			_tf.width = 300 ;
			_tf.htmlText = _data.text.text( ) ;
			addChild( _tf ) ;
		}
		
		override protected function setProportions( ):void { }
		
	}
	
}