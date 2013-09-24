/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.tools
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;
	import flash.utils.Dictionary;
	
	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	
	/****
	 * MouseStyle.as class. Created Sep 22, 2013 5:47:54 PM
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/   	 
	public class MouseStyle
	{		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private var _id:int;
		private var _value:String;
		private static var _dic:Dictionary = new Dictionary();
		
		public static const NORMAL:MouseStyle = new MouseStyle(0, "normal", [/*AssetsEmbeder.mouseNor*/]);
		public static const ATTACK:MouseStyle = new MouseStyle(1, "attack", [/*AssetsEmbeder.mouseAtk*/]);
		public static const PICK:MouseStyle = new MouseStyle(2, "pick", [/*AssetsEmbeder.mousePick*/]);
		public static const MINING:MouseStyle = new MouseStyle(3, "mining", [/*AssetsEmbeder.mouseMining*/]);
		public static const TALK:MouseStyle = new MouseStyle(4, "talk", [/*AssetsEmbeder.mouseTalk*/]);
		public static const JUMP:MouseStyle = new MouseStyle(5, "jump", [/*AssetsEmbeder.mouseJump*/]);
		public static const DISSOLVE:MouseStyle = new MouseStyle(6, "dissolve", [/*AssetsEmbeder.mouseSeparate*/]);
		public static const SELL:MouseStyle = new MouseStyle(7, "sell", [/*AssetsEmbeder.mouseSell*/]);
		public static const DIVIDE:MouseStyle = new MouseStyle(8, "divide", [/*AssetsEmbeder.mouseDivide*/]);
		public static const LOCK:MouseStyle = new MouseStyle(9, "lock", [/*AssetsEmbeder.mouseLock*/]);
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function MouseStyle(styleID:int, styleName:String, styleBitmaps:Array)
		{
			_id = styleID;
			_value = styleName;
			_dic[_value] = this;
			
			var bitmap:Bitmap = null;
			
			var mouseCursorData:MouseCursorData = new MouseCursorData();
			mouseCursorData.data = new Vector.<BitmapData>;
			mouseCursorData.frameRate = 1;
			mouseCursorData.hotSpot = new Point(0, 0);
			
			var count:int = 0;
			while (count < styleBitmaps.length)
			{
				bitmap = styleBitmaps[count];
				if (bitmap && bitmap.bitmapData)
				{
					mouseCursorData.data.push(bitmap.bitmapData);
				}
				count++;
			}
			Mouse.registerCursor(styleName, mouseCursorData);
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		public function get id() : int
		{
			return _id;
		}
		
		public function get value() : String
		{
			return _value;
		}
	}
	
}