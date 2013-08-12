package com.nsn.channel.view.forms
{
	import flash.text.TextField ;
	import flash.text.TextFieldAutoSize ;
	
	import com.nsn.channel.interfaces.IForm ;
	import com.nsn.channel.view.MainView ;
	
	public class TextArea extends Form implements IForm
	{
		
		private var _labels:Array ;
		
		public function TextArea( col_id:String, data:XML ) 
		{
			super( col_id, data ) ;
		}
		
		// PUBLIC METHODS
		
		override public function getLabel( ):String
		{
			return _label.text ;
		}
		
		// PRIVATE METHODS
		
		override protected function renderSkin( ):void
		{
			_skin = new TextAreaSkin( ) ;
			_label = _skin.label ;
			_input = _skin.input ;
			addChild( _skin ) ;
		}
		
		override protected function renderLabel( ):void
		{
			_label.condenseWhite = true ;
			_label.htmlText = _data.@label ;
			_label.height = _label.textHeight + 5 ;
		}
		
	}
	
}