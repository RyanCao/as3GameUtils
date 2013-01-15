/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.tools.time
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.rcSpark.tools.data.DataUtil;

	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	
	/****
	 * EnterFrameHandle.as class. Created Aug 21, 2012 11:36:38 PM
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/   	 
	public final class EnterFrameHandle
	{		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private static var __instance:EnterFrameHandle ;
		
		private var _dispatch:Shape ;
		private var _frame:uint = 0 ;
		private var _funDic:Dictionary;
		private var _argsDic:Dictionary;
		private var _running:Boolean = false;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function EnterFrameHandle()
		{
			_dispatch = new Shape();
			_funDic = new Dictionary(true);
			_argsDic = new Dictionary(true);
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		public static function instance():EnterFrameHandle{
			if(!__instance)
				__instance = new EnterFrameHandle();
			return __instance ;
		}
		
		/**
		 * 
		 * 指定函数在某一帧运行 
		 * @param fun 函数
		 * @param args 函数参数
		 * @param frame 帧数
		 * 
		 */
		public function runOnFrame(fun:Function,args:*,frame:uint): void
		{
			if(fun==null||_frame>=frame){
				return ;
			}
			if(!_funDic)
				_funDic = new Dictionary(true);
			if(!_argsDic)
				_argsDic = new Dictionary(true);
			
			var funArr:Array = _funDic[frame] ;
			if(!funArr)
				funArr = [];
			
			var argsArr:Array = _argsDic[frame] ;
			if(!argsArr)
				argsArr = [];
			
			if(funArr.indexOf(fun)<0){
				funArr.push(fun);
				argsArr.push(args);
			}
			_funDic[frame] = funArr ;
			_argsDic[frame] = argsArr ;
			
			if(!running())
				start();
		}
		
		private function start():void
		{
			_running = true ;
			if(!_dispatch.hasEventListener(Event.ENTER_FRAME))
				_dispatch.addEventListener(Event.ENTER_FRAME , onEnterFrameHandle);
		}
		protected function onEnterFrameHandle(event:Event):void
		{
			_frame ++ ;
			var funArr:Array = _funDic[_frame];
			var argsArr:Array = _argsDic[_frame] ;
			if(!funArr)
			{
				delete _funDic[_frame];
				delete _argsDic[_frame];
				return ;
			}
			while(funArr.length>0)
			{
				var fun:Function = funArr.pop();
				var args:* = argsArr.pop();
				fun(args);
			}
			delete _funDic[_frame];
			delete _argsDic[_frame];
			if(DataUtil.isEmpty(_funDic))
			{
				stop();
			}
		}
		private function stop():void
		{
			_frame = 0 ;
			if(_dispatch.hasEventListener(Event.ENTER_FRAME))
				_dispatch.removeEventListener(Event.ENTER_FRAME , onEnterFrameHandle);
			_running = false ;
		}
		public function getCurrFrame():uint{
			return _frame ;
		}
		public function running():Boolean{
			return _running ;
		}
		
	}
	
}