package com.nsn.channel.events 
{
	
	import com.nsn.channel.control.State ;
	
	import flash.events.Event;

	public class StateEvent extends Event 
	{
		
		public static const CHANGE:String 			= "changeState" ;
		
		private var _state:State ;
		
		public function StateEvent( type:String, state:State, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable ) ;
			_state = state ;
		}
		
		// GETTERS / SETTERS
		
		public function get state( ):State 
		{
			return _state ;
		}

	
	}
	
}