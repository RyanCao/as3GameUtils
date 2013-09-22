/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.resManager.res
{
	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import org.rcSpark.resManager.data.ResData;
	
	
	/****
	 * TextRes.as class. Created 2:47:15 PM Aug 20, 2012
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/
	public class TextRes extends BaseRes
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		public var data:* ;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function TextRes(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		override public function loadBytes(bytes:ByteArray, ct:LoaderContext):void
		{
			try
			{
				data = bytes.readUTFBytes(bytes.bytesAvailable);
				_content = data ;
				super.onCompleteHandler(new Event(""));
			}
			catch(e:*)
			{
				throw(new Error("ResError--:TextRes"+this.toString()));
			}
		}
	}
}