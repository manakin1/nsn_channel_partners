package com.nsn.channel.view 
{
	
	import flash.display.Sprite ;
	import flash.display.MovieClip ;
	import flash.events.Event ;
	import flash.events.MouseEvent ;
	import flash.text.TextField ;
	
	import com.nsn.channel.control.MainController ;
	import com.nsn.channel.model.MainModel ;
	import com.nsn.channel.control.State;
	import com.nsn.channel.events.StateEvent ;
	import com.nsn.channel.events.ApplicationEvent ;
	
	import com.gskinner.motion.GTween;
	
	public class PageTemplate extends MovieClip
	{
		
		private var _infoButton:Sprite ;
		private var _nextButton:NaviButton ;
		private var _prevButton:NaviButton ;
		private var _pageButton:NaviButton ;
		private var _header:TextField ;
		
		public function PageTemplate( )
		{
			MainController.getInstance( ).addEventListener( StateEvent.CHANGE, onStateChange ) ;
			setControls( ) ;
			updateHeader( MainController.currentState ) ;
		}
		
		// PUBLIC METHODS
		
		public function close( e:Event = null ):void
		{
			if ( !MainController.currentState.category )
			{
				MainController.navigateTo( MainController.previousState.category, MainController.previousState.id ) ;
			}
			
			else
			{
				PageViewHandler.getInstance( ).savePageData( ) ;
				dispatchEvent( new Event( "removePage", true ) ) ;
			}
			
			if ( _pageButton )
			{
				removeChild( _pageButton ) ;
				_pageButton = null ;
			}
		}
		
		public function disable( ):void
		{
			mouseChildren = false ;
			overlay.visible = true ;
			overlay.alpha = 0 ;
			
			var tween:GTween = new GTween( overlay, .3, { alpha: .1 } ) ;
		}
		
		public function enable( ):void
		{
			var tween:GTween = new GTween( overlay, .3, { alpha: 0 } ) ;
			tween.addEventListener( Event.COMPLETE, completeHandler ) ;
			
			function completeHandler( e:Event ):void
			{
				tween.removeEventListener( Event.COMPLETE, completeHandler ) ;
				overlay.visible = false ;
				mouseChildren = true ;
			}
		}
		
		// PRIVATE METHODS
		
		private function setControls( ):void
		{
			_nextButton = new NaviButton( "Next" ) ;
			_prevButton = new NaviButton( "Previous" ) ;
			
			close_btn.mouseChildren = false ;
			close_btn.buttonMode = close_btn.useHandCursor = true ;
			
			close_btn.addEventListener( MouseEvent.ROLL_OVER, highlightCloseButton ) ;
			close_btn.addEventListener( MouseEvent.ROLL_OUT, highlightCloseButton ) ;
			close_btn.addEventListener( MouseEvent.CLICK, close ) ;
			_nextButton.addEventListener( MouseEvent.CLICK, next ) ;
			_prevButton.addEventListener( MouseEvent.CLICK, previous ) ;
			
			overlay.visible = false ;
			
			addChild( _nextButton ) ;
			addChild( _prevButton ) ;
			updateButtons( ) ;
		}
		
		private function updateButtons( state:State = null ):void
		{
			if ( !state ) state = MainController.currentState ;
			
			if ( !state.category.length )
			{
				_prevButton.visible = _nextButton.visible = false ;
				var page:XML = MainModel.getPage( state.category, state.id ) ;
				
				if ( String( page.@action ).length > 0 )
				{
					_pageButton = new NaviButton( String( page.@action ) ) ;
					_pageButton.x = bg.x + bg.width - _pageButton.width - 8 ;
					_pageButton.y = _nextButton.y ;
					_pageButton.addEventListener( MouseEvent.CLICK, close ) ;
					addChild( _pageButton ) ;
				}
			}
			
			else
			{
				_nextButton.visible = _prevButton.visible = true ;
				
				if ( int( state.id ) > 0 ) fadeIn( _prevButton ) ;
				else fadeOut( _prevButton ) ;
				
				if ( int( state.id ) < ( MainModel.getNumPages( state.category ) - 1 ) ) showNextButton( ) ;
				else showSubmitButton( ) ;
			}
		}
		
		private function fadeIn( obj:Object ):void
		{
			if( obj.alpha == 1 ) return ;
			var tween:GTween = new GTween( obj, .3, { alpha: 1 } ) ;
		}
		
		private function fadeOut( obj:Object ):void
		{
			if( obj.alpha == 0 ) return ;
			var tween:GTween = new GTween( obj, .3, { alpha: 0 } ) ;
		}
		
		private function showSubmitButton( ):void
		{
			if ( _nextButton.alpha < 1 ) fadeIn( _nextButton ) ;
			_nextButton.changeText( String( MainModel.getCategory( MainController.currentState.category ).@action ) ) ;
			arrangeButtons( ) ;
		}
		
		private function showNextButton( ):void
		{
			if ( _nextButton.alpha < 1 ) fadeIn( _nextButton ) ;
			_nextButton.changeText( "Next" ) ;
			arrangeButtons( ) ;
		}
		
		private function arrangeButtons( ):void
		{
			_nextButton.y = _prevButton.y = 489 ;
			_nextButton.x = bg.width - _nextButton.width - 8 ;
			_prevButton.x = _nextButton.x - _prevButton.width - 5 ;
		}
		
		private function updateHeader( state:State ):void
		{
			if ( !_header )
			{
				_header = MainView.getTextField( ) ;
				_header.x = 15 ;
				_header.y = 25 ;
				addChild( _header ) ;
			}
			
			if ( state.category.length > 0 ) 
			{
				_header.htmlText = MainModel.getCategory( state.category ).header.text.text( ) ;
				setTooltip( ) ;
			}
			
			else 
			{
				_header.htmlText = "" ;
				if ( _infoButton ) removeChild( _infoButton ) ;
				_infoButton = null ;
			}
		}
		
		private function setTooltip( ):void
		{
			if ( _infoButton ) return ;
			
			if ( MainModel.getText( "header_link" ) )
			{
				_infoButton = new Sprite( ) ;
				_infoButton.graphics.beginFill( 0, 0 ) ;
				_infoButton.graphics.drawRect( 0, 0, 100, 25 ) ;
				_infoButton.graphics.endFill( ) ;
				
				var tf:TextField = MainView.getTextField( ) ;
				tf.htmlText = MainModel.getText( "header_link" ) ;
				
				_infoButton.x = _header.x + _header.textWidth + 5 ;
				_infoButton.y = _header.y ;
				_infoButton.mouseChildren = false ;
				_infoButton.buttonMode = _infoButton.useHandCursor = true ;
				_infoButton.addEventListener( MouseEvent.CLICK, showInfo ) ;
				
				_infoButton.addChild( tf ) ;
				addChild( _infoButton ) ;
			}
		}
		
		// EVENT HANDLERS
		
		private function next( e:Event = null ):void
		{
			if ( MainController.currentState.category == "1" )
			{
				MainController.submitData( ) ;
			}
			
			else if ( int( MainController.currentState.id ) >= 
				 MainModel.getNumPages( MainController.currentState.category ) - 1 )
			{
				MainController.submitData( ) ;
			}
			
			else
			{
				var id:String = String( int( MainController.currentState.id ) + 1 ) ;
				MainController.navigateTo( MainController.currentState.category, id ) ;
			}
		}
		
		private function previous( e:Event = null ):void
		{
			if ( int( MainController.currentState.id ) == 0 ) return ;
			
			var id:String = String( int( MainController.currentState.id ) - 1 ) ;
			MainController.navigateTo( MainController.currentState.category, id ) ;
		}
		
		private function highlightCloseButton( e:MouseEvent ):void
		{
			var a:Number = ( e.type == MouseEvent.ROLL_OVER ) ? 1 : 0 ;
			var tween:GTween = new GTween( close_btn.bubble, .2, { alpha: a } ) ;
		}
		
		private function onStateChange( e:StateEvent ):void
		{
			updateButtons( e.state ) ;
			updateHeader( e.state ) ;
		}
		
		public function showInfo( e:Event ):void
		{
			MainController.navigateTo( "", "six_steps" ) ;
		}
		
	}
	
}
