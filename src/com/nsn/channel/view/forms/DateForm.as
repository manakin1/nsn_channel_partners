package com.nsn.channel.view.forms 
{
	
	import flash.events.Event ;
	import flash.text.TextField ;
	
	import com.nsn.channel.interfaces.IForm;

	/*
	 * A simple data input form. The value will be returned as a dd/mm/yy string.
	 */
	
	public class DateForm extends Form implements IForm
	{
		
		public function DateForm( page_id:String, data:XML ) 
		{
			super( page_id, data ) ;
		}
		
		// PUBLIC METHODS
		
		override public function getValue( ):*
		{
			var str:String = "" ;
			
			for ( var i:int = 1 ; i <= 3 ; i++ )
			{
				var tf:TextField = _skin.field[ "tf" + i ] ;
				str += tf.text ;
				
				if ( i <= 2 ) str += "/" ;
			}
			
			return str ;
		}
		
		// PRIVATE METHODS
		
		override protected function renderSkin( ):void
		{
			_skin = new DateFormSkin( ) ;
			_label = _skin.label ;
			_field = _skin.field ;
			addChild( _skin ) ;
		}
		
		override protected function renderLabel( ):void
		{
			_label.condenseWhite = true ;
			_label.htmlText = String( _data.@label ) ;
			_label.width = _label.textWidth + 10 ;
			_label.height = _label.textHeight ;
		}
		
		override protected function setProportions( ):void
		{
			_field.x = _label.x + _label.textWidth + 10 ;
			_label.y = 6 ;
			
			if( _input )
			{
				_input = _skin.input ;
				_input.y = _field.y + 3 ;
				_input.width = _field.width ;
				_input.height = _field.height ;
			}
		}
	}
	
}