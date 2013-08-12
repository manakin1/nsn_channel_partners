package com.nsn.channel.view 
{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite ;
	import flash.display.MovieClip ;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import com.nsn.channel.model.MainModel ;
	import com.nsn.channel.view.MainView ;
	import com.nsn.channel.control.MainController ;
	
	import com.gskinner.motion.GTween;
	import fl.motion.easing.Quadratic ;
	
	public class MainMenu extends MovieClip
	{
		
		private var _data:XML ;
		private var _items:Array ;
		private var _containers:Array ;
		private var _category:String ;
		private var _info:TextField ;
		
		public function MainMenu( ) { }

		// PUBLIC METHODS
		
		/*
		 * Create a menu item for each category listed in the XML.
		 */
		
		public function build(  ):void
		{
			_items = new Array( ) ;
			_containers = new Array( ) ;
			
			_containers[0] = new Sprite( ) ;
			_items[0] = new Array( ) ;
			
			for ( var i:int = 0 ; i < MainModel.getNumCategories( ) ; i++ )
			{
				_containers[i] = new Sprite( ) ;
				addChild( _containers[i] ) ;
			}
				
			for ( var j in MainModel.getCategories( ).category )
			{
				_items[0][j] = new MainMenuItem( ) ;
				_items[0][j].name = "cat" + j ;
				_items[0][j].alpha = 0 ;
				_items[0][j].mouseChildren = false ;
				_items[0][j].buttonMode = _items[0][j].useHandCursor = true ;
				_items[0][j].buttonMode = _items[0][j].useHandCursor = true ;
				_items[0][j].addEventListener( MouseEvent.ROLL_OVER, highlightItem ) ;
				_items[0][j].addEventListener( MouseEvent.ROLL_OUT, highlightItem ) ;
				_items[0][j].addEventListener( MouseEvent.CLICK, onItemClicked ) ;
				_items[0][j].tf.htmlText = "<b>" + MainModel.getCategory( String( j ) ).@name + "</b>" ;
					
				_containers[0].addChild( _items[0][j] ) ;
					
				if ( j == 0 ) _items[0][j].y = 2 ;
				else _items[0][j].y = _items[0][ j - 1 ].y + _items[0][ j - 1 ].height ;
			}
				
			fadeItemsIn( ) ;
		}
		
		/*
		 * Return to the initial category view.
		 */
		
		public function returnToIndex( e:MouseEvent = null ):void
		{
			if ( !_category ) return ;
			
			var new_x:Number = 0 ;
			_category = null ;
			
			var tween:GTween = new GTween( _containers[0], .2, { x: new_x }, { ease: Quadratic.easeOut } ) ;
			tween.addEventListener( Event.CHANGE, changeHandler ) ;
			tween.addEventListener( Event.COMPLETE, completeHandler ) ;
			
			function changeHandler( e:Event ):void
			{
				_containers[1].x = _containers[0].x + _containers[0].width ;
			}
			
			function completeHandler( e:Event ):void
			{
				tween.removeEventListener( Event.CHANGE, changeHandler ) ;
				tween.removeEventListener( Event.COMPLETE, completeHandler ) ;	
				_containers[1].x = _containers[0].x + _containers[0].width ;
				
				removeChild( _containers[1] ) ;
				_containers[1] = null ;
			}	
			
			for ( var i in _items[0] )
			{
				_items[0][i].addEventListener( MouseEvent.ROLL_OUT, highlightItem ) ;
			}
		}
		
		// PRIVATE METHODS
		
		private function fadeItemsIn( ):void
		{
			var param:Object = { p : 0 } ;
			var tween:GTween = new GTween( param, .3, { p: 1 } ) ;
			tween.addEventListener( Event.CHANGE, changeHandler ) ;
			tween.addEventListener( Event.COMPLETE, completeHandler ) ;
			
			function changeHandler( e:Event ):void
			{
				for ( var i in _items[0] )
				{
					_items[0][i].alpha = param.p ;
				}
			}
			
			function completeHandler( e:Event ):void
			{
				tween.removeEventListener( Event.CHANGE, changeHandler ) ;
				tween.removeEventListener( Event.COMPLETE, completeHandler ) ;
				
				for ( var i in _items[0] )
				{
					_items[0][i].alpha = 1 ;
				}
			}
		}
		
		/*
		 * Shows the list of items in the category. Note that for now the category 0 list is a static image in
		 * the Flash library.
		 */
		
		private function showCategory( id:String ):void
		{
			_category = id ;
			
			for ( var i in _items[0] )
			{
				_items[0][i].removeEventListener( MouseEvent.ROLL_OUT, highlightItem ) ;
			}
			
			_containers[1] = new Sprite( ) ;
			var cat:MainMenuCategory = new MainMenuCategory( ) ;
			
			cat.back_btn.gotoAndStop( 1 ) ;
			cat.play_btn.gotoAndStop( 1 ) ;
			cat.back_btn.mouseChildren = false ;
			
			cat.back_btn.buttonMode = cat.back_btn.useHandCursor = true ;
			cat.play_btn.buttonMode = cat.play_btn.useHandCursor = true ;
			
			cat.back_btn.addEventListener( MouseEvent.ROLL_OVER, highlightButton ) ;
			cat.play_btn.addEventListener( MouseEvent.ROLL_OVER, highlightButton ) ;
			cat.back_btn.addEventListener( MouseEvent.ROLL_OUT, highlightButton ) ;
			cat.play_btn.addEventListener( MouseEvent.ROLL_OUT, highlightButton ) ;
			cat.back_btn.addEventListener( MouseEvent.CLICK, returnToIndex ) ;
			cat.play_btn.addEventListener( MouseEvent.CLICK, showSlide ) ;
			
			addChild( _containers[1] ) ; 
			_containers[1].addChild( cat ) ;
			_containers[1].x = _containers[0].x + _containers[0].width ;
			
			var new_x:Number = _containers[0].x ;
			
			var tween:GTween = new GTween( _containers[1], .2, { x: new_x }, { ease: Quadratic.easeOut } ) ;
			tween.addEventListener( Event.CHANGE, changeHandler ) ;
			tween.addEventListener( Event.COMPLETE, completeHandler ) ;
			
			function changeHandler( e:Event ):void
			{
				_containers[0].x = _containers[1].x - _containers[1].width ;
			}
			
			function completeHandler( e:Event ):void
			{
				tween.removeEventListener( Event.CHANGE, changeHandler ) ;
				tween.removeEventListener( Event.COMPLETE, completeHandler ) ;	
				_containers[0].x = _containers[1].x - _containers[1].width ;
			}
		}
		
		private function showInfo( index:int ):void
		{
			hideInfo( ) ;
			
			_info = MainView.getTextField( true ) ;
			_containers[0].addChild( _info ) ;
			_info.x = 6 ;
			_info.y = 80 ;
			_info.width = 125 ;
			
			_info.htmlText = "<p class='small'>" + MainModel.getCategory( String( index ) ).@info  + "</p>" 
		}
		
		private function hideInfo( ):void
		{
			if ( _info )
			{
				if( _containers[0].contains( _info ) ) _containers[0].removeChild( _info ) ;
				_info = null ;
			}
		}

		// EVENT HANDLERS
		
		private function highlightItem( e:MouseEvent ):void
		{
			if ( e.type == MouseEvent.ROLL_OVER ) 
			{
				e.currentTarget.highlight.alpha = 1 ;
				e.currentTarget.tf.textColor = 0xffffff ;
				
				showInfo( _items[0].indexOf( e.currentTarget ) ) ;
			}
			
			else 
			{
				e.currentTarget.highlight.alpha = 0 ;		
				e.currentTarget.tf.textColor = 0x000000 ;		
				
				hideInfo( ) ;
			}
		}
		
		private function highlightButton( e:MouseEvent ):void
		{
			var frame:int = e.currentTarget.currentFrame == 1 ? 2 : 1 ;
			e.currentTarget.gotoAndStop( frame ) ;		
		}
		
		private function onItemClicked( e:MouseEvent ):void
		{
			var id:String = e.currentTarget.name.substr( 3, 1 ) ;
			
			if ( id == "0" ) showCategory( id ) ;
			else MainController.navigateTo( "1", "0" ) ;
		}
		
		private function showSlide( e:MouseEvent = null ):void
		{
			MainController.navigateTo( _category, "0" ) ;
		}
		
	}
	
}