package com.nsn.channel.view 
{
	
	import flash.display.MovieClip ;
	import flash.text.TextField ;
	import flash.events.MouseEvent ;

	public class NaviButton extends MovieClip
	{
		
		private var _defaultText:String ;
		private var _defaultSize:Number = 67 ;
		
		public function NaviButton( str:String ) 
		{
			_defaultText = str ;
			build( ) ;
		}
		
		// PUBLIC METHODS
		
		public function changeText( str:String ):void
		{
			tf.condenseWhite = true ;
			tf.htmlText = str ;
			updateSize( ) ;
		}
		
		public function resetText( ):void
		{
			tf.htmlText = _defaultText ;
			updateSize( ) ;
		}
		
		// PRIVATE METHODS
		
		private function build( ):void
		{
			tf.htmlText = _defaultText ;
			bg.gotoAndStop( 1 ) ;
			this.buttonMode = this.useHandCursor = true ;
			this.mouseChildren = false ;
			addEventListener( MouseEvent.ROLL_OVER, highlight ) ;
			addEventListener( MouseEvent.ROLL_OUT, highlight ) ;
		}
		
		private function updateSize( ):void
		{
			if ( tf.text == _defaultText ) 
			{
				bg.width = _defaultSize ;
				tf.width = bg.width ;
				tf.x = 0 ;
			}
			
			else
			{
				bg.width = tf.textWidth + 18 ;
				tf.width = tf.textWidth + 5 ;
				tf.x = 4 ;
			}
		}
		
		// EVENT HANDLERS
		
		private function highlight( e:MouseEvent ):void
		{
			var frame:int = e.type == MouseEvent.ROLL_OVER ? 2 : 1 ;
			bg.gotoAndStop( frame ) ;
		}
		
	}
	
}