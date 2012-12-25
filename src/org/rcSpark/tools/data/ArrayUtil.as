/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.tools.data
{
	import flash.utils.Dictionary;
	
	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	
	/****
	 * ArrayUtil.as class. 
	 * 
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * Created Aug 16, 2012 10:45:57 PM
	 * Description: 数组处理
	 ****/   	 
	public final class ArrayUtil
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
		public function ArrayUtil()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 将一个数组附加在另一个数组之后
		 * 
		 * @param target	目标数组
		 * @param add		附加的数组
		 */
		public static function append(target:Array,add:Array):void
		{
			target.push.apply(null,add);
		}
		
		/**
		 * 获得两个数组的共用元素
		 * 
		 * @param array1	数组对象1
		 * @param array2	数组对象2
		 * @param result	共有元素
		 * @param array1only	数组1独有元素
		 * @param array2only	数组2独有元素
		 * @return 	共有元素
		 * 
		 */
		public static function hasShare(array1:Array,array2:Array,result:Array = null,array1only:Array = null,array2only:Array = null):Array
		{
			if (result == null)
				result = [];
			
			var array2dict:Dictionary = new Dictionary(true);
			var obj:*;
			for each (obj in array2)
			array2dict[obj] = null;
			
			if (array2only != null)
				var resultDict:Dictionary = new Dictionary(true);
			
			for each (obj in array1)
			{
				if (array2dict.hasOwnProperty(obj))
				{
					result[result.length] = obj;
					if (resultDict)
						resultDict[obj] = null;
				}
				else if (array1only != null)
				{
					array1only[array1only.length] = obj;
				}
			}
			
			if (array2only != null)
			{
				for each (obj in array2)
				{
					if (!resultDict.hasOwnProperty(obj))
						array2only[array2only.length] = obj;
				}
			}
			
			return result;
		}
	}
	
}