package
{
	
	import com.gskinner.motion.GTween;
	import flash.display.Sprite ;
	import flash.display.MovieClip ;
	import flash.display.StageAlign ;
	import flash.display.StageScaleMode ;
	import flash.text.TextField ;
	import flash.events.Event ;
	import flash.events.MouseEvent ;
	import flash.events.Event ;
	import flash.events.IOErrorEvent ;
	import flash.text.TextFormat;
	
	import com.nsn.channel.view.MainView ;
	import com.nsn.channel.view.Styles ;
	import com.nsn.channel.control.MainController ;
	import com.nsn.channel.model.MainModel ;
	import com.nsn.channel.model.Constants ;
	
	/**
	 * Nokia Siemens Network Channel Partner Program
	 * Activeark
	 * @author Eve Andersson /zakour 2009
	 */
	
	public class Index extends Sprite
	{
		private var _mainView:MainView ;
		
		public function Index( ) 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE ;
			stage.align = StageAlign.TOP_LEFT ;
			stage.addEventListener( Event.RESIZE, onResize ) ;
			
			addEventListener( "blurIn", blurIn ) ;
			addEventListener( "blurOut", blurOut ) ;
			
			MainModel.getInstance( ).addEventListener( Event.COMPLETE, onXMLLoadComplete ) ;
			MainModel.loadXML( Constants.XML_SOURCE ) ;
		}
		
		// PUBLIC METHODS
		
		// PRIVATE METHODS
		
		/*
		 * Creates the main view object and displays it with a fade in tween.
		 * Calls resize to position the items correctly on the stage.
		 */
		
		private function createView( ):void
		{
			_mainView = MainView.getInstance( ) ;
			addChild( _mainView ) ;
			onResize( null ) ;
			
			var tween:GTween = new GTween( view, .5, { alpha: 1 } ) ;
		}
		
		private function setControls( ):void
		{
			view.main_menu.build( ) ;
			view.bg_blur.mouseEnabled = false ;
			
			view.home_btn.buttonMode = view.home_btn.useHandCursor = true ;
			view.home_btn.addEventListener( MouseEvent.ROLL_OVER, highlightHomeButton ) ;
			view.home_btn.addEventListener( MouseEvent.ROLL_OUT, highlightHomeButton ) ;
			view.home_btn.addEventListener( MouseEvent.CLICK, clickHandler ) ;
		}
		
		// EVENT HANDLERS
		
		/*
		 * Load the CSS styles and site contents and create the main view once the load is complete.
		 */
		
		private function onXMLLoadComplete( e:Event ):void
		{
			MainModel.getInstance( ).removeEventListener( Event.COMPLETE, onXMLLoadComplete ) ;
			Styles.getInstance( ).addEventListener( Event.COMPLETE, onCSSLoadComplete ) ;
			Styles.getInstance( ).load( Constants.CSS_SOURCE ) ;
		}
		
		private function onCSSLoadComplete( e:Event ):void
		{
			Styles.getInstance( ).removeEventListener( Event.COMPLETE, onCSSLoadComplete ) ;
			MainModel.getInstance( ).addEventListener( Event.COMPLETE, onContentLoadComplete ) ;
			MainModel.loadContent( ) ;
		}
		
		private function onContentLoadComplete( e:Event ):void
		{
			MainModel.getInstance( ).removeEventListener( Event.COMPLETE, onContentLoadComplete ) ;
			createView( ) ;
			setControls( ) ;	
		}
		
		/*
		 * Handles UI object clicks. Instructs the MainMenu to return to the initial view when the home button
		 * is clicked.
		 */
		
		private function clickHandler( e:MouseEvent ):void
		{
			if ( e.currentTarget == view.home_btn ) view.main_menu.returnToIndex( ) ;
		}
		
		private function highlightHomeButton( e:MouseEvent ):void
		{
			var target:Number = ( e.type == MouseEvent.ROLL_OVER ) ? .1 : .01 ;
			var tween:GTween = new GTween( view.home_btn, .3, { alpha: target } ) ;
		}
		
		/*
		private function mouseOverHandler( e:MouseEvent ):void
		{
			view.highlight.y = e.currentTarget.y ;
			view.hand_cursor.y = e.currentTarget.y + 13 ;
			view.hand_cursor.mouseEnabled = false ;
			view.hand_cursor.alpha = 1 ;
			
			if ( e.currentTarget == view.btn1 )
			{
				view.tf1.setTextFormat( new TextFormat( null, null, 0xffffff ) ) ;
				view.tf2.setTextFormat( new TextFormat( null, null, 0x000000 ) ) ;
			}
			
			else
			{
				view.tf2.setTextFormat( new TextFormat( null, null, 0xffffff ) ) ;
				view.tf1.setTextFormat( new TextFormat( null, null, 0x000000 ) ) ;
			}
		}
		*/
		
		/*
		 * Repositions the view and background instances as the stage is resized.
		 */
		 
		private function onResize( e:Event ):void
		{
			view.x = stage.stageWidth * .5 - view.width * .5 ;
			if ( _mainView ) _mainView.resize( ) ;
			
			color_bg.x = color_bg.y = 0 ;
			color_bg.width = stage.stageWidth ;
			color_bg.height = stage.stageHeight ;
		}
		
		/*
		 * Handles the blurring of the view when the main page is opened/closed. The color_bg serves as the main
		 * background.
		 */
		
		private function blurIn( e:Event = null ):void
		{
			var param:Object = { p: 0 } ;
			var tween:GTween = new GTween( param, .5, { p: 1 } ) ;
			tween.addEventListener( Event.CHANGE, changeHandler ) ;
			tween.addEventListener( Event.COMPLETE, completeHandler ) ;
			
			function changeHandler( e:Event ):void
			{
				view.bg_blur.alpha = param.p ;
				color_bg.alpha = param.p ;
			}
			
			function completeHandler( e:Event ):void
			{
				tween.removeEventListener( Event.CHANGE, changeHandler ) ;
				tween.removeEventListener( Event.COMPLETE, completeHandler ) ;
				
				view.bg_blur.alpha = 1 ;
				color_bg.alpha = 1 ;	
			}
		}
		
		private function blurOut( e:Event = null ):void
		{
			var param:Object = { p: 1 } ;
			var tween:GTween = new GTween( param, .5, { p: 0 } ) ;
			tween.addEventListener( Event.CHANGE, changeHandler ) ;
			tween.addEventListener( Event.COMPLETE, completeHandler ) ;
			
			function changeHandler( e:Event ):void
			{
				view.bg_blur.alpha = param.p ;
				color_bg.alpha = param.p ;
			}
			
			function completeHandler( e:Event ):void
			{
				tween.removeEventListener( Event.CHANGE, changeHandler ) ;
				tween.removeEventListener( Event.COMPLETE, completeHandler ) ;
				
				view.bg_blur.alpha = 0 ;
				color_bg.alpha = 0 ;	
			}
		}
		
	}
}