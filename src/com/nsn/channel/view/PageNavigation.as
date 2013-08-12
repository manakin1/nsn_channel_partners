package com.nsn.channel.view 
{
	
	import flash.display.Sprite ;
	import flash.display.MovieClip ;
	import flash.text.TextField ;
	import flash.text.TextFormat ;
	import flash.text.AntiAliasType ;
	import flash.events.MouseEvent ;
	
	import com.nsn.channel.control.MainController ;
	import com.nsn.channel.events.StateEvent ;
	
	public class PageNavigation extends MovieClip
	{
		
		private var _data:XML ;
		private var _items:Array ;
		private var _arrows:Array ;
		
		private var _active:int ;
		private var _numItems:int						= 6 ;
		
		private var _textColor:uint						= 0x000000 ;
		private var _highlightColor:uint				= 0xffffff ;
		
		public function PageNavigation( data:XML ) 
		{
			_data = data ;
			build( ) ;
			
			MainController.getInstance( ).addEventListener( StateEvent.CHANGE, onStateChange ) ;
		}
		
		// PUBLIC METHODS
		
		public function update( index:int ):void
		{
			activate( index ) ;
		}
		
		// PRIVATE METHODS
		
		private function build( ):void
		{
			_items = new Array( ) ;
			_arrows = new Array( ) ;
			
			for ( var i:int = 0 ; i < _numItems ; i++ )
			{
				_items[i] = this[ "tf" + ( i + 1 ) ] ;
				
				try 
				{
					_arrows[i] = this[ "arrow" + ( i + 1 ) ] ;
				}
				
				catch( e:Error ) { }
				
				_items[i].addEventListener( MouseEvent.ROLL_OVER, onItemOver ) ;
				_items[i].addEventListener( MouseEvent.ROLL_OUT, onItemOut ) ;
				_items[i].addEventListener( MouseEvent.CLICK, onItemClicked ) ;	
			}
			
			activate( 0 ) ;
		}
				
		private function activate( index:int ):void
		{
			_active = index ;
			highlight( index ) ;
			
			deactivate( ) ;
		}
		
		private function deactivate( index:int = -1 ):void
		{
			if ( index < 0 )
			{
				for ( var i in _items )
				{
					if ( i != _active ) reset( i ) ;
				}
			}
			
			else reset( index ) ;
		}
		
		private function highlight( index:int ):void
		{
			try
			{
				_items[ index ].htmlText = "<b>" + _items[ index ].text + "</b>" ;
				_items[ index ].textColor = _highlightColor ;
				if( _arrows[ index ] ) _arrows[ index ].alpha = 1 ;
			}
			
			catch( e:Error ) { }
		}
		
		private function reset( index:int ):void
		{
			_items[ index ].htmlText = _items[ index ].text ;
			_items[ index ].textColor = _textColor ;
			if( _arrows[ index ] ) _arrows[ index ].alpha = .4 ;
		}
		
		// EVENT HANDLERS
		
		private function onItemOver( e:MouseEvent ):void
		{
			var index:int = _items.indexOf( e.currentTarget ) ;
			highlight( index ) ;
		}
		
		private function onItemOut( e:MouseEvent ):void
		{
			var index:int = _items.indexOf( e.currentTarget ) ;
			if( _active != index ) reset( index ) ;
		}
		
		private function onItemClicked( e:MouseEvent ):void
		{
			var index:int = _items.indexOf( e.currentTarget ) ;
			MainController.navigateTo( MainController.currentState.category, String( index ) ) ;
		}
		
		private function onStateChange( e:StateEvent ):void
		{
			update( int( MainController.currentState.id ) ) ;
		}
		
	}
	
}