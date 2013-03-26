/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.tools.core
{
	import flash.utils.Dictionary;
	
	import org.rcSpark.tools.data.DataUtil;

	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	
	/****
	 * CallLater.as class. Created Aug 18, 2012 12:22:25 AM
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/   	 
	public final class CallLater
	{		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private static var globeDirty:Dictionary = new Dictionary();
		private static var objectDirty:Dictionary = new Dictionary();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function CallLater()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		private static function waitToCallLater(handler:Function,para:Array,uniqueOn:*):void
		{
			var dirty:Dictionary = uniqueOn ? objectDirty[uniqueOn] : globeDirty;
			if (dirty && dirty[handler])
			{
				handler.apply(null,para);
				delete dirty[handler];
				
				//如果对象的Dirty已清空，则删除对象字典
				if (uniqueOn && DataUtil.isEmpty(dirty))
					delete objectDirty[uniqueOn];
			}
		}
		
		private static function setDirty(handler:Function,uniqueOn:*):void
		{
			var dirty:Dictionary;
			if (uniqueOn)
			{
				if (!objectDirty[uniqueOn])
					objectDirty[uniqueOn] = new Dictionary();
				dirty = objectDirty[uniqueOn];
			}
			else
				dirty = globeDirty;
			
			dirty[handler] = true;
		}
		
		/**
		 * 延迟调用
		 * 
		 * @param handler	函数
		 * @param para	函数参数
		 * @param unique	是否限定函数只执行一次，
		 * 不同参数的函数被认为是一个函数，不同对象的同名方法被认为是不同的方法
		 * 
		 * @param uniqueOn	除了函数本身，附加的判断是否重复调用的依据
		 * 
		 */
		public static function callLater(handler:Function,para:Array = null,unique:Boolean = false,uniqueOn:*=null):void
		{
			if (unique)
			{
				setDirty(handler,uniqueOn);
				CallLaterQueue.instance().callLaterByTime(waitToCallLater,[handler,para,uniqueOn]);
			}
			else
			{
				CallLaterQueue.instance().callLaterByTime(handler);
			}
		}
		
		/**
		 * 在下一帧延迟调用（这个方法依赖于Tick，Tick暂停时将不会执行）
		 * 
		 * @param handler	函数
		 * @param para	函数参数
		 * @param unique	是否限定函数只执行一次，
		 * 不同参数的函数被认为是一个函数，不同对象的同名方法被认为是不同的方法
		 * 
		 * @param uniqueOn	除了函数本身，附加的判断是否重复调用的依据
		 * 
		 */
		public static function callLaterNextFrame(handler:Function,para:Array = null,unique:Boolean = false,uniqueOn:*=null):void
		{
			if (unique)
			{
				setDirty(handler,uniqueOn);
				CallLaterQueue.instance().callLaterByTick(waitToCallLater,[handler,para,uniqueOn]);
			}
			else
			{
				CallLaterQueue.instance().callLaterByTick(handler);
			}
		}
	}
	
}