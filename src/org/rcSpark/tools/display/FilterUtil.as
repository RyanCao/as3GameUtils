/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.tools.display
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	
	import org.rcSpark.tools.core.CallLater;

	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	
	/****
	 * FilterUtil.as class. Created Aug 18, 2012 12:03:56 AM
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/   	 
	public final class FilterUtil
	{		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function FilterUtil()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 增加一个滤镜，同类滤镜将会覆盖
		 * 
		 * @param displayObj	显示对象
		 * @param filter	滤镜对象
		 * 
		 */        
		public static function applyFilter(displayObj:DisplayObject,filter:BitmapFilter):void
		{
			var filters:Array=displayObj.filters;
			var dirty:Boolean = false;
			var filterType:Class = filter["constructor"] as Class;
			if (filters)
			{
				var len:int = filters.length;
				for (var i:int=0;i < len;i++)
				{
					if (filters[i] is filterType)
					{
						filters[i] = filter;
						dirty = true;
						break;
					}
				}
				if(!dirty)
				{
					filters.push(filter);
				}
			}
			displayObj.filters = filters;
		}
		
		/**
		 * 取消所有特定内容的滤镜
		 * 
		 * @param displayObj	显示对象
		 * @param filterType	滤镜类型
		 * 
		 */        
		public static function removeFilter(displayObj:DisplayObject,filterType:Class):void
		{
			var filters:Array=displayObj.filters;
			var dirty:Boolean = false;
			if (filters)
			{
				var len:int = filters.length;
				for (var i:int=0;i < len;i++)
				{
					if (filters[i] is filterType)
					{
						filters.splice(i,1);
						dirty = true;
					}
				}
				
				if (dirty)
					displayObj.filters = filters;
			}
		}
		
		/**
		 * 更新滤镜
		 * 
		 * @param displayObj
		 * @param immedie	是否立即执行
		 * 
		 */
		public static function refreshFilter(displayObj:DisplayObject,immedie:Boolean = true):void
		{
			if (immedie)
				refreshFilterImmediy(displayObj);
			else
				CallLater.callLater(refreshFilterImmediy,[displayObj],true,displayObj);
		}
		
		private static function refreshFilterImmediy(displayObj:DisplayObject):void
		{
			displayObj.filters = displayObj.filters;
		}
	}
	
}