package com.nsn.channel.model 
{
	
	import flash.display.Bitmap;
	import flash.display.Loader ;
	import flash.display.LoaderInfo ;
	import flash.events.EventDispatcher ;
	import flash.events.Event ;
	import flash.events.ErrorEvent ;
	import flash.events.IOErrorEvent ;
	import flash.events.SecurityErrorEvent ;
	import flash.net.URLLoader ;
	import flash.net.URLRequest ;
	import flash.utils.Dictionary ;
	
	import com.nsn.channel.view.forms.Form ;
	
	import br.com.stimuli.loading.BulkLoader ;
	
	/*
	 * The MainModel class. Holds the API for accessing XML data and keeps a registry of all forms with
	 * their respective values.
	 * 
	 * @TODO The data model and form registry could be split into separate classes later on.
	 */

	public class MainModel extends EventDispatcher 
	{
		
		private static var _instance:MainModel ; 
		private static var _content:XML ;
		private static var _XMLLoader:URLLoader ;
		private static var _contentLoader:BulkLoader ;
		
		private static var _inputData:Dictionary ;
		private static var _formData:Dictionary ;
		
		public function MainModel( ) { }
		
		// PUBLIC METHODS
		
		public static function getInstance( ):MainModel 
		{
			if( !_instance ) _instance = new MainModel( ) ;
			return _instance ;
		}

		/*
		 * Returns a preloaded image.
		 * 
		 * @param id The id of the image
		 * @return The image
		 */
		
		public static function getImage( id:String ):*
		{
			return _contentLoader.getContent( id ) ;
		}
		
		/*
		 * @return The number of categories
		 */
		
		public static function getNumCategories( ):int
		{
			return _content.pages.category.length( ) ;
		}
		
		/*
		 * @return An XML containing all categories and their children
		 */ 
		
		public static function getCategories( ):XML
		{
			return new XML( _content.pages ) ;
		}
		
		/*
		 * @param id The id of the category
		 * @return An XML containing the specified category and its children
		 */
		
		public static function getCategory( id:String ):XML
		{
			return new XML( _content.pages.category.( @id == id ) ) ;
		}
		
		/*
		 * Returns a specific page
		 * 
		 * @param cat The category of the page
		 * @param id The id of the page
		 * @return An XML containing the page and its children
		 */

		public static function getPage( cat:String, id:String ):XML
		{
			if ( !cat.length ) return new XML( _content.pages.page.( @id == id ) ) ;
			else return new XML( _content.pages.category.( @id == cat ).page.( @id == id ) ) ;
		}
		
		/*
		 * Get all pages in the specified category
		 * 
		 * @param id The id of the category
		 * @return An XML containing all the pages in the category
		 */
		
		public static function getPages( id:String ):XML
		{
			return new XML( _content.pages.category.( @id == id ) ) ;
		}
		
		/*
		 * Get the number of pages in the specified category
		 * 
		 * @param id The id of the category
		 * @return The number of pages
		 */
		
		public static function getNumPages( id:String ):int
		{
			return _content.pages.category.( @id == id ).page.length( ) ;
		}
		
		/*
		 * Get all items in the specified menu
		 * 
		 * @param id The id of the menu
		 * @return An XML containing the menu items
		 */
		
		public static function getMenu( id:String ):XML
		{
			return new XML( _content.menus.menu.( @id == id ) ) ;
		}
		
		/*
		 * @param id The id of the text
		 * @return The specified text as a String
		 */
		
		public static function getText( id:String ):XML
		{
			return new XML( _content.texts.text.( @id == id ).text( ) ) ;
		}
		
		/*
		 * Get all email recipients specified in the content XML
		 * 
		 * @return An XML containing the email addresses
		 */
		
		public static function getRecipients( ):XML
		{
			return new XML( _content.recipients ) ;
		}
		
		/*
		 * Get all fields in the specified category that are marked as required but not filled. This method is 
		 * obsolete in this version as the email field is the only one that can't be left blank.
		 * 
		 * @param cat The id of the category 
		 * @return An array of objects with the page id and XML data of each blank field
		 * 
		 */
		
		public static function getMissingFields( cat:String ):Array
		{
			var arr:Array = new Array( ) ;
			var data:XML = getCategory( cat ) ;
			
			for ( var i in data.page )
			{
				for ( var j in data.page[i].item )
				{
					var req:String = String( data.page[i].item[j].@required ) ;
					
					if ( req == "true" )
					{
						var id:String = cat + "_" + i + "_" + j ;
						
						if ( !_formData[ id ] || getInput( id ).length <= 1 )
						{
							var obj:Object = { page: i, data: data.page[i].item[j] } ;
							arr.push( obj ) ;
						}
					}
				}
			}
			
			return arr ;
		}
		
		/*
		 * Get the label of the specified item
		 * 
		 * @param id The id of the item
		 * @return The item's label as a String
		 */
		
		public static function getLabel( id:String ):String
		{
			var id_arr:Array = id.split( "_" ) ;
			
			var pagedata:XML = getPage( id_arr[0], id_arr[1] ) ;
			var data:XMLList = pagedata.item.( @id == id_arr[2] ) ;
			
			// return the content text of the label node in case the form doesn't have a label attribute
			
			if ( String( data.@label ).length > 0 ) return String( data.@label ) ;
			else return data.label.text( ) ;
		}
		
		public static function loadXML( src:String ):void 
		{
			trace( "MainModel.loadXML:", src ) ;
			_XMLLoader = new URLLoader( ) ;
			_XMLLoader.addEventListener( Event.COMPLETE, onXMLLoadComplete ) ;
			_XMLLoader.addEventListener( IOErrorEvent.IO_ERROR, onContentLoadError ) ;
			_XMLLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onContentLoadError ) ;
			_XMLLoader.load( new URLRequest( src ) ) ;
		}
		
		/*
		 * Get the specified form's value
		 * 
		 * @param id The form's id
		 * @return The form's value
		 */
		
		public static function getInput( id:String ):*
		{
			if ( !_formData ) return "" ;
			if ( !_formData[ id ] ) return "" ;
			else return _formData[ id ].getValue( ) ;
		}
		
		/*
		 * Adds the form to the registry as soon as it's been created. After this the form will always be retrieved
		 * from the registry instead of creating a new instance.
		 * 
		 * @param id The unique id of the form. The format is <category_id>_<page_id>_<form_id>.
		 * @param obj The form object
		 */
		
		public static function registerForm( id:String, obj:Form ):void
		{
			if ( !_formData ) _formData = new Dictionary( ) ;
			if( !_formData[ id ] ) _formData[ id ] = obj ;
		}
		
		/*
		 * Updates the form instance. Basically this replaces the old form object in the registry.
		 * 
		 * @param id The id of the form
		 * @param obj The form object
		 */
		
		public static function updateForm( id:String, obj:Form ):void
		{
			_formData[ id ] = obj ;
		}
		
		/*
		 * Retrieves the specified form from the registry.
		 * 
		 * @param id The id of the form
		 * @return The form object
		 */
		
		public static function getForm( id:String ):Form
		{
			if ( !_formData ) return null ;
			return _formData[ id ] as Form ;
		}
		
		/*
		 * Preloads all images.
		 */
		
		public static function loadContent( ):void
		{
			if ( !_contentLoader ) _contentLoader = new BulkLoader( "main" ) ;
			_contentLoader.addEventListener( IOErrorEvent.IO_ERROR, onContentLoadError ) ;
			_contentLoader.addEventListener( Event.COMPLETE, onContentLoadComplete ) ;
			
			for ( var i in _content.images.image )
			{
				var image_id:String = String( _content.images.image[i].@id ) ;
				var url:String = String( _content.images.image[i].@src ) ;
				_contentLoader.add( url, { id: image_id } ) ;
			}
			
			_contentLoader.start( ) ;
		}
		
		// PRIVATE METHODS
		
		// EVENT HANDLERS
		
		private static function onXMLLoadComplete( e:Event ):void
		{
			trace( "MainModel.onXMLLoadComplete" ) ;
			_XMLLoader.removeEventListener( Event.COMPLETE, onXMLLoadComplete ) ;
			_XMLLoader.removeEventListener( IOErrorEvent.IO_ERROR, onContentLoadError ) ;
			_XMLLoader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onContentLoadError ) ;
			_content = new XML( URLLoader( e.currentTarget ).data ) ;
			getInstance( ).dispatchEvent( new Event( Event.COMPLETE ) ) ;
		}
		
		private static function onContentLoadComplete( e:Event ):void
		{
			trace( "MainModel.onContentLoadComplete" ) ;
			_contentLoader.removeEventListener( Event.COMPLETE, onContentLoadComplete ) ;
			getInstance( ).dispatchEvent( new Event( Event.COMPLETE ) ) ;
		}
		
		private static function onContentLoadError( e:ErrorEvent ):void 
		{
			trace( "MainModel.contentLoadError:", e ) ;
			getInstance( ).dispatchEvent( new ErrorEvent( ErrorEvent.ERROR ) ) ;
		}
		
		
	}
	
}