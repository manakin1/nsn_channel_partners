package com.nsn.channel.events 
{
	
	import flash.events.Event ;

	public class ApplicationEvent extends Event 
	{
		
		public static const SHOW_INFO:String 			= "showInfo" ;
		public static const CLOSE:String 				= "close" ;
		
		private var _value:* ;
		
		public function ApplicationEvent( type:String, value:String, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable ) ;
			_value = value ;
		}
		
		// GETTERS / SETTERS
		
		public function get value( ):* 
		{
			return _value ;
		}

	
	}
	
}