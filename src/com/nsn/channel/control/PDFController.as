package com.nsn.channel.control 
{
	
	import flash.display.Bitmap;
	import flash.net.URLRequest ;
	import flash.net.URLLoader ;
	import flash.net.URLLoaderDataFormat ;
	import flash.events.Event ;
	import flash.utils.ByteArray ;
	
	import com.nsn.channel.model.MainModel ;
	import com.nsn.channel.view.forms.Form;
	
	import org.alivepdf.pdf.PDF ;
	import org.alivepdf.layout.Layout ;
	import org.alivepdf.layout.Orientation ;
	import org.alivepdf.layout.Unit ;
	import org.alivepdf.layout.Size ;
	import org.alivepdf.saving.Download ;
	import org.alivepdf.saving.Method ;
	import org.alivepdf.fonts.Style ;
	import org.alivepdf.fonts.FontFamily ;
	import org.alivepdf.images.ResizeMode ;
	import org.alivepdf.colors.RGBColor ;
	
	public class PDFController
	{
		
		private static var _pdf:PDF ;
		private static var _page:int ;
		private static var _totalPages:int			= 11 ;
		private static var _loader:URLLoader ; 
		
		public function PDFController( ) 
		{
		}
		
		// PUBLIC METHODS

		public static function createPDF( data:XML = null ):void
		{
			_page = 0 ;
			_pdf = new PDF( Orientation.PORTRAIT, Unit.MM, Size.A4 ) ;
			nextPage( ) ;
		}
		
		// PRIVATE METHODS
		
		private static function addCover( ):void
		{
			loadImage( "data/images/pdf_cover.jpg" ) ;	
		}
		
		private static function addTableOfContents( ):void
		{
			loadImage( "data/images/pdf_contents.jpg" ) ;	
		}
		
		private static function addThankYouPage( ):void
		{
			loadImage( "data/images/thankyou.jpg" ) ;	
		}
		
		private static function setProgramLine( ):void
		{
			var date:Date = new Date( ) ;
			var m:Number = date.getMonth( ) + 1 ;
			var y:Number = date.getFullYear( ) ;
			var d:Number = date.getDate( ) ;
			
			var m_str:String = String( m ) ;
			var y_str:String = String( y ).substr( 2 ) ;
			var d_str:String = String( d ) ;
			
			if ( m < 10 ) m_str = "0" + m_str ;
			if ( d < 10 ) d_str = "0" + d_str ;
			
			var date_str:String = d_str + "." + m_str + "." + y_str ; 
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 9 ) ;
			_pdf.textStyle( new RGBColor ( 0x000000 ), 1 ) ;
			
			_pdf.addText( date_str, 8, 11 ) ;
			_pdf.addText( "Channel Partner Program", 32, 11 ) ;
		}
		
		private static function save( ):void
		{
			trace( "PDFController.save" ) ;
			
			var company_name:String = MainModel.getInput( "0_0_0" ).split( " " ).join( "_" ) ;
			var email:String = MainModel.getInput( "0_0_1" ) ;
			var name:String = "NSN_ChannelPartnerProgram_" + ( email.split( "@" ).join( "_" ) ) + ".pdf" ;
			var url:String = "data/pdf/create.php?email=" + email ;
			
			var email2:String = MainModel.getRecipients( ).recipient[0].@address ;
			var email3:String = MainModel.getRecipients( ).recipient[1].@address ;
			
			_pdf.save( Method.REMOTE, "data/pdf/create.php", Download.INLINE, name, "_blank", email, email2, email3 ) ;
		}
		
		private static function loadImage( path:String ):void
		{			
			if ( !_loader )
			{
				_loader = new URLLoader( ) ;	
				_loader.dataFormat = URLLoaderDataFormat.BINARY ;
			}
			
			_loader.addEventListener( Event.COMPLETE, onImageLoadComplete ) ;
			_loader.load( new URLRequest( path ) ) ;						
		}
 
		private static function onImageLoadComplete( e:Event ):void
		{			
			_loader.removeEventListener( Event.COMPLETE, onImageLoadComplete ) ;
			_pdf.addPage( ) ;
			if( _page > 1 ) setProgramLine( ) ;
			_pdf.addImageStream( ByteArray( e.target.data ), 0, 0, 0, 0, 1, ResizeMode.FIT_TO_PAGE ) ;
			nextPage( ) ;
		}
		
		private static function nextPage( ):void
		{
			if ( _page >= _totalPages ) save( ) ;
			
			else 
			{
				_page++ ;
				
				switch( _page )
				{
					case 1:
						addCover( ) ;
						break ;
						
					case 2:
						addTableOfContents( ) ;
						break ;
						
					case 11:
						addThankYouPage( ) ;
						break ;
						
					default :
						addContentPage( _page ) ;
						break ;
				}
				
			}
		}
		
		private static function addContentPage( index:int ):void
		{
			if ( index == 3 ) addCurrentState( ) ;
			else if ( index == 4 ) addMarketInfo( ) ;
			else if ( index == 5 ) addMarketInfo2( ) ;
			else if ( index == 6 ) addDirection( ) ;
			else if ( index == 7 ) addActionPlan( ) ;
			else if ( index == 8 ) addLevels( ) ;
			else if ( index == 9 ) addKPI( ) ;
			else if ( index == 10 ) addKPI2( ) ;
		}
		
		private static function drawLine( line_y:Number ):void
		{
			_pdf.lineStyle( new RGBColor ( 0x666666 ), .25, 1 ) ;
			_pdf.moveTo ( 15, line_y ) ;
			_pdf.lineTo ( 190, line_y ) ;
			_pdf.end( ) ;	
		}
		
		private static function addCurrentState( ):void
		{
			_pdf.addPage( ) ;
			
			setProgramLine( ) ;
			
			var h:Number = 50 ;
			var row_height:Number = 6 ;
			
			var col1:Number = 15 ;
			var col2:Number = 100 ;
			var col3:Number = 80 ;
		
			// PAGE TITLE 
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 32 ) ;
			_pdf.textStyle( new RGBColor ( 0xd6821c ), 1 ) ;
			_pdf.addText( "1. Current State", 8, 30 ) ;
			
			// PAGE HEADER
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 10 ) ;
			_pdf.textStyle( new RGBColor ( 0xd6821c ), 1 ) ;
			_pdf.addText( "Your business", 10, 45 ) ;
			
			_pdf.textStyle( new RGBColor ( 0x666666 ), 1 ) ;
			
			// FIELDS
			
			_pdf.addText( MainModel.getLabel( "0_0_0" ), col1, 55 ) ;
			_pdf.addText( MainModel.getInput( "0_0_0" ), col2, 55 ) ;
			 
			drawLine( 57 ) ;
			
			_pdf.addText( MainModel.getLabel( "0_0_1" ), col1, 62 ) ;
			_pdf.addText( MainModel.getInput( "0_0_1" ), col2, 62 ) ;
			
			drawLine( 65 ) ;
			
			_pdf.addText( MainModel.getLabel( "0_0_2" ), col1, 70 ) ;
			_pdf.addText( MainModel.getInput( "0_0_2" ), col2, 70 ) ;
			
			drawLine( 73 ) ;
			
			_pdf.addText( MainModel.getLabel( "0_0_3" ), col1, 78 ) ;
			
			_pdf.setXY( col1, 80 ) ;
			_pdf.addMultiCell( 150, 4, MainModel.getInput( "0_0_3" ) ) ; 
			
			// COMPETITOR DATA
			
			h = 100 ;
			
			var comp_data:Array = MainModel.getInput( "0_0_4" ) as Array ;
			
			for ( var i in comp_data )
			{
				if ( i < 4 )
				{
					trace( "COMP DATA", i ) ;
					
					_pdf.textStyle( new RGBColor ( 0xd6821c ), 1 ) ;
					var label:String = "Competitor " + ( i + 1 ) ;
					_pdf.addText( label, 10, h ) ;
					_pdf.textStyle( new RGBColor ( 0x666666 ), 1 ) ;
					
					_pdf.addText( "Name of competitor", col1, h + 8 ) ;
					_pdf.addText( comp_data[i][0], col3, h + 8 ) ;
					
					drawLine( h + 11 ) ;
					
					_pdf.addText( "Market share", col1, h + 16 ) ;
					_pdf.addText( comp_data[i][1], col3, h + 16 ) ;
					
					drawLine( h + 19 ) ;
					
					_pdf.addText( "What actions will they undertake", col1, h + 24 ) ;
					
					_pdf.setXY( col3, h + 20 ) ;
					_pdf.addMultiCell( 110, 4, comp_data[i][2] ) ; 
					
					h += 35 ;
				}
			}
			
			nextPage( ) ;
		}
		
		private static function addMarketInfo( ):void
		{
			_pdf.addPage( ) ;
			
			setProgramLine( ) ;
			
			var col1:Number = 15 ;
			var col2:Number = 75 ;
			var col3:Number = 90 ;
			var col4:Number = 175 ;
			
			// PAGE TITLE 
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 32 ) ;
			_pdf.textStyle( new RGBColor ( 0xd6821c ), 1 ) ;
			_pdf.addText( "2. Addressable market info", 8, 30 ) ;
			
			// PAGE HEADER
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 10 ) ;
			_pdf.textStyle( new RGBColor ( 0xd6821c ), 1 ) ;
			_pdf.addText( "Identify key markets that you operate in", 10, 50 ) ;
			
			_pdf.textStyle( new RGBColor ( 0x666666 ), 1 ) ;
			
			// ROW 1
			
			var h:Number = 65 ;
			var row_height:Number = 6 ;
			
			// FIELDS
			
			_pdf.addText( "Market sub-segment", col1, h ) ;
			_pdf.addText( "Your annual growth rate in the market (CAGR)", col3, h ) ;
			_pdf.addText( MainModel.getInput( "0_1_0" ), col1, h + 4 ) ;
			_pdf.addText( MainModel.getInput( "0_1_18" ), col4, h ) ;
			
			h = 69 ;
			drawLine( h + 2 ) ;
			
			_pdf.addText( "Size of the sub-segment (%)", col1, ( h + row_height ) ) ;
			_pdf.addText( "NSN equipment's current share", col3, ( h + row_height ) ) ;
			_pdf.addText( "of the sub-segment (%)", col3, ( h + row_height + row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_6" ), col2, ( h + row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_24" ), col4, ( h + row_height ) ) ;

			drawLine( h + 14 ) ;
			
			_pdf.addText( "Your share of the sub-segment (%)", col1, h + ( 3 * row_height ) ) ;
			_pdf.addText( "NSN equipment's potential share (%)", col3, h + ( 3 * row_height ) ) ;
			_pdf.addText( "of the sub-segment (%)", col3, h + ( 3 * row_height ) + row_height ) ;
			_pdf.addText( MainModel.getInput( "0_1_12" ), col2, h + ( 3 * row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_30" ), col4, h + ( 3 * row_height ) ) ;
			
			drawLine( h + 26 ) ;
			
			_pdf.addText( "What actions would help us together", col1, h + ( 5 * row_height ) ) ;
			_pdf.addText( "reach the potential share of the sub-segment", col1, h + ( 5 * row_height ) + row_height - 2 ) ;
			
			_pdf.setXY( col3, h + ( 4.5 * row_height ) ) ;
			_pdf.addMultiCell( 80, 4, MainModel.getInput( "0_1_36" ) ) ; 
			
			
			// ROW 2
			
			h = 140 ;
			
			// FIELDS
			
			_pdf.addText( "Market sub-segment", col1, h ) ;
			_pdf.addText( "Your annual growth rate in the market (CAGR)", col3, h ) ;
			_pdf.addText( MainModel.getInput( "0_1_1" ), col1, h + 4 ) ;
			_pdf.addText( MainModel.getInput( "0_1_19" ), col4, h ) ;
			 
			h = 144 ;
			drawLine( h + 2 ) ;
			
			_pdf.addText( "Size of the sub-segment (%)", col1, ( h + row_height ) ) ;
			_pdf.addText( "NSN equipment's current share", col3, ( h + row_height ) ) ;
			_pdf.addText( "of the sub-segment (%)", col3, ( h + row_height + row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_7" ), col2, ( h + row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_25" ), col4, ( h + row_height ) ) ;

			drawLine( h + 14 ) ;
			
			_pdf.addText( "Your share of the sub-segment (%)", col1, h + ( 3 * row_height ) ) ;
			_pdf.addText( "NSN equipment's potential share (%)", col3, h + ( 3 * row_height ) ) ;
			_pdf.addText( "of the sub-segment (%)", col3, h + ( 3 * row_height ) + row_height ) ;
			_pdf.addText( MainModel.getInput( "0_1_13" ), col2, h + ( 3 * row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_31" ), col4, h + ( 3 * row_height ) ) ;
			
			drawLine( h + 26 ) ;
			
			_pdf.addText( "What actions would help us together", col1, h + ( 5 * row_height ) ) ;
			_pdf.addText( "reach the potential share of the sub-segment", col1, h + ( 5 * row_height ) + row_height - 2 ) ;
			
			_pdf.setXY( col3, h + ( 4.5 * row_height ) ) ;
			_pdf.addMultiCell( 80, 4, MainModel.getInput( "0_1_37" ) ) ; 
			
			// ROW 3
			
			h = 215 ;
			
			// FIELDS
			
			_pdf.addText( "Market sub-segment", col1, h ) ;
			_pdf.addText( "Your annual growth rate in the market (CAGR)", col3, h ) ;
			_pdf.addText( MainModel.getInput( "0_1_2" ), col1, h + 4) ;
			_pdf.addText( MainModel.getInput( "0_1_20" ), col4, h ) ;
			 
			h = 219 ;
			drawLine( h + 2 ) ;
			
			_pdf.addText( "Size of the sub-segment (%)", col1, ( h + row_height ) ) ;
			_pdf.addText( "NSN equipment's current share", col3, ( h + row_height ) ) ;
			_pdf.addText( "of the sub-segment (%)", col3, ( h + row_height + row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_8" ), col2, ( h + row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_26" ), col4, ( h + row_height ) ) ;

			drawLine( h + 14 ) ;
			
			_pdf.addText( "Your share of the sub-segment (%)", col1, h + ( 3 * row_height ) ) ;
			_pdf.addText( "NSN equipment's potential share (%)", col3, h + ( 3 * row_height ) ) ;
			_pdf.addText( "of the sub-segment (%)", col3, h + ( 3 * row_height ) + row_height ) ;
			_pdf.addText( MainModel.getInput( "0_1_14" ), col2, h + ( 3 * row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_32" ), col4, h + ( 3 * row_height ) ) ;
			
			drawLine( h + 26 ) ;
			
			_pdf.addText( "What actions would help us together", col1, h + ( 5 * row_height ) ) ;
			_pdf.addText( "reach the potential share of the sub-segment", col1, h + ( 5 * row_height ) + row_height - 2 ) ;
			
			_pdf.setXY( col3, h + ( 4.5 * row_height ) ) ;
			_pdf.addMultiCell( 80, 4, MainModel.getInput( "0_1_38" ) ) ; 
			
			nextPage( ) ;
		}
		
		private static function addMarketInfo2( ):void
		{
			_pdf.addPage( ) ;
			
			setProgramLine( ) ;
			
			var col1:Number = 15 ;
			var col2:Number = 75 ;
			var col3:Number = 90 ;
			var col4:Number = 175 ;
			
			// PAGE HEADER
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 10 ) ;
			_pdf.textStyle( new RGBColor ( 0xd6821c ), 1 ) ;
			_pdf.addText( "Identify key markets that you operate in", 10, 50 ) ;
			
			_pdf.textStyle( new RGBColor ( 0x666666 ), 1 ) ;
			
			// ROW 1
			
			var h:Number = 65 ;
			var row_height:Number = 6 ;
			
			// FIELDS
			
			_pdf.addText( "Market sub-segment", col1, h ) ;
			_pdf.addText( "Your annual growth rate in the market (CAGR)", col3, h ) ;
			_pdf.addText( MainModel.getInput( "0_1_3" ), col1, h + 4 ) ;
			_pdf.addText( MainModel.getInput( "0_1_21" ), col4, h ) ;
			 
			h = 69 ;
			drawLine( h + 2 ) ;
			
			_pdf.addText( "Size of the sub-segment (%)", col1, ( h + row_height ) ) ;
			_pdf.addText( "NSN equipment's current share", col3, ( h + row_height ) ) ;
			_pdf.addText( "of the sub-segment (%)", col3, ( h + row_height + row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_9" ), col2, ( h + row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_27" ), col4, ( h + row_height ) ) ;

			drawLine( h + 14 ) ;
			
			_pdf.addText( "Your share of the sub-segment (%)", col1, h + ( 3 * row_height ) ) ;
			_pdf.addText( "NSN equipment's potential share (%)", col3, h + ( 3 * row_height ) ) ;
			_pdf.addText( "of the sub-segment (%)", col3, h + ( 3 * row_height ) + row_height ) ;
			_pdf.addText( MainModel.getInput( "0_1_15" ), col2, h + ( 3 * row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_33" ), col4, h + ( 3 * row_height ) ) ;
			
			drawLine( h + 26 ) ;
			
			_pdf.addText( "What actions would help us together", col1, h + ( 5 * row_height ) ) ;
			_pdf.addText( "reach the potential share of the sub-segment", col1, h + ( 5 * row_height ) + row_height - 2 ) ;
			
			_pdf.setXY( col3, h + ( 4.5 * row_height ) ) ;
			_pdf.addMultiCell( 80, 4, MainModel.getInput( "0_1_39" ) ) ; 
			
			
			// ROW 2
			
			h = 140 ;
			
			// FIELDS
			
			_pdf.addText( "Market sub-segment", col1, h ) ;
			_pdf.addText( "Your annual growth rate in the market (CAGR)", col3, h ) ;
			_pdf.addText( MainModel.getInput( "0_1_4" ), col1, h + 4 ) ;
			_pdf.addText( MainModel.getInput( "0_1_22" ), col4, h ) ;
			 
			h = 144 ;
			drawLine( h + 2 ) ;
			
			_pdf.addText( "Size of the sub-segment (%)", col1, ( h + row_height ) ) ;
			_pdf.addText( "NSN equipment's current share", col3, ( h + row_height ) ) ;
			_pdf.addText( "of the sub-segment (%)", col3, ( h + row_height + row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_10" ), col2, ( h + row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_28" ), col4, ( h + row_height ) ) ;

			drawLine( h + 14 ) ;
			
			_pdf.addText( "Your share of the sub-segment (%)", col1, h + ( 3 * row_height ) ) ;
			_pdf.addText( "NSN equipment's potential share (%)", col3, h + ( 3 * row_height ) ) ;
			_pdf.addText( "of the sub-segment (%)", col3, h + ( 3 * row_height ) + row_height ) ;
			_pdf.addText( MainModel.getInput( "0_1_16" ), col2, h + ( 3 * row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_34" ), col4, h + ( 3 * row_height ) ) ;
			
			drawLine( h + 26 ) ;
			
			_pdf.addText( "What actions would help us together", col1, h + ( 5 * row_height ) ) ;
			_pdf.addText( "reach the potential share of the sub-segment", col1, h + ( 5 * row_height ) + row_height - 2 ) ;
			
			_pdf.setXY( col3, h + ( 4.5 * row_height ) ) ;
			_pdf.addMultiCell( 80, 4, MainModel.getInput( "0_1_40" ) ) ; 
			
			// ROW 3
			
			h = 215 ;
			
			// FIELDS
			
			_pdf.addText( "Market sub-segment", col1, h ) ;
			_pdf.addText( "Your annual growth rate in the market (CAGR)", col3, h ) ;
			_pdf.addText( MainModel.getInput( "0_1_5" ), col1, h + 4 ) ;
			_pdf.addText( MainModel.getInput( "0_1_23" ), col4, h ) ;
			 
			h = 219 ;
			drawLine( h + 2 ) ;
			
			_pdf.addText( "Size of the sub-segment (%)", col1, ( h + row_height ) ) ;
			_pdf.addText( "NSN equipment's current share", col3, ( h + row_height ) ) ;
			_pdf.addText( "of the sub-segment (%)", col3, ( h + row_height + row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_11" ), col2, ( h + row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_29" ), col4, ( h + row_height ) ) ;

			drawLine( h + 14 ) ;
			
			_pdf.addText( "Your share of the sub-segment (%)", col1, h + ( 3 * row_height ) ) ;
			_pdf.addText( "NSN equipment's potential share (%)", col3, h + ( 3 * row_height ) ) ;
			_pdf.addText( "of the sub-segment (%)", col3, h + ( 3 * row_height ) + row_height ) ;
			_pdf.addText( MainModel.getInput( "0_1_17" ), col2, h + ( 3 * row_height ) ) ;
			_pdf.addText( MainModel.getInput( "0_1_35" ), col4, h + ( 3 * row_height ) ) ;
			
			drawLine( h + 26 ) ;
			
			_pdf.addText( "What actions would help us together", col1, h + ( 5 * row_height ) ) ;
			_pdf.addText( "reach the potential share of the sub-segment", col1, h + ( 5 * row_height ) + row_height - 2 ) ;
			
			_pdf.setXY( col3, h + ( 4.5 * row_height ) ) ;
			_pdf.addMultiCell( 80, 4, MainModel.getInput( "0_1_40" ) ) ; 
			
			nextPage( ) ;
		}
		
		private static function addDirection( ):void
		{
			_pdf.addPage( ) ;
			
			setProgramLine( ) ;
			
			var col1:Number = 15 ;
			var col2:Number = 105 ;
			
			// PAGE TITLE 
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 32 ) ;
			_pdf.textStyle( new RGBColor ( 0xd6821c ), 1 ) ;
			_pdf.addText( "3. Your direction,", 8, 30 ) ;
			_pdf.addText( "revenue plan", 32, 40 ) ;
			_pdf.addText( "& targets", 18, 50 ) ;
			
			// PAGE HEADER
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 10 ) ;
			_pdf.addText( "Describe your future direction", 10, 85 ) ;
			
			_pdf.textStyle( new RGBColor ( 0x666666 ), 1 ) ;
			
			// DIRECTION
			
			var h:int = 95 ;
			
			_pdf.addText( MainModel.getLabel( "0_2_0" ), col1, h ) ;
			
			_pdf.setXY( col1, 100 ) ;
			_pdf.addMultiCell( 150, 4, MainModel.getInput( "0_2_0" ) ) ; 
			
			drawLine( h + 22 ) ;
			
			h = 122 ;
			
			_pdf.addText( MainModel.getLabel( "0_2_1" ), col1, h ) ;
			_pdf.addText( MainModel.getInput( "0_2_1" ), col2, h ) ;
			
			drawLine( h + 3 ) ;
			
			_pdf.addText( MainModel.getLabel( "0_2_2" ), col1, h + 8 ) ;
			_pdf.addText( MainModel.getInput( "0_2_2" ), col2, h + 8 ) ;
			
			
			// KEY TARGETS
			
			h = 190 ;
			
			_pdf.textStyle( new RGBColor ( 0xd6821c ), 1 ) ;
			_pdf.addText( "Key targets", 10, h ) ;
			_pdf.textStyle( new RGBColor ( 0x666666 ), 1 ) ;
			
			for ( var i:int = 0 ; i < 5 ; i++ )
			{
				h += 8 ;
				
				var id:String = "0_2_" + ( i + 3 ) ;
				if( MainModel.getInput( id ) )
				{
					var label:String = "Target #" + ( i + 1 ) ;
					_pdf.addText( label, col1, h ) ;
					_pdf.addText( MainModel.getInput( id ), col1 + 20, h ) ;
					drawLine( h + 2 ) ;
				}
			}
			
			nextPage( ) ;
		}
		
		private static function addActionPlan( ):void
		{
			_pdf.addPage( ) ;
			
			setProgramLine( ) ;
			
			var col1:Number = 15 ;
			var col2:Number = 105 ;
			
			// PAGE TITLE 
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 32 ) ;
			_pdf.textStyle( new RGBColor ( 0xd6821c ), 1 ) ;
			_pdf.addText( "4. Prioritized,", 8, 30 ) ;
			_pdf.addText( "action plan", 32, 40 ) ;
			
			// IMAGE
			
			if ( MainModel.getInput( "0_3_0" ) )
			{
				var image:Bitmap = MainModel.getInput( "0_3_0" ) ;
				_pdf.addImage( image, 0, 60 ) ;
			}
			
			// PAGE HEADER 
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 10 ) ;
			_pdf.addText( "Map your future actions according to their importance to revenue and overall business.", 8, 90 ) ;
			
			nextPage( ) ;	
		}
		
		private static function addLevels( ):void
		{
			_pdf.addPage( ) ;
			
			setProgramLine( ) ;
			
			var col1:Number = 15 ;
			var col2:Number = 105 ;
			
			// PAGE TITLE 
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 32 ) ;
			_pdf.textStyle( new RGBColor ( 0xd6821c ), 1 ) ;
			_pdf.addText( "5. Levels of marketing", 8, 30 ) ;
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 10 ) ;
			_pdf.addText( "Map your future actions according to their importance to revenue and overall business.", 8, 90 ) ;
			
			// IMAGE
			
			_loader.addEventListener( Event.COMPLETE, onPageImageLoadComplete ) ;
			_loader.load( new URLRequest( "data/images/funnel.jpg" ) ) ;	
		}
		
		private static function addKPI( ):void
		{
			_pdf.addPage( ) ;
			
			setProgramLine( ) ;
			
			var col1:Number = 15 ;
			var col2:Number = 90 ;
			
			// PAGE TITLE 
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 32 ) ;
			_pdf.textStyle( new RGBColor ( 0xd6821c ), 1 ) ;
			_pdf.addText( "6. Map your progress,", 8, 30 ) ;
			_pdf.addText( "and success with KPIs", 32, 40 ) ;
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 10 ) ;
			_pdf.addText( "Define Key Performance Indicators (KPIs) for your marketing activities as a whole.", 8, 78 ) ;
			
			// TEXT
			
			// ROW 1
			
			_pdf.addText( "KPI #1", 8, 90 ) ;
			
			_pdf.textStyle( new RGBColor ( 0x666666 ), 1 ) ;
			
			var h:Number = 100 ;
			
			_pdf.addText( "What do you aim to achieve", col1, h - 4 ) ;
			
			_pdf.setXY( col2, h - 6.5 ) ;
			_pdf.addMultiCell( 100, 4, MainModel.getInput( "0_5_1" ) ) ; 
			
			drawLine( h + 4 ) ;
			
			_pdf.addText( "How do you measure success.", col1, h + 9 ) ;
			_pdf.addText( "Be specific and use only numerical measures.", col1, h + 13 ) ;
			
			_pdf.setXY( col2, h + 5.5 ) ;
			_pdf.addMultiCell( 100, 4, MainModel.getInput( "0_5_2" ) ) ; 
			
			drawLine( h + 16 ) ;

			_pdf.addText( "Define your success level and what to", col1, h + 21 ) ;
			_pdf.addText( "do after you have reached this level.", col1, h + 25 ) ;
			
			_pdf.setXY( col2, h + 18 ) ;
			_pdf.addMultiCell( 100, 4, MainModel.getInput( "0_5_3" ) ) ; 
			
			drawLine( h + 28 ) ;
			
			_pdf.addText( "Define your critical level and what to", col1, h + 33 ) ;
			_pdf.addText( "do if your performance falls under this level.", col1, h + 37 ) ;
			
			_pdf.setXY( col2, h + 30 ) ;
			_pdf.addMultiCell( 150, 4, MainModel.getInput( "0_5_4" ) ) ; 
			
			// ROW 2
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 10 ) ;
			_pdf.textStyle( new RGBColor ( 0xd6821c ), 1 ) ;
			
			h = 156 ;
			
			_pdf.addText( "KPI #2", 8, h ) ;
			
			_pdf.textStyle( new RGBColor ( 0x666666 ), 1 ) ;
			
			h = 166 ;
			
			_pdf.addText( "What do you aim to achieve", col1, h - 4 ) ;
			
			_pdf.setXY( col2, h - 6.5 ) ;
			_pdf.addMultiCell( 100, 4, MainModel.getInput( "_kpi_page_0" ) ) ; 
			
			drawLine( h + 4 ) ;
			
			_pdf.addText( "How do you measure success.", col1, h + 9 ) ;
			_pdf.addText( "Be specific and use only numerical measures.", col1, h + 13 ) ;
			
			_pdf.setXY( col2, h + 5.5 ) ;
			_pdf.addMultiCell( 100, 4, MainModel.getInput( "_kpi_page_1" ) ) ; 
			
			drawLine( h + 16 ) ;

			_pdf.addText( "Define your success level and what to", col1, h + 21 ) ;
			_pdf.addText( "do after you have reached this level.", col1, h + 25 ) ;
			
			_pdf.setXY( col2, h + 18 ) ;
			_pdf.addMultiCell( 100, 4, MainModel.getInput( "_kpi_page_2" ) ) ; 
			
			drawLine( h + 28 ) ;
			
			_pdf.addText( "Define your critical level and what to", col1, h + 33 ) ;
			_pdf.addText( "do if your performance falls under this level.", col1, h + 37 ) ;
			
			_pdf.setXY( col2, h + 30 ) ;
			_pdf.addMultiCell( 150, 4, MainModel.getInput( "_kpi_page_3" ) ) ; 
			
			// ROW 3
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 10 ) ;
			_pdf.textStyle( new RGBColor ( 0xd6821c ), 1 ) ;
			
			h = 212 ;
			
			_pdf.addText( "KPI #3", 8, h ) ;
			
			_pdf.textStyle( new RGBColor ( 0x666666 ), 1 ) ;
			
			h = 222 ;
			
			_pdf.addText( "What do you aim to achieve", col1, h - 4 ) ;
			
			_pdf.setXY( col2, h - 6.5 ) ;
			_pdf.addMultiCell( 100, 4, MainModel.getInput( "_kpi_page_4" ) ) ; 
			
			drawLine( h + 4 ) ;
			
			_pdf.addText( "How do you measure success.", col1, h + 9 ) ;
			_pdf.addText( "Be specific and use only numerical measures.", col1, h + 13 ) ;
			
			_pdf.setXY( col2, h + 5.5 ) ;
			_pdf.addMultiCell( 100, 4, MainModel.getInput( "_kpi_page_5" ) ) ; 
			
			drawLine( h + 16 ) ;

			_pdf.addText( "Define your success level and what to", col1, h + 21 ) ;
			_pdf.addText( "do after you have reached this level.", col1, h + 25 ) ;
			
			_pdf.setXY( col2, h + 18 ) ;
			_pdf.addMultiCell( 100, 4, MainModel.getInput( "_kpi_page_6" ) ) ; 
			
			drawLine( h + 28 ) ;
			
			_pdf.addText( "Define your critical level and what to", col1, h + 33 ) ;
			_pdf.addText( "do if your performance falls under this level.", col1, h + 37 ) ;
			
			_pdf.setXY( col2, h + 30 ) ;
			_pdf.addMultiCell( 150, 4, MainModel.getInput( "_kpi_page_7" ) ) ; 
			
			
			nextPage( ) ;
		}
		
		private static function addKPI2( ):void
		{
			_pdf.addPage( ) ;
			
			setProgramLine( ) ;
			
			var col1:Number = 15 ;
			var col2:Number = 90 ;
			
			// PAGE TITLE 
			
			_pdf.textStyle( new RGBColor ( 0xd6821c ), 1 ) ;
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 10 ) ;
			_pdf.addText( "KPI#4", 8, 80 ) ;
			
			// TEXT
			
			// ROW 1
			
			_pdf.textStyle( new RGBColor ( 0x666666 ), 1 ) ;
			
			var h:Number = 100 ;
			
			_pdf.addText( "What do you aim to achieve", col1, h - 4 ) ;
			
			_pdf.setXY( col2, h - 6.5 ) ;
			_pdf.addMultiCell( 100, 4, MainModel.getInput( "_kpi_page_8" ) ) ; 
			
			drawLine( h + 4 ) ;
			
			_pdf.addText( "How do you measure success.", col1, h + 9 ) ;
			_pdf.addText( "Be specific and use only numerical measures.", col1, h + 13 ) ;
			
			_pdf.setXY( col2, h + 5.5 ) ;
			_pdf.addMultiCell( 100, 4, MainModel.getInput( "_kpi_page_9" ) ) ; 
			
			drawLine( h + 16 ) ;

			_pdf.addText( "Define your success level and what to", col1, h + 21 ) ;
			_pdf.addText( "do after you have reached this level.", col1, h + 25 ) ;
			
			_pdf.setXY( col2, h + 18 ) ;
			_pdf.addMultiCell( 100, 4, MainModel.getInput( "_kpi_page_10" ) ) ; 
			
			drawLine( h + 28 ) ;
			
			_pdf.addText( "Define your critical level and what to", col1, h + 33 ) ;
			_pdf.addText( "do if your performance falls under this level.", col1, h + 37 ) ;
			
			_pdf.setXY( col2, h + 30 ) ;
			_pdf.addMultiCell( 150, 4, MainModel.getInput( "_kpi_page_11" ) ) ; 
			
			// ROW 2
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 10 ) ;
			_pdf.textStyle( new RGBColor ( 0xd6821c ), 1 ) ;
			
			h = 156 ;
			
			_pdf.addText( "KPI #5", 8, h ) ;
			
			_pdf.textStyle( new RGBColor ( 0x666666 ), 1 ) ;
			
			h = 166 ;
			
			_pdf.addText( "What do you aim to achieve", col1, h - 4 ) ;
			
			_pdf.setXY( col2, h - 6.5 ) ;
			_pdf.addMultiCell( 100, 4, MainModel.getInput( "_kpi_page_12" ) ) ; 
			
			drawLine( h + 4 ) ;
			
			_pdf.addText( "How do you measure success.", col1, h + 9 ) ;
			_pdf.addText( "Be specific and use only numerical measures.", col1, h + 13 ) ;
			
			_pdf.setXY( col2, h + 5.5 ) ;
			_pdf.addMultiCell( 100, 4, MainModel.getInput( "_kpi_page_13" ) ) ; 
			
			drawLine( h + 16 ) ;

			_pdf.addText( "Define your success level and what to", col1, h + 21 ) ;
			_pdf.addText( "do after you have reached this level.", col1, h + 25 ) ;
			
			_pdf.setXY( col2, h + 18 ) ;
			_pdf.addMultiCell( 100, 4, MainModel.getInput( "_kpi_page_14" ) ) ; 
			
			drawLine( h + 28 ) ;
			
			_pdf.addText( "Define your critical level and what to", col1, h + 33 ) ;
			_pdf.addText( "do if your performance falls under this level.", col1, h + 37 ) ;
			
			_pdf.setXY( col2, h + 30 ) ;
			_pdf.addMultiCell( 150, 4, MainModel.getInput( "_kpi_page_15" ) ) ; 
			
			nextPage( ) ;
		}

		private static function onPageImageLoadComplete( e:Event ):void
		{
			// set funnel texts
			
			_loader.removeEventListener( Event.COMPLETE, onPageImageLoadComplete ) ;
			_pdf.addImageStream( ByteArray( e.target.data ), 22, 98, 160, 152, 1, ResizeMode.NONE ) ;
			
			_pdf.setFont( FontFamily.ARIAL, Style.NORMAL, 10 ) ;
			_pdf.textStyle( new RGBColor ( 0x000000 ), 1 ) ;
			
			_pdf.setXY( 50, 115 );
			_pdf.addMultiCell( 120, 4, MainModel.getInput( "0_4_1" ) ) ;                      
			
			_pdf.textStyle( new RGBColor ( 0xffffff ), 1 ) ;
			
			_pdf.setXY( 60, 152 ) ;
			_pdf.addMultiCell( 102, 4, MainModel.getInput( "0_4_2" ) ) ;    
			
			_pdf.setXY( 68, 188 ) ;
			_pdf.addMultiCell( 86, 4, MainModel.getInput( "0_4_3" ) ) ; 
			
			_pdf.setXY( 78, 223 ) ;
			_pdf.addMultiCell( 65, 4, MainModel.getInput( "0_4_4" ) ) ; 
			
			nextPage( ) ;	
		}
	}
}