/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.tools.data
{
	import flash.utils.getQualifiedClassName;
	
	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	
	/****
	 * MathUtil.as class. Created Aug 17, 2012 12:10:05 AM
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/   	 
	public final class MathUtil
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
		public function MathUtil()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		/**
		 * 将数值限制在一个区间内
		 * 
		 * @param v	数值
		 * @param min	最大值
		 * @param max	最小值
		 * 
		 */		
		public static function limitIn(v:Number,min:Number,max:Number):Number
		{
			return v < min ? min : v > max ? max : v;
		}
		
		/**
		 * 返回的是数学意义上的atan（坐标系与Math.atan2上下颠倒）
		 * 
		 * @param dx
		 * @param dy
		 * @return 
		 * 
		 */
		public static function atan2(dx:Number, dy:Number):Number
		{
			var a:Number;
			if (dx == 0) 
				a = Math.PI / 2;
			else if (dx > 0) 
				a = Math.atan(Math.abs(dy/dx));
			else
				a = Math.PI - Math.atan(Math.abs(dy/dx));
			
			return dy >= 0 ? a : -a;
			
		}
		
		/**
		 * 求和
		 * 
		 * @param arr
		 * @return 
		 * 
		 */
		public static function sum(arr:Array):Number
		{
			var result:Number = 0.0;
			for each (var num:Number in arr)
			result += num;
			return result;
		}
		
		/**
		 * 平均值
		 *  
		 * @param arr
		 * @return 
		 * 
		 */
		public static function avg(arr:Array):Number
		{
			return sum(arr)/arr.length;
		}
		
		/**
		 * 最大值
		 * 
		 * @param arr
		 * @return 
		 * 
		 */
		public static function max(arr:Array):Number
		{
			var result:Number = NaN;
			for (var i:int = 0;i < arr.length;i++)
			{
				if (isNaN(result) || arr[i] > result)
					result = arr[i];
			}
			return result;
		}
		
		/**
		 * 最小值
		 * 
		 * @param arr
		 * @return 
		 * 
		 */
		public static function min(arr:Array):Number
		{
			var result:Number = NaN;
			for (var i:int = 0;i < arr.length;i++)
			{
				if (isNaN(result) || arr[i] < result)
					result = arr[i];
			}
			return result;
		}
		/**
		 * 二分查找
		 * */
		public static function binarySearch(keys:*, target:int):int
		{
			var keyCls:String = getQualifiedClassName(keys);
			if (keyCls.search(/^(__AS3__.vec::Vector\.<\w+>)|(Array)$/)){
				throw (TypeError("要使用二分查找，必须提供Array或者Vector！"));
			};
			
			var high:int = keys.length;
			var low:int = -1;
			
			while (high - low > 1)
			{
				var probe:int = (low + high) >>> 1; // Bit operations helps to speed up the process
				if (keys[probe] > target){
					high = probe;
				}else if(keys[probe] < target){
					low = probe;
				}else{
					return probe;
				}
			}
			return (low == -1 || keys[low] !== target) ? -1 : low;
		}
	}
	
}