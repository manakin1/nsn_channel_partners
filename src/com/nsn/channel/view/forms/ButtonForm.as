package com.nsn.channel.view.forms
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField ;

	import com.nsn.channel.interfaces.IForm;
	import com.nsn.channel.view.forms.Form;
	import com.nsn.channel.control.MainController ;
	import com.nsn.channel.model.MainModel ;
	
	/*
	 * A button form that opens a new page once clicked. The value of this form is an array of the target page's
	 * items' values. This form is only needed for one purpose in the current version and should be extended or
	 * optimized for future ones.
	 */
	
	public class ButtonForm extends Form implements IForm
	{
		
		private var _buttonLabel:TextField ;
		
		public function ButtonForm( page_id:String, data:XML ) 
		{
			super( page_id, data ) ;
			setListeners( ) ;
			setControls( ) ;
		}
		
		// PUBLIC METHODS
		
		override public function getHeight( ):Number
		{
			return _field.y + _field.height ;
		}
		
		/*
		 * Returns the values of all items on the target page.
		 * 
		 * @return An array of the target page's items' values
		 */
		
		override public function getValue( ):*
		{
			var arr:Array = new Array( ) ;
			var page_data:XML = MainModel.getPage( "", _data.@target ) ;
			
			for ( var i:int = 0 ; i < page_data.item.length( ) ; i++ )
			{
				arr.push( MainModel.getInput( "_" + _data.@target + "_" + i ) ) ;
			}
			
			return arr ;
		}
		
		// PRIVATE METHODS
		
		override protected function renderSkin( ):void
		{
			_skin = new ButtonFormSkin( ) ;
			_label = _skin.label ;
			_buttonLabel = _skin.button_label ;
			_field = _skin.field as MovieClip ;
			_skin.field.gotoAndStop( 1 ) ;
			_skin.field.mouseChildren = false ;
			
			this.addEventListener( MouseEvent.ROLL_OVER, highlight ) ;
			this.addEventListener( MouseEvent.ROLL_OUT, highlight ) ;
			addChild( _skin ) ;
		}
		
		override protected function renderLabel( ):void
		{
			_label.condenseWhite = true ;
			_label.htmlText = String( _data.@label ) ;
			_label.width = _label.textWidth + 10 ;
			_label.height = _label.textHeight ;
			
			_buttonLabel.htmlText = "<b>" +_data.@button_label + "</b>" ;
		}
		
		private function setControls( ):void
		{   
			_buttonLabel.mouseEnabled = false ;
			_label.mouseEnabled = false ;
			_skin.field.addEventListener( MouseEvent.CLICK, clickHandler ) ;
		}
		
		override protected function setProportions( ):void
		{
			if ( int( _data.@width ) > 0 )
			{
				_field.width = int( _data.@width ) ;
				_label.width = _field.width + 10 ;
			}
			
			_field.y = _label.textHeight + 5 ;
			_buttonLabel.y = _field.y + 4 ;
		}
		
		// EVENT HANDLERS
		
		/*
		 * Navigate to the target page specified in the XML.
		 */
		
		private function clickHandler( e:MouseEvent ):void
		{
			MainController.navigateTo( "", String( _data.@target ) ) ;
		}
		
		private function highlight( e:MouseEvent ):void
		{
			var frame:int = ( e.type == MouseEvent.ROLL_OVER ) ? 2 : 1 ;
			_skin.field.gotoAndStop( frame ) ;
		}
	}
	
}