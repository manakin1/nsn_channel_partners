package com.nsn.channel.view.forms
{
	
	import fl.controls.TextInput ;
	import flash.display.DisplayObject;
	import flash.display.MovieClip ;
	import flash.display.Sprite ;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.FocusEvent ;
	import flash.text.TextField ;
	import flash.text.TextFieldAutoSize ;
	
	import com.nsn.channel.view.MainView ;
	import com.nsn.channel.events.ApplicationEvent;
	import com.nsn.channel.interfaces.IForm ;
	
	/*
	 * The abstract Form class
	 */
	
	public class Form extends Sprite implements IForm
	{
		
		protected var _id:String ; 								// the unique form id
		protected var _page:String ;							// the id of the parent page
		protected var _value:* ;								// the form's value
		protected var _defaultValue:String ;					// the optional default value
		
		protected var _skin:MovieClip ;							// the form's skin, found in the Flash library
		protected var _infoButton:MovieClip ;					// the button that launches the info popup
		
		protected var _field:DisplayObject ;					// the primary movieclip in the skin, normally a text background or a control such as a ComboBox or a Checkbox
		
		protected var _label:TextField ;						// the form's label field
		protected var _input:TextField ;						// the form's input field
		
		protected var _data:XML ;								// the form's XML data
		
		public function Form( page_id:String, data:XML )
		{
			_page = page_id ;
			_id = page_id + "_" + data.@id ;
			_data = data ;
			
			render( ) ;
			setDefaultValue( ) ;
			setTooltip( ) ;
			setListeners( ) ;
		}
		
		// GETTERS/SETTERS
		
		public function get id( ):String
		{
			return _id ;
		}
		
		// PUBLIC METHODS
		
		/*
		 * The validate function is currently not needed or implemented, but probably will be in a future version
		 */
		
		public function validate( ):void { }
		
		/*
		 * @return The height of the item's label text
		 */
		
		public function getLabelHeight( ):Number
		{
			if ( !_label ) return 0 ;
			else return _label.textHeight ;
		}
		
		/*
		 * @return The item's label text whether it's an attribute or a text node
		 */
		
		public function getLabel( ):String
		{
			if ( String( _data.@label ).length > 0 ) return _data.@label ;
			else return _data.label.text( ) ;
		}
		
		/*
		 * Updates the item's label
		 * 
		 * @param str The new label
		 */
		
		public function setLabel( str:String ):void
		{
			_label.htmlText = str ;
			_label.width = _label.x + _label.textWidth + 50 ;
		}
		
		public function getWidth( ):Number
		{
			if ( _field ) return _field.width ;
			else return this.width ;
		}
		
		public function getHeight( ):Number
		{
			return this.height ;
		}
		
		public function getData( ):XML
		{
			return _data ;
		}
		
		public function getValue( ):*
		{
			if ( !_value ) return "" ;
			if ( _value == _defaultValue ) return "" ;
			else return _value ;
		}
		
		/*
		 * Set the form's value back to the default value or blank
		 */
		
		public function reset( ):void
		{
			if ( _input && _defaultValue ) _input.htmlText = _defaultValue ;
			else clear( ) ;
		}
		
		/*
		 * Changes the form's value and updates the input field accordingly
		 * 
		 * @param val The new value
		 */
		
		public function setValue( val:* ):void
		{
			_value = val ;
			if( _input ) _input.text = String( val ) ;
		}
		
		/*
		 * Clears the form and resets the value
		 */
		
		public function clear( ):void
		{
			_value = "" ;
			if( _input ) _input.text = _value ;
		}
		
		// PRIVATE METHODS
		
		protected function render( ):void
		{
			renderSkin( ) ;
			renderLabel( ) ;
			setProportions( ) ;
		}
		
		protected function renderSkin( ):void {	}
		
		protected function renderLabel( ):void { }
		
		/*
		 * Measures the form's width and height and positions the label and input fields correctly
		 */
		
		protected function setProportions( ):void
		{
			if ( int( _data.@width ) > 0 )
			{
				_skin.field.width = int( _data.@width ) ;
			}
			
			if ( int( _data.@height ) > 0 )
			{
				_skin.field.height = int( _data.@height ) ;
				_label.height = _skin.field.height ;
			}
			
			_skin.field.y = _label.textHeight + 5 ;
			
			if( _input )
			{
				_input = _skin.input ;
				_input.y = _skin.field.y + 3 ;
				_input.width = _skin.field.width ;
				_input.height = _skin.field.height ;
				_input.addEventListener( Event.CHANGE, onInputChange ) ;
			}
		}
		
		/*
		 * Sets the form's default value if specified in the XML
		 */
		
		private function setDefaultValue( ):void
		{
			if ( String( _data.@default ).length > 0 ) 
			{
				_defaultValue = _data.@default ;
				setValue( _defaultValue ) ;
			}
			
			else setValue( "" ) ;
		}
		
		/*
		 * Creates the info button if an info text is specified in the XML. Clicking the button will trigger
		 * the object's showInfo function and display the info popup.
		 */
		
		protected function setTooltip( ):void
		{
			if ( String( _data.info.text( ) ).length > 0 )
			{
				_infoButton = MainView.getInfoButton( this ) ;
				_infoButton.x = _label.x + _label.textWidth + 10 ;
				_infoButton.y = _label.y ;
				addChild( _infoButton ) ;
			}
		}
		
		protected function setListeners( ):void { }
		
		// EVENT HANDLERS
		
		/*
		 * Dispatches an event with the info text for displaying the info popup.
		 */
		
		public function showInfo( e:Event = null ):void
		{
			dispatchEvent( new ApplicationEvent( ApplicationEvent.SHOW_INFO, _data.info.text( ), true ) ) ;
		}
		
		protected function onInputChange( e:Event ):void
		{
			setValue( e.currentTarget.text ) ;
		}
		
	}
	
}