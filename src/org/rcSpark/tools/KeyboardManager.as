/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.tools
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	
	/****
	 * KeyboardManager.as class. Created Sep 22, 2013 4:11:41 PM
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/   	 
	public class KeyboardManager
	{		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		public static var stage:Stage;
		private static var _isTextFieldFocus:Boolean;
		private static var _keyDownList:Vector.<Boolean> = new Vector.<Boolean>(400, true);
		private static var keyDownHandler:Vector.<Function> = new Vector.<Function>;
		private static var keyUpHandler:Vector.<Function> = new Vector.<Function>;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function KeyboardManager()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		/**
		 * 初始化键盘管理器 
		 * @param _rootStage
		 * 
		 */
		public static function setStage(_rootStage:Stage) : void
		{
			KeyboardManager.stage = _rootStage;
			_rootStage.addEventListener(FocusEvent.FOCUS_IN, onFocusChange);
			_rootStage.addEventListener(FocusEvent.FOCUS_OUT, onFocusChange);
			_rootStage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, onFocusChange);
			_rootStage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, onFocusChange);
			_rootStage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_rootStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_rootStage.addEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
			_rootStage.addEventListener(Event.DEACTIVATE, onMouseLeave);
		}
		
		private static function onFocusChange(event:Event) : void
		{
			_isTextFieldFocus = stage.focus is TextField;
			if (_isTextFieldFocus)
			{
				_keyDownList = new Vector.<Boolean>(400, true);
			}
		}
		
		private static function onMouseLeave(event:Event) : void
		{
			_keyDownList = new Vector.<Boolean>(400, true);
		}
		
		public static function onKeyDown(event:KeyboardEvent) : void
		{
			var count:int = 0;
			var downHandle:Function = null;
			
			if (_isTextFieldFocus)
			{
				return;
			}
			_keyDownList[event.keyCode] = true;
			var allDownNum:uint = keyDownHandler.length;
			while (count < allDownNum)
			{
				downHandle = keyDownHandler[count];
				if (!downHandle.call(null, event.keyCode))
				{
					break;
				}
				count++;
			}
		}
		
		public static function onKeyUp(event:KeyboardEvent) : void
		{
			var count:int = 0;
			var handle:Function = null;
			if (_isTextFieldFocus)
			{
				return;
			}
			_keyDownList[event.keyCode] = false;
			var allHandles:uint = keyUpHandler.length;
			while (count < allHandles)
			{
				handle = keyUpHandler[count];
				if (!handle.call(null, event.keyCode))
				{
					break;
				}
				count++;
			}
		}
		
		public static function keyIsDown(key:int) : Boolean
		{
			if (_isTextFieldFocus)
			{
				return false;
			}
			return _keyDownList[key];
		}
		
		public static function addKeyDownHandler(handle:Function) : void
		{
			if (keyDownHandler.indexOf(handle) < 0)
			{
				keyDownHandler.push(handle);
			}
		}
		
		public static function removeKeyDownHandler(handle:Function) : void
		{
			var index:int = keyDownHandler.indexOf(handle);
			if (index >= 0)
			{
				keyDownHandler.splice(index, 1);
			}
		}
		
		public static function addKeyUpHandler(handle:Function) : void
		{
			if (keyUpHandler.indexOf(handle) < 0)
			{
				keyUpHandler.push(handle);
			}
		}
		
		public static function removeKeyUpHandler(handle:Function) : void
		{
			var index:int = keyUpHandler.indexOf(handle);
			if (index >= 0)
			{
				keyUpHandler.splice(index, 1);
			}
		}
	}
	
}