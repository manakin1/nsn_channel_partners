package com.nsn.channel.view.forms 
{
	
	import flash.display.DisplayObject ;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName ;
		
	import com.nsn.channel.interfaces.IForm ;
	import com.nsn.channel.model.MainModel ;
	import com.nsn.channel.view.MainView ;
	import com.nsn.channel.view.Indicator ;
	
	import com.gskinner.motion.GTween ;
	
	/*
	 * A container form with several "pages". Each page will be saved in a stack array, which is also the returned
	 * value of this form. The child forms are specified in the XML, and an Indicator object handles navigating 
	 * between the pages. 
	 */
	
	public class DataCollectionComponent extends Form implements IForm
	{
		
		private var _componentData:XML ;
		
		private var _addButton:MovieClip ;
		private var _saveButton:MovieClip ;
		
		private var _title:TextField ;
		private var _indicator:Indicator ;
		
		private var _maxLength:int ;
		private var _stackIndex:int							= 0 ;
		
		private var _items:Array ;
		private var _stack:Array ;
		
		public function DataCollectionComponent( page_id:String, data:XML ) 
		{
			super( page_id, data ) ;
			_maxLength = int( _data.@max_length ) ;
			addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage ) ;
		}
		
		// PUBLIC METHODS
		
		override public function getValue( ):*
		{
			return _stack ;
		}
		
		/*
		 * This form's value can't be set manually.
		 */
		
		override public function setValue( val:* ):void { }
		
		// PRIVATE METHODS
		
		override protected function render( ):void
		{
			renderTitle( ) ;
			renderItems( ) ;
			setControls( ) ;
			setIndicator( ) ;
		}
		
		private function renderTitle( ):void
		{
			_title = MainView.getTextField( true ) ;
			_title.width = 300 ;
			_title.htmlText = _data.title.text( ) ;
			addChild( _title ) ;
		}
		
		private function renderItems( ):void
		{
			_items = new Array( ) ;
			
			for ( var i in _data.components.item )
			{
				_items[i] = MainView.createForm( _id, new XML(  _data.components.item[i] ) ) ;
				addChild( _items[i] ) ;
				
				if ( i == 0 )
				{
					_items[i].y = _title.y + _title.textHeight + 8 ;
				}
				
				else
				{
					var prev:Form = _items[ i - 1 ] ;
					_items[i].y = prev.y + prev.getHeight( ) + 10 ;
				}
			}
		}
		
		/*
		 * Creates the Indicator object for navigating between the pages. The indicator is positioned right
		 * next to the title.
		 */
		
		private function setIndicator( ):void
		{
			_indicator = new Indicator( ) ;
			
			_indicator.x = _title.x + _title.textWidth + 10 ;
			_indicator.y = 2 ;
			
			addChild( _indicator ) ;
			_indicator.addEventListener( "onIndicatorChange", onIndicatorChange ) ;
		}
		
		private function setControls( ):void
		{
			_addButton = new AddButton( ) ;
			_addButton.tf.htmlText = _data.components.add_text.text( ) ;
			_addButton.buttonMode = _addButton.useHandCursor = true ;
			_addButton.y = _items[ _items.length - 1 ].y + _items[ _items.length - 1 ].height + 10 ;
			_addButton.addEventListener( MouseEvent.CLICK, addNew ) ;

			addChild( _addButton ) ;
		}
		
		/*
		 * Saves the current page in the stack.
		 */
		
		private function saveStack( e:Event = null ):void
		{
			if ( !_stack ) _stack = new Array( ) ;	
			if ( !_stack[ _stackIndex ] ) _stack[ _stackIndex ] = new Array( ) ;
			
			for ( var i in _items )
			{
				_stack[ _stackIndex ][i] = _items[i].getValue( ) ;
			}
		}
		
		/*
		 * Populates the current page with values from a certain page in the stack.
		 * 
		 * @param index The index of the currently displayed page
		 */
		
		private function populate( index:int ):void
		{
			for ( var i in _items )
			{
				_items[i].setValue( _stack[ index ][i] ) ;
			}
		}
		
		/*
		 * Disables the add button once the page limit has been reached
		 */
		
		private function disable( ):void
		{
			_addButton.removeEventListener( MouseEvent.CLICK, addNew ) ;
			var tween:GTween = new GTween( _addButton, .35, { alpha: .3 } ) ;
		}
		
		// EVENT HANDLERS
		
		/*
		 * Adds a new page to the stack and saves the previous page's values. A new page index is added to the
		 * indicator. Disables the add button in case the maximum page limit has been reached.
		 */
		
		private function addNew( e:MouseEvent ):void
		{
			saveStack( ) ;
			_stackIndex++ ;
			
			if ( _stack.length == _maxLength - 1 ) disable( ) ;
			
			if( _stack.length <= _maxLength )
			{
				for ( var i in _items )
				{
					_items[i].reset( ) ;
				}	
			}
			
			_indicator.addItem( ) ;
		}
		
		private function onRemovedFromStage( e:Event ):void
		{
			saveStack( ) ;
		}
		
		/*
		 * Saves the current stack, updates the index and populates the component with the new values. This is
		 * called when a number on the indicator is clicked.
		 */
		
		private function onIndicatorChange( e:Event ):void
		{
			saveStack( ) ;
			_stackIndex = _indicator.currentItem ;
			populate( _stackIndex ) ;
		}
		
		
	}
	
}