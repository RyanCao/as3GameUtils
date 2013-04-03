/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.tools.text
{
	import flash.text.TextField;
	import flash.text.TextFormat;

	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	
	/****
	 * HtmlUtil.as class. Created Aug 17, 2012 12:27:46 AM
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/   	 
	public final class HTMLUtil
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
		public function HTMLUtil()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		
		public static function color(content:String, theColor:String):String
		{
			return "<font color='" + theColor + "'>" + content + "</font>"; 
		}
		public static function fontSizeAndColor(content:String, theColor:String , fontSize:int):String
		{
			return "<font color='" + theColor +"' size='"+fontSize+"'>" + content + "</font>"; 
		}
		public static function fontSize(content:String, fontSize:int):String
		{
			return "<font size='"+fontSize+"'>" + content + "</font>"; 
		}
		public static function p(content:String,align:String = "left"):String
		{
			return "<p align=\""+align+"\">" + content + "</p>";
		}
		public static function u(content:String):String
		{
			return "<u>" + content + "</u>";
		}
		public static function customColor(content:String, theColor:String):String
		{
			return "&" + theColor + "&" + content;
		}
		public static function bold(content:String):String
		{
			return "<b>" + content + "</b>";
		}
		public static function removeHtml(content:String):String
		{
			var result:String = content.replace(/\<\/?[^\<\>]+\>/gmi, "");
			result = result.replace(/[\r\n ]+/g, ""); 
			return result;
		}
		public static function addEventParameter(str : String, parameter : String) : String {
			return "<a href=\"event:" + parameter + "\">" + str + "</a>" ;
		}
		/**
		 * 根据TextFormat附加HTML文本
		 * @param v
		 * @param format
		 * 
		 */
		public static function applyTextFormat(v:String,format:TextFormat):String
		{
			var t:TextField = new TextField();
			t.defaultTextFormat = format;
			t.text = v;
			return t.htmlText;
		}
	}
	
}