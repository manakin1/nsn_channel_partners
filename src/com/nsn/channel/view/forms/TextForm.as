package com.nsn.channel.view.forms
{
	
	import flash.text.TextFieldAutoSize ;
	
	import com.nsn.channel.interfaces.IForm ;
	
	public class TextForm extends Form implements IForm
	{
		
		/*
		 * A single line text form.
		 */
		
		public function TextForm( page_id:String, data:XML ) 
		{
			super( page_id, data ) ;
		}
		
		// PRIVATE METHODS
		
		override protected function renderSkin( ):void
		{
			_skin = new TextFormSkin( ) ;
			_label = _skin.label ;
			_field = _skin.field ;
			_input = _skin.input ;
			addChild( _skin ) ;
		}
		
		override protected function renderLabel( ):void
		{
			_label.condenseWhite = true ;
			_label.autoSize = TextFieldAutoSize.LEFT ;
			_label.htmlText = String( _data.@label ) ;
			_label.height = _label.textHeight ;
			
			if ( int( _data.@width ) > 0 ) _label.width = int( _data.@width ) ; 
			else _label.width = _label.textWidth + 5 ;
		}
		
	}
	
}