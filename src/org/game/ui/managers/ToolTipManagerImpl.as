/*******************************************************************************
 * Class name:	ToolTipManagerImpl.as
 * Description:	
 * Author:		ryancao
 * Create:		Mar 27, 2013 5:46:16 PM
 * Update:		Mar 27, 2013 5:46:16 PM
 ******************************************************************************/
package org.game.ui.managers
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	import org.game.gameant;
	import org.game.ui.core.IToolTip;
	import org.game.ui.core.IUIInterfaces;
	
	use namespace gameant ;
	public class ToolTipManagerImpl implements IToolTipManager
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		private var _currentTarget:DisplayObject;
		private var currentToolTipData:IToolTipData;
		private var previousTarget:DisplayObject;
		private var _currentToolTipData:IToolTipData;
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function ToolTipManagerImpl()
		{
		}
		
		public function get currentTarget():DisplayObject
		{
			return _currentTarget;
		}
		
		public function set currentTarget(value:DisplayObject):void
		{
			_currentTarget = value ;
		}
		
		public function get currentToolTip():IToolTip
		{
			return null;
		}
		
		public function set currentToolTip(value:IToolTip):void
		{
		}
		
		public function get enabled():Boolean
		{
			return false;
		}
		
		public function set enabled(value:Boolean):void
		{
		}
		
		public function get hideDelay():Number
		{
			return 0;
		}
		
		public function set hideDelay(value:Number):void
		{
		}
		
		public function get scrubDelay():Number
		{
			return 0;
		}
		
		public function set scrubDelay(value:Number):void
		{
		}
		
		public function get showDelay():Number
		{
			return 0;
		}
		
		public function set showDelay(value:Number):void
		{
		}
		
		public function get toolTipClass():Class
		{
			return null;
		}
		
		public function set toolTipClass(value:Class):void
		{
		}
		
		public function registerToolTip(target:DisplayObject, oldToolTip:IToolTipData, newToolTip:IToolTipData):void
		{
			if (!oldToolTip && newToolTip)
			{
				target.addEventListener(MouseEvent.MOUSE_OVER,
					toolTipMouseOverHandler);
				target.addEventListener(MouseEvent.MOUSE_OUT,
					toolTipMouseOutHandler);
				
				if (mouseIsOver(target))
					showImmediately(target);
			}
			else if (oldToolTip && !newToolTip)
			{
				target.removeEventListener(MouseEvent.MOUSE_OVER,
					toolTipMouseOverHandler);
				target.removeEventListener(MouseEvent.MOUSE_OUT,
					toolTipMouseOutHandler);
				
				if (mouseIsOver(target))
					hideImmediately(target);
			}
			else
			{
				
			}
		}
		
		private function toolTipMouseOverHandler(event:MouseEvent):void
		{
			checkIfTargetChanged(DisplayObject(event.target));
		}
		
		private function toolTipMouseOutHandler(event:MouseEvent):void
		{
			checkIfTargetChanged(event.relatedObject);
		}
		/**
		 * 检查当前目标是否发生了改变 
		 * @param displayObject
		 * 
		 */	
		gameant function checkIfTargetChanged(displayObject:DisplayObject):void
		{
			if (!enabled)
				return;
			
			findTarget(displayObject);
			
			if (currentTarget != previousTarget)
			{
				targetChanged();
				previousTarget = currentTarget;
			}
		}
		
		private function findTarget(displayObject:DisplayObject):void
		{
//			while (displayObject)
//			{
//				if (displayObject is IToolTipManagerClient)
//				{
//					currentToolTipData = IToolTipManagerClient(displayObject).toolTip;
//					if (currentToolTipData != null)
//					{
//						_currentTarget = displayObject;
//						return;
//					}
//				}
//				else if(displayObject is InteractiveObject)
//				{
//					if(InteractiveObject(displayObject).hasEventListener(ToolTipEvent.TOOL_TIP_START))
//					{
//						_currentTarget = displayObject;
//						return;
//					}
//				}
//				
//				displayObject = displayObject.parent;
//			}
//			
//			_currentToolTipData = null;
//			_currentTarget = null;
		}
		
		/**
		 * 目标改变后执行 
		 * 
		 */	
		private function targetChanged():void
		{
//			if (!initialized)
//				initialize()
//			
//			var event:ToolTipEvent;
//			
//			if (previousTarget && currentToolTip)
//			{
//				if (currentToolTip is IToolTip)
//				{
//					event = new ToolTipEvent(ToolTipEvent.TOOL_TIP_HIDE);
//					event.toolTip = currentToolTip;
//					previousTarget.dispatchEvent(event);
//				}
//				else
//				{
//					if (hasEventListener(ToolTipEvent.TOOL_TIP_HIDE))
//						dispatchEvent(new Event(ToolTipEvent.TOOL_TIP_HIDE));
//				}
//			}   
//			
//			reset();
//			
//			if (currentTarget)
//			{
//				
//				
//				// Dispatch a "startToolTip" event
//				// from the object displaying the tooltip.
//				event = new ToolTipEvent(ToolTipEvent.TOOL_TIP_START);
//				currentTarget.dispatchEvent(event);
//				
//				if (!currentToolTipData)
//					return;
//				
//				if (showDelay == 0 || scrubTimer.running)
//				{
//					// Create the tooltip and start its showEffect.
//					createTip();
//					//initializeTip();
//					positionTip();
//					showTip();
//				}
//				else
//				{
//					showTimer.delay = showDelay;
//					showTimer.start();
//					// After the delay, showTimer_timerHandler()
//					// will create the tooltip and start its showEffect.
//				}
//			}
		}
		/**
		 *  @private
		 *  立即显示toolTip
		 */
		private function showImmediately(target:DisplayObject):void
		{
//			var oldShowDelay:Number = ToolTipManager.showDelay;
//			ToolTipManager.showDelay = 0;
//			checkIfTargetChanged(target);
//			ToolTipManager.showDelay = oldShowDelay;
		}
		
		/**
		 *  @private
		 */
		private function hideImmediately(target:DisplayObject):void
		{
			checkIfTargetChanged(null);
		}
		/**
		 * 检测当前鼠标是否放置在对象上. 
		 * @param target
		 * @return 
		 * 
		 */	
		private function mouseIsOver(target:DisplayObject):Boolean
		{
			if (!target || !target.stage)
				return false;
			
			if ((target.stage.mouseX == 0)	 && (target.stage.mouseY == 0))
				return false;
			
			return target.hitTestPoint(target.stage.mouseX,
				target.stage.mouseY, true);
		}
		
		public function registerErrorString(target:DisplayObject, oldErrorString:IToolTipData, newErrorString:IToolTipData):void
		{
		}
		
		public function sizeTip(toolTip:IToolTip):void
		{
//			toolTip.setSize(
//				toolTip.getExplicitOrMeasuredWidth(),
//				toolTip.getExplicitOrMeasuredHeight());
		}
		
		public function createToolTip(data:IToolTipData, errorTipBorderStyle:String=null, context:IUIInterfaces=null):IToolTip
		{
			return null;
		}
		
		public function destroyToolTip(toolTip:IToolTip):void
		{
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		
	}
}