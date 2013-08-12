package com.nsn.channel.view.forms
{
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent ;
	import flash.utils.Timer ;
	
	import com.nsn.channel.view.GraphPoint ;
	import com.nsn.channel.interfaces.IForm ;
	import com.nsn.channel.view.MainView ;
	import com.nsn.channel.view.Styles ;
	
	import com.gskinner.motion.GTween ;
	
	/*
	 * An x/y graph that creates a new point with an editable text label on mouse click. 
	 */
	
	public class Graph extends Form implements IForm 
	{
		
		private var _graphHeight:Number				= 280 ;
		private var _graphWidth:Number				= 420 ;
		private var _bubble:MovieClip ;
		private var _graph:Sprite ;
		private var _points:Array ;
		private var _timer:Timer ;
		
		public function Graph( page_id:String, data:XML ) 
		{
			super( page_id, data ) ;
			setControls( ) ;
			setTimer( ) ;
		}
		
		// PRIVATE METHODS
		
		override protected function render( ):void
		{
			renderSkin( ) ;
		}
		
		override protected function renderSkin( ):void
		{
			_graph = new Sprite( ) ;
			
			// draw square
			_graph.graphics.beginFill( 0xffffff, .5 ) ;
			_graph.graphics.drawRect( 0, 0, _graphWidth, _graphHeight ) ;
			_graph.graphics.endFill( ) ;
			
			// draw lines
			_graph.graphics.lineStyle( 2, 0 ) ;
			_graph.graphics.moveTo( 0, 0 ) ;
			_graph.graphics.lineTo( 0, _graphHeight ) ;
			_graph.graphics.lineTo( _graphWidth, _graphHeight ); 
			
			_graph.graphics.lineStyle( 1, 0, .5 ) ;
			_graph.graphics.moveTo( _graphWidth / 2, 0 ) ;
			_graph.graphics.lineTo( _graphWidth / 2, _graphHeight ) ;
			_graph.graphics.moveTo( 0, _graphHeight / 2 ) ;
			_graph.graphics.lineTo( _graphWidth, _graphHeight / 2 ) ;
			
			_graph.buttonMode = _graph.useHandCursor = true ;
			
			addChild( _graph ) ;
		}
		
		override protected function setTooltip( ):void
		{
			if ( String( _data.info.text( ) ).length > 0 )
			{
				_infoButton = new InfoButton( ) ;
				_infoButton.buttonMode = _infoButton.useHandCursor = true ;
				_infoButton.x = _graph.x + _graph.width + 10 ;
				_infoButton.y = _graph.y + _graph.height - _infoButton.height * .5 ;
				_infoButton.addEventListener( MouseEvent.ROLL_OVER, showInfo ) ;
				_infoButton.addEventListener( MouseEvent.ROLL_OUT, showInfo ) ;
				addChild( _infoButton ) ;
			}
		}
		
		private function setControls( ):void
		{
			_graph.addEventListener( MouseEvent.CLICK, addPoint ) ;
		}
		
		private function setTimer( ):void
		{
			if ( !_timer ) _timer = new Timer( 2500, 2 ) ;
			_timer.addEventListener( TimerEvent.TIMER, showInfo ) ;
			_timer.start( ) ;
		}
		
		// EVENT HANDLERS
		
		private function addPoint( e:MouseEvent ):void
		{
			if ( mouseX > _graph.x + _graph.width ) return ;
			if ( mouseY > _graph.y + _graph.height ) return ;
			
			if ( !_points ) _points = new Array( ) ;
			
			var point:GraphPoint =  new GraphPoint( ) ;
			_points.push( point ) ;
			point.x = mouseX ;
			point.y = mouseY ;
			point.buttonMode = point.useHandCursor = true ;
			point.addEventListener( "remove", removePoint ) ;
			_graph.addChild( point ) ;
			
			finalize( point ) ;
		}
		
		private function removePoint( e:Event ):void
		{
			_graph.removeChild( e.currentTarget as DisplayObject ) ;
		}
		
		/*
		 * Change all other text input fields into fixed text labels.
		 */
		
		public function finalize( exception:GraphPoint = null ):void
		{
			for ( var i in _points )
			{
				if ( _points[i] != exception ) _points[i].finalize( ) ;
			}
		}
		
		override public function showInfo( e:Event = null ):void
		{
			var tween:GTween ;
			
			if ( !_bubble )
			{
				_bubble = new InfoBox( ) ;
				_bubble.tf.styleSheet = Styles.getStyleSheet( ) ;
				_bubble.tf.condenseWhite = true ;
				_bubble.tf.htmlText = _data.info.text( ) ;
				_bubble.tf.height = _bubble.tf.textHeight + 35 ;
				_bubble.close_btn.visible = false ;
				_bubble.bg.width = 180 ;
				_bubble.tf.width = 160 ;
				_bubble.bg.height = _bubble.tf.textHeight + 20 ;
				_bubble.x = _graph.x + _graph.width - _bubble.bg.width - 5 ;
				_bubble.y = 10 ;
				_bubble.alpha = 0 ;
				addChild( _bubble ) ;
				
				tween = new GTween( _bubble, .3, { alpha: 1 } ) ;
			}
			
			else 
			{
				if ( e.type != MouseEvent.ROLL_OVER )
				{
					tween = new GTween( _bubble, .3, { alpha: 0 } ) ;
					tween.addEventListener( Event.COMPLETE, completeHandler ) ;
				}
			}
			
			function completeHandler( e:Event ):void
			{
				tween.removeEventListener( Event.COMPLETE, completeHandler ) ;
				
				if ( _bubble )
				{
					if ( contains( _bubble ) ) removeChild( _bubble ) ;
					_bubble = null ;
				}
				
			}
		}

	}
	
}