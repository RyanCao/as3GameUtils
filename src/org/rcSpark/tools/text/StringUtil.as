/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.tools.text
{
	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	
	/****
	 * StringUtil.as class. Created Aug 17, 2012 12:31:34 AM
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/   	 
	public final class StringUtil
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
		public function StringUtil()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		private static function ld(str1 : String, str2 : String) : int {
			var d : Array = [];
			var n : int = str1.length;
			var m : int = str2.length;
			var i : int;
			var j : int;
			
			var ch1 : String;
			var ch2 : String;
			var temp : int;
			
			if (n == 0) {
				return m;
			}
			if (m == 0) {
				return n;
			}
			
			for (i = 0; i <= n; i++) {
				if (!d[i])
					d[i] = [];
				d[i][0] = i;
			}
			for (j = 0; j <= m; j++) {
				if (!d[0])
					d[0] = [];
				d[0][j] = j;
			}
			for (i = 1; i <= n; i++) {
				ch1 = str1.charAt(i - 1);
				for (j = 1; j <= m; j++) {
					ch2 = str2.charAt(j - 1);
					if (ch1 == ch2) {
						temp = 0;
					} else {
						temp = 1;
					}
					d[i][j] = Math.min(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + temp);
				}
			}
			return d[n][m];
		}
		
		/**
		 * 计算两个字符串的相似度 
		 * @param str1
		 * @param str2
		 * @return 
		 * 
		 */
		public static function sim(str1 : String, str2 : String) : Number {
			var ld : int = ld(str1, str2);
			return 1 - Number(ld / Math.max(str1.length, str2.length));
		}
		
		/**
		 * 比较字符串
		 * 
		 * @param s1	原字符串
		 * @param s2	新字符串
		 * @return 返回一个数组，数组的元素由[是否是删除,在原字符串中的索引,添加或者删除的字符串]组成,索引坐标以原始字符串为准
		 * 
		 */
		public static function compare(s1:String,s2:String):Array   
		{   
			var actions:Array = [];//全部操作  
			var prev:Array;//上一个操作
			var i1:int = 0;
			var i2:int = 0;	    
			while(i2 < s2.length)   
			{   
				var status:int = s1.indexOf(s2.charAt(i2),i1);
				if (status >= 0)
					status -= i1;
				
				if(status == 0)
				{   
					i1++;   
					i2++;   
				}   
				else
				{
					if(status == -1)   
					{   
						if (prev && prev[0]==false && prev[1] == i1)
							prev[2] += s2.charAt(i2);
						else
						{
							prev = [false,i1,s2.charAt(i2)];
							actions.push(prev);
						}
						
						i2++;
					}   
					else   
					{   
						if (prev && prev[0]==true && prev[1] + prev[2].length == i1)
							prev[2] += s1.charAt(i1);
						else
						{
							prev = [true,i1,s1.charAt(i1)];
							actions.push(prev);
						}
						
						i1++;   
					}  
				}
			}
			
			if (i1 < s1.length)
				actions.push([true,i1,s1.substr(i1)]);
			
			return actions;
		}
		
		/**
		 * 将变化数组应用到当前字符串上
		 * 
		 * @param s
		 * @param actions
		 * 
		 */
		public static function apply(s:String,actions:Array):String
		{
			var offest:int = 0;
			for (var i:int = 0;i < actions.length;i++)
			{
				var action:Array = actions[i];
				if (action[0])
				{
					s = s.substr(0,action[1] + offest) + s.substr(action[1] + action[2].length + offest);
					offest -= action[2].length;
				}
				else
				{
					s = s.substr(0,action[1] + offest) + action[2] + s.substr(action[1] + offest);
					offest += action[2].length;
				}
			}
			return s;
		}
	}
	
}