package com.nsn.channel.view 
{
	
	import fl.controls.TextInput;
	import flash.display.Sprite ;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.FocusEvent ;
	import flash.text.TextField;
	
	/*
	 * A removable graph point with a text input field.
	 */
	
	public class GraphPoint extends Sprite
	{
		
		private var _icon:Sprite ;
		private var _input:TextInput ;
		private var _label:TextField ;
		private var _state:int						= 0 ;
		
		private const DEFAULT_TEXT:String			= "Action" ;
		
		public function GraphPoint( ) 
		{
			render( ) ;
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage ) ;
		}
		
		// PUBLIC METHODS
		
		/*
		 * Change the input field into a fixed text field.
		 */
		
		public function finalize( ):void
		{
			if ( !_input ) return ;
			
			_label = MainView.getTextField( true ) ;
			_label.width = 120 ;
			_label.htmlText = "<p class='small'>" + _input.text + "</p>" ;
			_label.x = _input.x ;
			_label.y = _input.y + 1 ;
			addChild( _label ) ;
			
			removeChild( _input ) ;
			_input = null ;
			
			_icon.addEventListener( MouseEvent.ROLL_OVER, toggleState ) ;
			_icon.addEventListener( MouseEvent.ROLL_OUT, toggleState ) ;
		}
		
		// PRIVATE METHODS
		
		private function render( ):void
		{
			drawIcon( ) ;
			
			_input = new TextInput( ) ;
			_input.setStyle( "fontSize", 9 ) ;
			_input.setStyle( "fontFamily", "Arial" ) ;
			_input.htmlText = "<p class='small'>" + DEFAULT_TEXT + "</p>" ;
			_input.width = 110 ;
			_input.height = 20 ;
			addChild( _input ) ;
			_input.x = _input.y = 5 ;
		}
		
		/*
		 * Draw either the circle icon or a cross on mouseover.
		 */
		
		private function drawIcon( ):void
		{
			if ( !_icon )
			{
				_icon = new Sprite( ) ;
				_icon.buttonMode = _icon.useHandCursor = true ;
				_icon.addEventListener( MouseEvent.CLICK, remove ) ;
				addChild( _icon ) ;
			}
			
			else _icon.graphics.clear( ) ;
			
			if ( _state == 0 )
			{
				_icon.graphics.beginFill( 0xff9900 ) ;
				_icon.graphics.drawCircle( 0, 0, 5 ) ;
				_icon.graphics.endFill( ) ;
			}
			
			else if ( _state == 1 )
			{
				_icon.graphics.beginFill( 0xffff99, 1 ) ;
				_icon.graphics.drawRect( -3, -3, 7, 7 ) ;
				_icon.graphics.lineStyle( 2, 0xff9900 ) ;
				_icon.graphics.moveTo( -3, -3 ) ;
				_icon.graphics.lineTo( 7, 7 ) ;
				_icon.graphics.moveTo( 7, -3 ) ;
				_icon.graphics.lineTo( -3, 7 ) ;
			}
		}
		
		// EVENT HANDLERS
		
		private function onAddedToStage( e:Event ):void
		{
			if ( _input ) stage.focus = _input ;
		}
		
		private function remove( e:MouseEvent ):void
		{
			e.stopImmediatePropagation( ) ;
			dispatchEvent( new Event( "remove" ) ) ;
		}
		
		/*
		 * Change the state to 0 (normal) or 1 (mouseover) and update the icon accordingly.
		 */
		
		private function toggleState( e:MouseEvent ):void
		{
			_state = Math.abs( _state - 1 ) ;
			drawIcon( ) ;
		}
		
	}
	
}