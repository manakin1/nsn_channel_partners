package com.nsn.channel.view.forms 
{
	
	import fl.controls.CheckBox ;
	
	import com.nsn.channel.interfaces.IForm ;
	import com.nsn.channel.view.forms.Form ;
	
	/*
	 * A checkbox form with a value of either true or false.
	 */
	
	public class CheckBoxForm extends Form implements IForm
	{
		
		public function CheckBoxForm( page_id:String, data:XML ) 
		{
			super( page_id, data ) ;
		}
		
		// PUBLIC METHODS
		
		override public function getHeight( ):Number
		{
			return _field.height ;
		}
		
		/*
		 * @return A boolean value depending on whether the checkbox is selected
		 */
		
		override public function getValue( ):*
		{
			return _skin.field.selected ;
		}
		
		// PRIVATE METHODS
		
		override protected function renderSkin( ):void
		{
			_skin = new CheckBoxFormSkin( ) ;
			_label = _skin.label ;
			_field = _skin.field ;
			addChild( _skin ) ;
		}
		
		override protected function renderLabel( ):void
		{
			_label.condenseWhite = true ;
			_label.htmlText = String( _data.@label ) ;
		}
		
		override protected function setProportions( ):void
		{
			_label.width = _label.textWidth + 5 ;
		}
	}
	
}