package com.nsn.channel.view 
{
	
	import flash.display.MovieClip ;
	import flash.display.Sprite ;
	import flash.geom.Rectangle;
	import flash.text.TextField ;
	import flash.text.AntiAliasType ;
	import flash.text.TextFieldAutoSize ;
	import flash.text.GridFitType ;
	import flash.events.Event ;
	import flash.events.MouseEvent ;
	import flash.utils.getDefinitionByName ;
	
	import com.nsn.channel.control.MainController ;
	import com.nsn.channel.control.PDFController ;
	import com.nsn.channel.model.Constants ; 
	import com.nsn.channel.model.MainModel ;
	import com.nsn.channel.events.StateEvent ;
	import com.nsn.channel.events.ApplicationEvent ;
	import com.nsn.channel.view.forms.Form ;
	import com.nsn.channel.interfaces.IForm ;
	
	import fl.motion.easing.* ;
	import com.gskinner.motion.GTween ;
	
	/*
	 * The main application view class.
	 */
	
	public class MainView extends Sprite 
	{
		
		private var _infoBox:MovieClip ;
		private var _alert:MovieClip ;
		private static var _instance:MainView ;
		private static var _viewHandler:PageViewHandler ;
		
		public function MainView( ) 
		{
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage ) ;
			addEventListener( ApplicationEvent.SHOW_INFO, onInfo ) ;
		}
		
		// PUBLIC METHODS
		
		public static function getInstance( ):MainView 
		{
			if( !_instance ) _instance = new MainView( ) ;
			return _instance ;
		}
		
		/*
		 * Returns a blank text field.
		 */
		
		public static function getTextField( multiline:Boolean = false ):TextField 
		{
			var textField:TextField = new TextField( ) ;
			textField.antiAliasType = AntiAliasType.ADVANCED ;
			textField.autoSize = TextFieldAutoSize.LEFT ;
			textField.gridFitType = GridFitType.PIXEL ;
			textField.embedFonts = true ;
			textField.multiline = multiline ;
			textField.selectable = false ;
			textField.condenseWhite = true ;
			textField.styleSheet = Styles.getStyleSheet( ) ;
			textField.wordWrap = multiline ;
			return textField ;
		}
		
		/*
		 * Returns the tooltip button with a callback to the target object's own showInfo function.
		 * 
		 * @param target The caller object
		 * @return The button instance
		 */
		
		public static function getInfoButton( target:Object ):MovieClip
		{
			var btn:MovieClip = new InfoButton( ) ;
			btn.buttonMode = btn.useHandCursor = true ;
			btn.addEventListener( MouseEvent.CLICK, target.showInfo ) ;
			return btn ;
		}
		
		/*
		 * Creates a new form from the specified data.
		 * 
		 * @param id The unique id of the form
		 * @param data The XML data of the form
		 * 
		 * @return The newly created form instance
		 */
		
		public static function createForm( id:String, data:XML ):IForm
		{
			var form:IForm ;
			
			var formClassName:String = "com.nsn.channel.view.forms." + data.@type.toString( ) ;
			var formClass:Class = getDefinitionByName( formClassName ) as Class ;
			form = new formClass( id, data ) as Form ;
			
			return form ;
		}
		
		/*
		 * This function is called when the submit button on the last page of any category is clicked.
		 * If the email field is left blank, a popup with an error message will be displayed.
		 */
		
		public function handleSubmit( ):void
		{
			// main category
			
			if ( MainController.currentState.category == "0" ) 
			{
				if ( MainModel.getInput( "0_0_1" ) ) submitData( ) ;
				else showAlert( "no_email" ) ;
			}
			
			// testimonial category
			
			else if ( MainController.currentState.category == "1" ) 
			{
				if ( MainModel.getInput( "1_0_11" ) ) Testimonial.create( ) ;
				else showAlert( "no_email" ) ;
			}
		}
		
		/*
		 * Displays a confirmation/error popup.
		 * 
		 * @TODO The alert texts should be made dynamic.
		 */
		
		public function showAlert( type:String ):void
		{
			if ( _alert ) return ;
			
			trace( "MainView.showAlert:", type ) ;
			
			hideAlert( ) ;
			
			var title:String ;
			var text:String ;
			var icon:String ;
			
			switch( type )
			{
				case "pdf_sent" :
					title = "Thank you!" ;
					text = "Your marketing plan has been saved. A PDF copy of your plan has been sent to your email address. We wish you the best of success in executing your plan." ;
					icon = "success" ; 
					break ;
					
				case "no_email" :
					title = "Sorry, but..." ;
					text = "You have not filled your e-mail information." ;
					icon = "fail" ; 
					break ;
					
				case "success_story_sent" :
					title = "Thank you!" ;
					text = "Your success story has been saved.<br/>We will be in touch shortly." ;
					icon = "success" ; 
					break ;
					
				default :
					break ;
			}
			
			_alert = new AlertPopup( title, text, icon ) ;
			_alert.addEventListener( "closeAlertPopup", hideAlert ) ;
			addChild( _alert ) ;
			_alert.alpha = 0 ;
			_alert.x = stage.stageWidth * .5 - _alert.width * .5 ;
			_alert.y = 200 ;
			
			var tween:GTween = new GTween( _alert, .3, { alpha: 1 } ) ;
			
			_viewHandler.disable( ) ;
		}
		
		private function hideAlert( e:Event = null ):void
		{
			trace( "MainView.hideAlert" ) ;
			if ( !_alert ) return ;
			
			var tween:GTween = new GTween( _alert, .3, { alpha: 0 } ) ;
			tween.addEventListener( Event.COMPLETE, completeHandler ) ;
			
			_viewHandler.enable( ) ;
			
			function completeHandler( e:Event ):void
			{
				tween.removeEventListener( Event.COMPLETE, completeHandler ) ;
				_alert.removeEventListener( "closeAlertPopup", hideAlert ) ;
				if ( contains( _alert ) ) removeChild( _alert ) ;
				_alert = null ;	
			}
		}
		
		public function submitData( ):void
		{
			if ( MainController.currentState.category == "0" ) PDFController.createPDF( ) ;
			showAlert( "pdf_sent" ) ;
		}
		
		public function resize( ):void
		{
			if ( _viewHandler ) _viewHandler.resize( ) ;
		}
		
		// EVENT HANDLERS
		
		private function onAddedToStage( e:Event ):void 
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage ) ;
			MainController.getInstance( ).addEventListener( StateEvent.CHANGE, onStateChange ) ;
		}
		
		private function onStateChange( e:StateEvent ):void 
		{
			trace( "MainView.onStateChange:", e.state.toString( ) ) ;
			
			if ( !_viewHandler ) 
			{
				_viewHandler = PageViewHandler.getInstance( ) ;
				addChildAt( _viewHandler, 0 ) ;
			}
			
			_viewHandler.update( e.state ) ;
			dispatchEvent( new Event( Event.RESIZE, true ) ) ;
		}
		
		private function onInfo( e:ApplicationEvent ):void
		{
			if ( !_infoBox )
			{
				_infoBox = new InfoBox( ) ;
				_infoBox.x = 20 ;
				_infoBox.y = 20 ;
				_infoBox.alpha = 0 ;
				_infoBox.tf.condenseWhite = true ;
				_infoBox.close_btn.buttonMode = _infoBox.close_btn.useHandCursor = true ;
				_infoBox.close_btn.addEventListener( MouseEvent.CLICK, removeInfoBox ) ;
				_infoBox.addEventListener( MouseEvent.MOUSE_DOWN, dragInfoBox ) ;
				addChild( _infoBox ) ;
				
				var tween:GTween = new GTween( _infoBox, .35, { alpha: 1 } ) ;
			}
			
			_infoBox.tf.htmlText = e.value ;
			_infoBox.tf.height = _infoBox.tf.textHeight + 5 ;
			_infoBox.bg.height = _infoBox.tf.textHeight + 30 ;
		}
		
		private function removeInfoBox( e:MouseEvent = null ):void
		{
			if ( !_infoBox ) return ;
			
			var tween:GTween = new GTween( _infoBox, .35, { alpha: 0 } ) ;
			tween.addEventListener( Event.COMPLETE, completeHandler ) ;
			
			function completeHandler( e:Event ):void
			{
				tween.removeEventListener( Event.COMPLETE, completeHandler ) ;
				removeChild( _infoBox ) ;
				_infoBox = null ;
			}
		}
		
		private function dragInfoBox( e:MouseEvent ):void
		{
			var dragRect:Rectangle = new Rectangle( _viewHandler.x, _viewHandler.y, _viewHandler.width, _viewHandler.height ) ;
			_infoBox.startDrag( false, dragRect ) ;
			stage.addEventListener( MouseEvent.MOUSE_UP, stopBoxDrag ) ;
		}
		
		private function stopBoxDrag( e:MouseEvent ):void
		{
			stopDrag( ) ;
		}
	
	}
}