package com.nsn.channel.control 
{
	
	/*
	 * The State class. Defines the properties of the current page.
	 */
	
	public class State 
	{
		
		private var _id:String ;
		private var _category:String ;
		
		/*
		 * @param category The id of the new page's category, or blank if the page does not belong to any category
		 * @param id The id of the new page.
		 */
		
		public function State( category:String, id:String ) 
		{
			_category = category ;
			_id = id ;
		}

		// GETTERS / SETTERS
		
		public function get id( ):String
		{
			return _id ;
		}
		
		public function get category( ):String
		{
			return _category ;
		}
		
		// PUBLIC METHODS
		
		public function toString( ):String
		{
			return _category + "_" + _id ;
		}
		
	}
	
}