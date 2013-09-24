/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.tools
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	
	/****
	 * MouseManager.as class. Created Sep 22, 2013 5:45:59 PM
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/   	 
	public class MouseManager
	{		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		public static var container:Sprite;
		private static var _mouseState:MouseStyle;
		private static var mouseLostHandler:Vector.<Function> = new Vector.<Function>;
		private static var mouseDownHandler:Vector.<Function> = new Vector.<Function>;
		private static var mouseUpHandler:Vector.<Function> = new Vector.<Function>;
		private static var mouseMoveHandler:Vector.<Function> = new Vector.<Function>;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function MouseManager()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		
		public static function setStage(_rootContainer:Sprite) : void
		{
			MouseManager.container = _rootContainer;
			_rootContainer.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_rootContainer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_rootContainer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_rootContainer.addEventListener(MouseEvent.ROLL_OUT, onLostMouse);
			_rootContainer.addEventListener(Event.DEACTIVATE, onLostMouse);
			mouseState = MouseStyle.NORMAL;
		}
		
		public static function set mouseState(_style:MouseStyle) : void
		{
			if (_style == null)
			{
				_style = MouseStyle.NORMAL;
			}
			if (_mouseState == _style)
			{
				return;
			}
			_mouseState = _style;
			Mouse.cursor = mouseState.value;
		}
		
		public static function get mouseState() : MouseStyle
		{
			return _mouseState;
		}
		
		public static function onMouseDown(event:MouseEvent) : void
		{
			var count:int = 0;
			var downHandleNum:uint = mouseDownHandler.length;
			while (count < downHandleNum)
			{
				var downHandle:Function = mouseDownHandler[count];
				if (!downHandle.call(null))
				{
					break;
				}
				count++;
			}
		}
		
		public static function onMouseUp(event:MouseEvent) : void
		{
			var count:int = 0;
			var upHandleNum:uint = mouseUpHandler.length;
			while (count < upHandleNum)
			{
				var upHandle:Function = mouseUpHandler[count];
				if (!upHandle.call(null))
				{
					break;
				}
				count++;
			}
		}
		
		public static function onMouseMove(event:MouseEvent) : void
		{
			var count:int = 0;
			var moveHandleNum:uint = mouseMoveHandler.length;
			while (count < moveHandleNum)
			{
				var moveHandle:Function = mouseMoveHandler[count];
				if (!moveHandle.call(null))
				{
					break;
				}
				count++;
			}
		}
		
		public static function onLostMouse(event:Event) : void
		{
			var count:int = 0;
			var lostHandleNum:uint = mouseLostHandler.length;
			while (count < lostHandleNum)
			{
				var lostHandle:Function = mouseLostHandler[count];
				if (!lostHandle.call(null))
				{
					break;
				}
				count++;
			}
		}
		
		public static function addMouseLostHandler(handle:Function) : void
		{
			if (mouseLostHandler.indexOf(handle) < 0)
			{
				mouseLostHandler.push(handle);
			}
		}
		
		public static function removeMouseLostHandler(handle:Function) : void
		{
			var index:int = mouseLostHandler.indexOf(handle);
			if (index >= 0)
			{
				mouseLostHandler.splice(index, 1);
			}
		}
		
		public static function getX() : int
		{
			return container.mouseX;
		}
		
		public static function getY() : int
		{
			return container.mouseY;
		}
		
		public static function addMouseDownHandler(handle:Function) : void
		{
			if (mouseDownHandler.indexOf(handle) < 0)
			{
				mouseDownHandler.push(handle);
			}
		}
		
		public static function removeMouseDownHandler(handle:Function) : void
		{
			var index:int = mouseDownHandler.indexOf(handle);
			if (index >= 0)
			{
				mouseDownHandler.splice(index, 1);
			}
		}
		
		public static function addMouseUpHandler(handle:Function) : void
		{
			if (mouseUpHandler.indexOf(handle) < 0)
			{
				mouseUpHandler.push(handle);
			}
		}
		
		public static function removeMouseUpHandler(handle:Function) : void
		{
			var index:int = mouseUpHandler.indexOf(handle);
			if (index >= 0)
			{
				mouseUpHandler.splice(index, 1);
			}
		}
		
		public static function addMouseMoveHandler(handle:Function) : void
		{
			if (mouseMoveHandler.indexOf(handle) < 0)
			{
				mouseMoveHandler.push(handle);
			}
		}
		
		public static function removeMouseMoveHandler(handle:Function) : void
		{
			var index:int = mouseMoveHandler.indexOf(handle);
			if (index >= 0)
			{
				mouseMoveHandler.splice(index, 1);
			}
		}
		
	}
	
}