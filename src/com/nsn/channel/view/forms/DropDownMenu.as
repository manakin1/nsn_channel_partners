package com.nsn.channel.view.forms
{
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.text.TextFormat ;
	
	import com.nsn.channel.interfaces.IForm ;
	import com.nsn.channel.model.MainModel ;
	
	/*
	 * A dropdown menu form. Returns the selected item's label as a value.
	 */
	
	public class DropDownMenu extends Form implements IForm
	{
		
		private var _rows:int					= 10 ;
		
		public function DropDownMenu( col_id:String, data:XML )
		{
			super( col_id, data ) ;
		}
		
		// GETTERS/SETTERS
		
		override public function getHeight( ):Number
		{
			return _field.y + _field.height + 4 ;
		}
		
		override public function getWidth( ):Number
		{
			return _field.width + 10 ;
		}
		
		// PUBLIC METHODS
		
		override public function setValue( val:* ):void { }
		
		override public function getValue( ):*
		{
			return _skin.field.selectedItem.label ;
		}
		
		// PRIVATE METHODS
		
		override protected function renderSkin( ):void
		{
			_skin = new DropDownFormSkin( ) ;
			_label = _skin.label ;
			addChild( _skin ) ;
			
			var format:TextFormat = new TextFormat( ) ;
			format.font = "Arial";
			format.color = 0xffffff;
			format.size = 11;
			format.bold = true ;
			
			_skin.field.textField.setStyle( "textFormat", format ) ;
			
			renderMenu( ) ;
		}
		
		private function renderMenu( ):void
		{
			var dp:DataProvider = new DataProvider( MainModel.getMenu( _data.@data ) ) ;
			_skin.field.dataProvider = dp ;
			_skin.field.rowCount = _rows ;
		}
		
		override protected function renderLabel( ):void
		{
			_label.condenseWhite = true ;
			_label.htmlText = _data.@label ;
			_label.height = _label.textHeight + 5 ;
		}
		
		override protected function setProportions( ):void
		{
			_field = _skin.field ;
			
			if ( int( _data.@width ) > 0 )
			{
				_field.width = int( _data.@width ) ;
			}
			
			if ( int( _data.@height ) > 0 )
			{
				_field.height = int( _data.@height ) ;
			}
			
			_label.x = 0 ;
			_label.y = 8 ;
			_field.y = 5 ;
			if ( _label.textWidth == 0 ) _label.width = 0 ;
			_field.x = _label.x + _label.width + 5 ;
			_skin.icon.x = _field.x + _field.width - _skin.icon.width - 8 ;
			_skin.icon.y = _field.y + 8 ;
		}
		
	}
	
}