package com.nsn.channel.view.forms 
{
	
	import flash.text.TextField;
	
	import com.nsn.channel.interfaces.IForm;
	import com.nsn.channel.view.forms.Form;
	import com.nsn.channel.model.MainModel ;
	import com.nsn.channel.view.MainView ;
	
	/*
	 * A checkbox group form. The value is an array of the labels of all checked boxes in the group.
	 * 
	 */
	
	public class CheckBoxGroup extends Form implements IForm
	{
		
		private var _items:Array ;
		private var _title:TextField ;
		private var _groupHeight:Number ;
		
		public function CheckBoxGroup( page_id:String, data:XML ) 
		{
			super( page_id, data ) ;
		}
		
		// PUBLIC METHODS
		
		override public function getHeight( ):Number
		{
			return _groupHeight ;
		}
		
		/*
		 * @return An array of the checked child items' labels.
		 */
		
		override public function getValue( ):*
		{
			var arr:Array = new Array( ) ;
			
			for ( var i in _items )
			{
				if ( _items[i].getValue( ) == true ) 
				{
					arr.push( _items[i].getLabel( ) ) ;
				}
			}
			
			return arr ;
		}
		
		// PRIVATE METHODS
		
		override protected function render( ):void
		{
			renderTitle( ) ;
			renderItems( ) ;
		}
		
		private function renderTitle( ):void
		{
			_title = MainView.getTextField( ) ;
			_title.htmlText = _data.title.text( ) ;
			addChild( _title ) ;
		}
		
		private function renderItems( ):void
		{
			_items = new Array( ) ;
			var data:XML = MainModel.getMenu( _data.@data ) ;
			
			for ( var i in data.item )
			{
				_items[i] = new CheckBoxForm( _page, data.item[i] ) ;
				addChild( _items[i] ) ;
				
				if ( i == 0 )
				{
					_items[i].y = _title.y + _title.textHeight + 10 ;
					_groupHeight = _items[i].y + _items[i].getHeight( ) ;
				}
				
				else
				{
					var prev:Form = _items[ i - 1 ] ;
					_items[i].y = prev.y + prev.getHeight( ) - 1 ;
					_groupHeight += _items[i].getHeight( ) ;
				}
			}
		}

	}
	
}