package com.nsn.channel.view.forms
{
	
	import flash.text.TextFieldAutoSize ;
	
	import com.nsn.channel.interfaces.IForm ;
	
	/*
	 * A form that only accepts a numeric value, € or %.
	 */
	
	public class NumberForm extends Form implements IForm
	{
		
		public function NumberForm( col_id:String, data:XML ) 
		{
			super( col_id, data ) ;
		}
		
		// PUBLIC METHODS
		
		override public function getValue( ):*
		{
			return _input.text ;
		}
		
		// PRIVATE METHODS
		
		override protected function renderSkin( ):void
		{
			_skin = new NumberFormSkin( ) ;
			_label = _skin.label ;
			_field = _skin.field ;
			_input = _skin.input ;
			_input.restrict = "0-9\\%\\€" ;
			addChild( _skin ) ;
		}
		
		override protected function renderLabel( ):void
		{
			_label.condenseWhite = true ;
			_label.autoSize = TextFieldAutoSize.LEFT ;
			_label.htmlText = _data.@label ;
			_label.height = _label.textHeight + 5 ;
			
			if ( int( _data.@width ) > 0 ) _label.width = int( _data.@width ) ; 
			else _label.width = Math.max( _field.width, _label.textWidth + 5 ) ;
		}
		
	}
	
}