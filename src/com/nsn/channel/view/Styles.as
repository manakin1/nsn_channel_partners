package com.nsn.channel.view 
{
	
	import flash.events.Event ;
	import flash.events.EventDispatcher ;
	import flash.net.URLLoader ;
	import flash.net.URLRequest ;
	import flash.text.StyleSheet ;
	
	public class Styles extends EventDispatcher 
	{

		private static var _instance:Styles ;
		
		private var _cssLoader:URLLoader ;
		private var _styleSheet:StyleSheet ;
		
		public function Styles( ) { }
		
		// PUBLIC METHODS
		
		public static function getInstance( ):Styles 
		{
			if( !_instance ) _instance = new Styles( ) ;
			return _instance ;
		}
		
		public static function getStyleSheet( ):StyleSheet 
		{
			return getInstance( )._styleSheet ;
		}
		
		public function load( url:String ):void 
		{
			_cssLoader = new URLLoader( ) ;
			_cssLoader.addEventListener( Event.COMPLETE, onCSSLoadComplete ) ;
			_cssLoader.load( new URLRequest( url ) ) ;
		}
		
		// EVENT HANDLERS
		
		private function onCSSLoadComplete( e:Event ):void 
		{
			_styleSheet = new StyleSheet( ) ;
			_styleSheet.parseCSS( _cssLoader.data ) ;
			dispatchEvent( new Event( Event.COMPLETE ) ) ;
		}
		
	}
	
}