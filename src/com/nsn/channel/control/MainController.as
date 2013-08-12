package com.nsn.channel.control 
{	

	import flash.events.EventDispatcher ;
	import flash.events.Event ;

	import com.nsn.channel.model.MainModel ;
	import com.nsn.channel.model.Constants ;
	import com.nsn.channel.view.MainView ;
	import com.nsn.channel.view.PageViewHandler ;
	import com.nsn.channel.events.StateEvent ;
		
	/*
	 * The MainController class that handles the different page states
	 */
	
	public class MainController extends EventDispatcher 
	{
	
		private static var _instance:MainController ;
		private static var _currentState:State ;
		private static var _previousState:State ;
		
		public function MainController( ) { }
				
		// GETTERS / SETTERS
		
		public static function get currentState( ):State
		{
			return _currentState ;
		}
		
		public static function get previousState( ):State
		{
			return _previousState ;
		}
		
		// PUBLIC METHODS
		
		public static function getInstance( ):MainController 
		{
			if( !_instance) _instance = new MainController( ) ;
			return _instance ;
		}
		
		/*
		 * Initializes the application state change.
		 * 
		 * @param category The category of the new page, left blank if the page does not belong to any category
		 * @param id The id of the new page
		 */
	
		public static function navigateTo( category:String, id:String ):void 
		{
			var state:State = new State( category, id ) ;
			changeState( state ) ;
		}
		
		public static function resetState( ):void
		{
			_currentState = null ;
		}
		
		/*
		 * Initializes submitting the current category's form data. Instructs PageViewHandler to save the current
		 * page before calling MainView's handleSubmit function to proceed with the submit.
		 */ 
		
		public static function submitData( ):void
		{
			trace( "MainController.submitData" ) ;
			PageViewHandler.getInstance( ).savePageData( ) ;
			MainView.getInstance( ).handleSubmit( ) ;
		}
		
		// PRIVATE METHODS
		
		/*
		 * Switches to the new state. Instructs PageViewHandler to save the current page before proceeding.
		 * Dispatches a StateEvent to inform listeners that the state has been changed.
		 * 
		 * @param newState The new state
		 */
		
		private static function changeState( newState:State ):void 
		{
			PageViewHandler.getInstance( ).savePageData( ) ;
			_previousState = _currentState ;
			_currentState = newState ;
			getInstance( ).dispatchEvent( new StateEvent( StateEvent.CHANGE, _currentState ) ) ;
		}
		
	}
	
}