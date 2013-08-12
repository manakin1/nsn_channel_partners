package com.nsn.channel.view 
{
	
	import com.nsn.channel.events.ApplicationEvent;
	import flash.display.MovieClip ;
	import flash.display.Sprite ;
	import flash.events.Event ;
	import flash.utils.getDefinitionByName ;
	
	import com.nsn.channel.control.MainController ;
	import com.nsn.channel.control.State ;
	import com.nsn.channel.model.MainModel ;
	import com.nsn.channel.model.Constants ;
	import com.nsn.channel.view.pages.Page ;
	
	import com.gskinner.motion.GTween ;
	import fl.motion.easing.* ;

	public class PageViewHandler extends Sprite 
	{
		
		private var _page:Page ;
		private var _template:MovieClip ;
		private var _navi:PageNavigation ;
		private static var _instance:PageViewHandler ; 
		
		public function PageViewHandler( ) 
		{
			Templates ;
		}
		
		// GETTERS/SETTERS
		
		public static function getInstance( ):PageViewHandler 
		{
			if ( !_instance ) _instance = new PageViewHandler( ) ;
			return _instance ; 
		}

		// PUBLIC METHODS
		
		public function update( state:State ):void 
		{
			render( ) ;
			if( _page ) hidePage( ) ;
			else createPage( state ) ;
		}
		
		public function savePageData( ):void
		{
			if( _page ) _page.saveData( ) ;
		}
		
		public function resize( ):void
		{
			if ( _template ) _template.x = stage.stageWidth * .5 - _template.bg.width * .5 ;
		}
		
		public function close( ):void
		{
			_template.close( ) ;
		}
		
		public function enable( ):void
		{
			if ( !_template ) return ;
			_template.enable( ) ;
		}
		
		public function disable( ):void
		{
			if ( !_template ) return ;
			_template.disable( ) ;
		}
	
		// PRIVATE METHODS
		
		private function render( ):void
		{
			if ( !_template )
			{
				_template = new PageTemplate( ) ;
				_template.addEventListener( "removePage", removePage ) ;
				_template.x = stage.stageWidth * .5 - _template.width * .5 ;
				_template.y = 75 ;
				_template.alpha = 0 ;
				
				addChild( _template ) ;
				dispatchEvent( new Event( "blurIn", true ) ) ;
			}
			
			if ( MainController.currentState.category == "0" )
			{
				if ( !_navi )
				{
					_navi = new PageNavigation( MainModel.getPages( MainController.currentState.category ) ) ;
					_navi.x = 0 ;
					_navi.y = 50 ;
					_template.addChild( _navi ) ;
				}
				
				showNavi( ) ;
			}
			
			else if ( _navi && !MainController.currentState.category.length ) hideNavi( ) ;
			
			var tween:GTween = new GTween( _template, .3, { alpha: 1 } ) ;
		}
		
		private function showNavi( ):void
		{
			if ( _navi.alpha > 0 && _navi.visible ) return ;
			
			_navi.visible = true ;	
			_navi.alpha = 0 ;
			var tween:GTween = new GTween( _navi, .3, { alpha: 1 } ) ;
		}
		
		private function hideNavi( ):void
		{
			var tween:GTween = new GTween( _navi, .3, { alpha: 0 } ) ;
			tween.addEventListener( Event.COMPLETE, completeHandler ) ;
			
			function completeHandler( e:Event ):void
			{
				tween.removeEventListener( Event.COMPLETE, completeHandler ) ;
				_navi.visible = false ;
			}
		}
		
		private function createPage( state:State ):void 
		{
			trace( "PageViewHandler.createPage: Creating", state ) ;

			var pageData:XML = MainModel.getPage( state.category, state.id ) ;
			
			var pageClassName:String = "com.nsn.channel.view.pages." + pageData.@template.toString( ) ;
			var pageClass:Class = getDefinitionByName( pageClassName ) as Class ;
			_page = new pageClass( state.category, pageData ) as Page ;
				
			_template.addChild( _page ) ;
			
			_page.addEventListener( "transitionInComplete", onTransitionInComplete ) ;
			_page.dispatchEvent( new Event( "beginTransitionIn" ) ) ;
		}
		
		private function removeTemplate( ):void
		{
			if ( !_template ) return ;
			
			dispatchEvent( new Event( "blurOut", true ) ) ;
			var tween:GTween = new GTween( _template, .3, { alpha: 0 } ) ;
			tween.addEventListener( Event.COMPLETE, completeHandler ) ;
			
			function completeHandler( e:Event ):void
			{
				tween.removeEventListener( Event.COMPLETE, completeHandler ) ;
				removeChild( _template ) ;
				_template = null ;
			}
		}
		
		// EVENT HANDLERS
		
		private function hidePage( ):void 
		{
			_page.saveData( ) ;
			_page.addEventListener( "transitionOutComplete", onTransitionOutComplete ) ;
			_page.dispatchEvent( new Event( "beginTransitionOut", true ) ) ;
		}
		
		private function removePage( e:Event = null ):void
		{
			trace( "PageViewHandler.removePage" ) ;
			_page.addEventListener( "transitionOutComplete", onPageRemove ) ;
			_page.dispatchEvent( new Event( "beginTransitionOut", true ) ) ;	
		}
		
		private function onTransitionInComplete( e:Event = null ):void
		{
			//trace( "PageViewHandler.onTransitionInComplete" ) ;
		}
		
		private function onTransitionOutComplete( e:Event = null ):void
		{
			//trace( "PageViewHandler.onTransitionOutComplete" ) ;
			_page.removeEventListener( "transitionOutComplete", onTransitionOutComplete ) ;
			
			if ( !_page ) return ;
			if ( _template.contains( _page ) ) _template.removeChild( _page ) ;
			
			createPage( MainController.currentState ) ;
		}
		
		private function onPageRemove( e:Event ):void
		{
			_page.removeEventListener( "transitionOutComplete", onPageRemove ) ;
			MainController.resetState( ) ;
			
			if ( !_template ) return ;
			
			if ( _navi )
			{
				if ( _template.contains( _navi ) )
				{
					_template.removeChild( _navi ) ;
					_navi = null ;
				}
			}
			
			if ( _template.contains( _page ) ) 
			{
				_page.saveData( ) ;
				_template.removeChild( _page ) ;
				_page = null ;
			}
			
			removeTemplate( ) ;
		}
		
	}
}
