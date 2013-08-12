package com.nsn.channel.view 
{
	
	import flash.display.MovieClip ;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/*
	 * An error/confirmation popup with an icon and a confirm button.
	 */
	
	public class AlertPopup extends MovieClip
	{
		
		private var _title:String ;
		private var _text:String ;
		private var _icon:String ;
		private var _button:NaviButton ;
		
		public function AlertPopup( title:String, txt:String, icon:String ) 
		{
			_title = title ;
			_text = txt ;
			_icon = icon ;
			
			build( ) ;
		}
		
		// PRIVATE METHODS
		
		private function build( ):void
		{
			title_tf.htmlText = _title ;
			tf.htmlText = _text ;
			icon.gotoAndStop( _icon ) ;
			
			_button = new NaviButton( "Done" ) ;
			_button.x = 337 ;
			_button.y = 153 ;
			_button.addEventListener( MouseEvent.CLICK, close ) ;
			
			addChild( _button ) ;
		}
		
		// EVENT HANDLERS
		
		private function close( e:MouseEvent = null ):void
		{
			dispatchEvent( new Event( "closeAlertPopup", true ) ) ;
		}
		
	}
	
}