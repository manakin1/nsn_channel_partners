package com.nsn.channel.view.pages 
{
	
	import flash.display.MovieClip ;
	import flash.display.Sprite ;
	import flash.events.Event ;
	import flash.events.MouseEvent ;
	import flash.text.TextField ;
	import flash.utils.Dictionary ;
	import flash.utils.getDefinitionByName ;
	
	import com.nsn.channel.control.MainController ;
	import com.nsn.channel.control.State;
	import com.nsn.channel.model.MainModel ;
	import com.nsn.channel.model.Constants ;
	import com.nsn.channel.events.ApplicationEvent ;
	import com.nsn.channel.view.MainView ;
	import com.nsn.channel.view.PageTemplate ;
	import com.nsn.channel.view.forms.Form ;
	import com.nsn.channel.interfaces.IForm ;
	
	import com.gskinner.motion.GTween ;
	import fl.motion.easing.Quadratic ;

	/*
	 * The abstract Page class.
	 */
	
	public class Page extends Sprite
	{
		
		protected var _data:XML ;									// the page's XML data
		
		protected var _presentationData:Array ; 					// any data that needs to be saved for PDF visualization
		protected var _columns:Array ;								// an array of columns on the page
		protected var _items:Array ;								// an array of items on the page
		
		protected var _id:String ;									// the unique page id
		protected var _category:String ;							// the id of the page's category
		
		protected var _title:TextField ;							// the main title of the page
		protected var _header:TextField ;							// the optional header of the page
		protected var _text:TextField ;								// the main text of the page
				
		protected var _infoButton:MovieClip ;						// the optional tooltip button for displaying more info
		protected var _template:MovieClip ;							// the page skin, found in the Flash library

		public function Page( cat_id:String, data:XML ) 
		{
			_data = data ;
			_category = cat_id ;
			_id = cat_id + "_" + _data.@id ;
			
			addListeners( ) ;
			render( ) ;
			registerForms( ) ;
		}
		
		// PUBLIC METHODS
		
		/*
		 * Saves page data for the PDF visualization
		 */
		
		public function saveData(  ):void { }

		// PRIVATE METHODS
		
		protected function render( ):void { }
		
		protected function renderText( ):void { }

		protected function renderHeader( ):void
		{
			if ( String( _data.header.text.text( ) ).length > 0 )
			{
				_header = MainView.getTextField( true ) ;
				_header.htmlText = _data.header.text.text( ) ;
				_header.width = 500 ;
				_header.x = _title.x ;
				_header.y = _title.y + _title.height + 20 ;
				addChild( _header ) ;
				
				if ( String( _data.header.info.text( ) ).length > 0 )
				{
					_infoButton = new InfoButton( ) ;
					addChild( _infoButton ) ;
					_infoButton.buttonMode = _infoButton.useHandCursor = true ;
					_infoButton.x = _header.x + _header.textWidth + 10 ;
					_infoButton.y = _header.y ;
					_infoButton.addEventListener( MouseEvent.CLICK, showInfo ) ;
				}
			}
		}
		
		protected function renderTitle( ):void
		{
			_title = MainView.getTextField( ) ;
			_title.width = 600 ;
			_title.htmlText = _data.title.text( ) ;	
			
			_title.x = 15 ;
			if ( !MainController.currentState.category ) _title.y = 70 ;
			else if ( MainController.currentState.category == "1" ) _title.y = 40 ;
			else _title.y = 110 ;
			
			addChild( _title ) ;
		}
		
		/*
		 * Renders all items specified in the XML data. If the form already exists it's pulled from the registry,
		 * otherwise a new one is created.
		 */
		
		protected function renderItems( ):void
		{
			_items = new Array( ) ;
			
			for ( var i in _data.item )
			{
				var item_id:String = _id + "_" + _data.item[i].@id ;
				
				if ( MainModel.getForm( item_id ) ) 
					_items[ _data.item[i].@id ] = MainModel.getForm( item_id ) ;
				
				else 
					_items[ _data.item[i].@id ] = MainView.createForm( _id, _data.item[i] ) ;
			}
		}
		
		/*
		 * Create a new form from the class name specified in the XML. All form classes should be defined in
		 * com.nsn.channel.view.Templates.
		 * 
		 * @param data The XML data of the form
		 * @return The newly created Form instance
		 */
		
		protected function createForm( data:XML ):IForm
		{
			var form:IForm ;
			
			var formClassName:String = "com.nsn.channel.view.forms." + data.@type.toString( ) ;
			var formClass:Class = getDefinitionByName( formClassName ) as Class ;
			form = new formClass( _id, data ) as Form ;
			
			return form ;
		}
		
		/*
		 * Make an array of items in the specified column.
		 * 
		 * @param index The index of the column
		 * @return The array of items
		 */
		
		protected function getColumnChildren( index:int ):Array
		{
			var arr:Array = new Array( ) ;
			
			for ( var i in _data.item )
			{
				if ( _data.item[i].@column == index )
				{
					arr.push( _items[ _data.item[i].@id ] ) ;
				}
			}
			
			return arr ;
		}
		
		/*
		 * Add all of the page's forms in the form registry.
		 */
		
		protected function registerForms( ):void
		{
			for ( var i in _items )
			{
				MainModel.registerForm( _items[i].id, _items[i] ) ;
			}
		}
		
		/*
		 * Hide the previous page before adding a new one.
		 */
		
		private function beginTransitionOut( e:Event ):void
		{
			var tween:GTween = new GTween( this, .2, { alpha: 0 } ) ;
			tween.addEventListener( Event.COMPLETE, completeHandler ) ;
			
			function completeHandler( e:Event ):void
			{
				tween.removeEventListener( Event.COMPLETE, completeHandler ) ;
				dispatchEvent( new Event( "transitionOutComplete" ) ) ;
			}
		}
		
		/*
		 * Display the new page once the previous one has been removed.
		 */
		
		private function beginTransitionIn( e:Event ):void
		{
			this.alpha = 0 ;
			var tween:GTween = new GTween( this, .2, { alpha: 1 } ) ;
			tween.addEventListener( Event.COMPLETE, completeHandler ) ;
			
			function completeHandler( e:Event ):void
			{
				tween.removeEventListener( Event.COMPLETE, completeHandler ) ;
				dispatchEvent( new Event( "transitionInComplete" ) ) ;
			}
		}
		
		private function addListeners( ):void
		{
			addEventListener( "beginTransitionIn", beginTransitionIn ) ;
			addEventListener( "beginTransitionOut", beginTransitionOut ) ;
		}
		
		// EVENT HANDLERS
		
		/*
		 * Show the info popup once the header's tooltip button has been clicked.
		 */
		
		protected function showInfo( e:MouseEvent ):void
		{
			dispatchEvent( new ApplicationEvent( ApplicationEvent.SHOW_INFO, _data.header.info.text( ), true ) ) ;
		}
		
	}
	
}