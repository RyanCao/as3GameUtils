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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import org.rcSpark.resManager.data.ResData;
	import org.rcSpark.tools.display.BitmapUtil;
	
	
	/****
	 * ImageRes.as class. Created Aug 21, 2012 10:48:11 PM
	 * <br>
	 * Description:用来加载图片文件
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/   	 
	public class ImageRes extends BaseRes
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
		public function ImageRes(target:IEventDispatcher=null)
		{
			super(target);
			_loader = new Loader();
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
				var loader:Loader=_loader as Loader;
				if(!loader.hasEventListener(Event.COMPLETE))
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
				if(!loader.hasEventListener(IOErrorEvent.IO_ERROR))
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandle);
				loader.loadBytes(bytes, ct);
			}
			catch(e:*)
			{
				throw(new Error("ResError--:MovieRes"+this.toString()));
			}
		}
		
		override protected function onCompleteHandler(evt:Event):void
		{
			var loader:Loader=_loader as Loader;
			this._content= loader.content;
			super.onCompleteHandler(evt);
			loader.unload();
			loader = null ;
		}
		
	}
	
}