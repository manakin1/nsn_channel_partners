package com.nsn.channel.view.forms
{
	
	import fl.controls.Slider ;
	import fl.events.SliderEvent;
	import flash.events.Event ;
	import flash.events.MouseEvent;
	
	import com.nsn.channel.interfaces.IForm ;
	
	/*
	 * A simple slider form with a dynamic minimum/maximum value.
	 */
	
	public class SliderForm extends Form implements IForm
	{
		
		private var _slider:Slider ;
		private var _min:Number ;
		private var _max:Number ;
		
		public function SliderForm( col_id:String, data:XML ) 
		{
			super( col_id, data ) ;
			setLimits( ) ;
		}
		
		// PUBLIC METHODS
		
		override public function getValue( ):*
		{
			return _input.text ;
		}
		
		override public function getData( ):XML
		{
			return _data ;
		}
		
		override public function getHeight( ):Number
		{
			return this.height + 10 ;
		}
		
		// PRIVATE METHODS
		
		private function setLimits( ):void
		{
			if ( _data.@minimum ) _min = Number( _data.@minimum ) ;
			else _min = 0 ;
			
			if ( _data.@maximum ) _max = Number( _data.@maximum ) ;
			else _max = 100 ;
			
			_slider.minimum = _min ;
			_slider.maximum = _max ;
			
			_input.text = String( _min ) ;
			_input.y = _label.y + _label.height ;
			_slider.y = _input.y + _input.textHeight + 5 ;
		}
		
		override protected function renderSkin( ):void
		{
			_skin = new SliderFormSkin( ) ;
			_label = _skin.label ;
			_input = _skin.input ;
			_input.restrict = "0-9" ;
			addChild( _skin ) ;
			
			_slider = _skin.field as Slider ;
			_slider.addEventListener( SliderEvent.THUMB_DRAG, onSliderValueChange ) ;
			_input.addEventListener( Event.CHANGE, onInputValueChange ) ;
		}
		
		override protected function renderLabel( ):void
		{
			if ( String( _data.@label ).length > 0 )
			{
				_label.condenseWhite = true ;
				_label.width = 200 ;
				_label.htmlText = _data.@label ;
				_label.height = _label.textHeight ;
				_input.y = _label.y + _label.textHeight ;
			}
			
			else
			{
				_label.text = "" ;
				_label.height = 0 ;
				_label.mouseEnabled = false ;
			}
		}
		
		override protected function setProportions( ):void 
		{
			if ( int( _data.@width ) > 0 )
			{
				_slider.width = int( _data.@width ) ;
				_input.x = _slider.x + _slider.width * .5 - _input.width * .5 ;
				_label.width = Math.max( _slider.width, _label.textWidth + 5 ) ;
			}
		}
		
		// EVENT HANDLERS
		
		private function onSliderValueChange( e:SliderEvent ):void
		{
			_input.text = String( e.value ) ;
		}
		
		/*
		 * Match the slider position with the input value.
		 */
		
		private function onInputValueChange( e:Event ):void
		{
			var val:Number = Number( _input.text ) ;
			if ( val > _max ) val = _max ;
			else if ( val < _min ) val = _min ;
			
			_slider.value = val ;
			_input.text = String( val ) ;
		}
		
	}
	
}