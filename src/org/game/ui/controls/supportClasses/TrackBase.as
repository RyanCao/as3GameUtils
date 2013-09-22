package org.game.ui.controls.supportClasses
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.game.gameant;
	import org.game.ui.controls.Button;
	import org.game.ui.controls.skinClasses.RectSprite;
	import org.game.ui.core.BaseUI;
	import org.game.ui.events.ScrollEvent;
	import org.game.ui.events.TrackEvent;
	
	
	use namespace gameant;
	
	/**
	 * 当用户执行操作导致value发生改变时触发; 
	 */	
	[Event(name="change", type="org.game.ui.events.TrackEvent")]
	
	/**
	 * 当value值被修改时触发;
	 */
	[Event(name="valueChanged", type="org.game.ui.events.TrackEvent")]
	/**
	 * 轨道组建基类
	 * @author zhangyu 2012-10-23
	 *
	 **/
	public class TrackBase extends BaseUI
	{
		//--------------------------------------------------------------------------
		//		Constructor
		//--------------------------------------------------------------------------
		public function TrackBase()
		{
			super();
		}
		//--------------------------------------------------------------------------
		//		Variables
		//--------------------------------------------------------------------------
		protected var track:DisplayObject;
		
		protected var thumb:Button;
		
		protected var isThumbDown:Boolean = false;
		
		protected var thumbDownPoint:Point;
		//--------------------------------------------------------------------------
		//		Propertise
		//--------------------------------------------------------------------------
		//------------------------------
		//		scrollPosition
		//------------------------------
		protected var _value:Number = 0;
		
		public function get value():Number
		{
			return _value;
		}
		
		public function set value(value:Number):void
		{
			if(isNaN(value))
			{
				throw new Error("track value is NaN");
			}
			
			if(_value == value)
			{
				return;
			}
			var oldValue:Number = _value;
			_value = validateValue(value);
			
			dispatchEvent(new TrackEvent(TrackEvent.VALUE_CHANGED, oldValue, value));
			
			invalidateDisplayList();
		}
		
		public function setValue(value:Number):void
		{
			if(isNaN(value))
			{
				throw new Error("track value is NaN");
			}
			var oldValue:Number = _value;
			_value = validateValue(value);
			
			dispatchEvent(new TrackEvent(TrackEvent.VALUE_CHANGED, oldValue, value));
			
			invalidateDisplayList();
		}
		//------------------------------
		//		maxScrollPosition
		//------------------------------
		protected var _maxValue:Number = 1;
		
		public function set maxValue(value:Number):void
		{
			_maxValue = value;
			
			if(this.value > value)
				this.value = value;
		}
		
		public function get maxValue():Number
		{
			return _maxValue;
		}
		
		//------------------------------
		//		minScrollPosition
		//------------------------------
		protected var _minValue:Number = 0;
		
		public function set minValue(value:Number):void
		{
			_minValue = value;
			
			if(this.value < value)
				this.value = value;
		}
		
		public function get minValue():Number
		{
			return _minValue;
		}
		
		//------------------------------
		//		thumOffsetX
		//------------------------------
		private var _thumOffsetX:Number = 0;
		
		public function get thumOffsetX():Number
		{
			return _thumOffsetX;
		}
		
		public function set thumOffsetX(value:Number):void
		{
			_thumOffsetX = value;
		}
		
		//------------------------------
		//		thumOffsetY
		//------------------------------
		private var _thumOffsetY:Number = 0;
		
		public function get thumOffsetY():Number
		{
			return _thumOffsetY;
		}
		
		public function set thumOffsetY(value:Number):void
		{
			_thumOffsetY = value;
		}
		
		
		//--------------------------------------------------------------------------
		//		Method
		//--------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			if(!track)
			{
				track = deferredSetStyles.getSkinInstance("trackSkin");
				
				if(track)
				{
					if(track is DisplayObjectContainer)
						DisplayObjectContainer(track).mouseChildren = false;
					
					track.addEventListener(MouseEvent.MOUSE_DOWN, trackMouseDownHandler);
					addChild(track);
				}else{
					track = new RectSprite(0x00ff00);
					track.addEventListener(MouseEvent.MOUSE_DOWN, trackMouseDownHandler);
					addChild(track);
				}
			}
			
			if(!thumb)
			{
				thumb = new Button();
				thumb.styleName = deferredSetStyles.getStyle("thumb")
				thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbMouseDownHandler);
				thumb.addEventListener(MouseEvent.MOUSE_UP, thumbMouseUpHandler);
				addChild(thumb);
			}
		}
		
		override protected function measure():void
		{
			this.measuredWidth = track.width;
			this.measuredHeight = track.height;
		}
		
		override protected function updateDisplayList(unscaleWidth:Number, unscaleHeight:Number):void
		{
			super.updateDisplayList(unscaleWidth, unscaleHeight);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			track.removeEventListener(MouseEvent.MOUSE_DOWN, trackMouseDownHandler);
			
			thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumbMouseDownHandler);
			thumb.removeEventListener(MouseEvent.MOUSE_UP, thumbMouseUpHandler);
			
			var sm:InteractiveObject = InteractiveObject(this.systemManager);
			sm.removeEventListener(MouseEvent.MOUSE_MOVE, smMouseMoveHandler);
			sm.removeEventListener(MouseEvent.MOUSE_UP, smMouseUpHandler);
			sm.removeEventListener(MouseEvent.ROLL_OUT, smMouseOutHandler);
		}
		
		//--------------------------------------------------------------------------
		//		Event Handler
		//--------------------------------------------------------------------------
		protected function trackMouseDownHandler(event:MouseEvent):void
		{
			
		}
		
		private function thumbMouseDownHandler(event:MouseEvent):void
		{
			isThumbDown = true;
			
			thumbDownPoint = thumb.globalToLocal(new Point(event.stageX, event.stageY));
			
			var sm:InteractiveObject = InteractiveObject(this.systemManager);
			sm.addEventListener(MouseEvent.MOUSE_MOVE, smMouseMoveHandler);
			sm.addEventListener(MouseEvent.MOUSE_UP, smMouseUpHandler);
			sm.addEventListener(MouseEvent.ROLL_OUT, smMouseOutHandler);
		}
		
		private function thumbMouseUpHandler(event:MouseEvent):void
		{
			isThumbDown = false;
		}
		
		
		private function smMouseMoveHandler(event:MouseEvent):void
		{
			if(isThumbDown)
			{
				//计算鼠标移动当前所在的值，需要减去指针相对与滑块的偏移量;
				var pt:Point = this.globalToLocal(new Point(event.stageX, event.stageY));
				var newValue:Number = pointToValue(pt.x - thumbDownPoint.x, pt.y - thumbDownPoint.y);
				
				var oldValue:Number = this.value;
				this.value = newValue;
				
				dispatchEvent(new TrackEvent(TrackEvent.CHANGE, oldValue, this.value));
			}
		}
		
		private function smMouseUpHandler(event:MouseEvent):void
		{
			isThumbDown = false;
			
			var sm:InteractiveObject = InteractiveObject(this.systemManager);
			sm.removeEventListener(MouseEvent.MOUSE_MOVE, smMouseMoveHandler);
			sm.removeEventListener(MouseEvent.MOUSE_UP, smMouseUpHandler);
			sm.removeEventListener(MouseEvent.ROLL_OUT, smMouseOutHandler);
		}
		
		private function smMouseOutHandler(event:MouseEvent):void
		{
			isThumbDown = false;
			
			var sm:InteractiveObject =  InteractiveObject(this.systemManager);
			sm.removeEventListener(MouseEvent.MOUSE_MOVE, smMouseMoveHandler);
			sm.removeEventListener(MouseEvent.MOUSE_UP, smMouseUpHandler);
			sm.removeEventListener(MouseEvent.ROLL_OUT, smMouseOutHandler);
		}
		//--------------------------------------------------------------------------
		//		Private
		//--------------------------------------------------------------------------
		gameant function dispatchScrollEvent(oldPosition:Number,
											 detail:String):void
		{
			var event:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
			event.detail = detail;
			event.position = value;
			event.delta = value - oldPosition;
			
			dispatchEvent(event);
		}
		
		/**
		 * 将相对于Track的坐标点转换为 scrollPosition值
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */	
		protected function pointToValue(x:Number, y:Number):Number
		{
			return 0;
		}
		
		protected function updateThumbPosition():void
		{
			
		}
		
		protected function validateValue(value:Number):Number
		{
			value = Math.min(value, maxValue);
			value = Math.max(value, minValue);
			
			return value;
		}
	}
}