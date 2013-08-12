package com.nsn.channel.view 
{
	
	import flash.events.Event ;
	import flash.events.MouseEvent ; 
	import flash.events.EventDispatcher ;
	import flash.events.IOErrorEvent ;
	import flash.events.SecurityErrorEvent ;
	import flash.net.URLRequest ;
	import flash.net.URLRequestMethod ;
	import flash.net.URLLoader ;
	import flash.net.URLVariables ;
	
	import com.nsn.channel.model.MainModel ;
	import com.nsn.channel.control.MainController ;
	import com.nsn.channel.events.ApplicationEvent ;
	
	public class Testimonial extends EventDispatcher
	{
		
		private static var _msg:String ;
		private static var _instance:Testimonial ;
		
		public function Testimonial( ) 
		{
		}
		
		// PUBLIC METHODS
		
		public static function getInstance( ):Testimonial
		{
			if ( !_instance ) _instance = new Testimonial( ) ;
			return _instance ;
		}
		
		public static function create( ):void
		{
			var data:XML = MainModel.getRecipients( ) ;
			
			for ( var i in data.recipient ) 
			{
				submitMessage( String( data.recipient[i].@address ) ) ;
				trace( "sending to", String( data.recipient[i].@address ) ) ;
			}
		}
		
		// PRIVATE METHODS
		
		public static function composeMessage( ):String
		{
			var data:XML = MainModel.getPage( "1", "0" ) ;
			var msg:String = "" ;
			
			for ( var i in data.item )
			{
				var id:String = "1_0_" + data.item[i].@id ;
				var label:String = MainModel.getLabel( id ) ;
				msg += label + ": " + MainModel.getInput( id ) + "\n\n" ;
			}
			
			return msg ;
		}
		
		private static function submitMessage( recipient:String ):void 
		{
            var variables:URLVariables = new URLVariables( ) ;

            variables.senderName = "NSN Channel Partner Program" ;
            variables.replyAddress = "" ;
            variables.subject = "NSN Channel Partner Program - Success story" ;
			variables.recipient = recipient ;
            variables.messageBody = composeMessage( ) ;

            var scriptRequest:URLRequest = new URLRequest( "data/php/send.php" ) ;
            scriptRequest.data = variables ;

            var scriptLoader:URLLoader = new URLLoader( ) ;
            scriptLoader.addEventListener( Event.COMPLETE, messageSent ) ;
            scriptLoader.addEventListener( IOErrorEvent.IO_ERROR, sendError ) ;
            scriptLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, sendError ) ;

            scriptRequest.method = URLRequestMethod.GET ;
            scriptLoader.load( scriptRequest ) ;
		}

		private static function messageSent( e:Event ):void 
		{
            trace( "Message sent" ) ;
			//PageViewHandler.getInstance( ).close( ) ;
			MainView.getInstance( ).showAlert( "success_story_sent" ) ;
        }
		
		private static function sendError( e:Event):void 
		{
            trace( "Send failed" ) ;
			MainView.getInstance( ).showAlert( "success_story_sent" ) ;
			//PageViewHandler.getInstance( ).close( ) ;
        }
		
	}
	
}