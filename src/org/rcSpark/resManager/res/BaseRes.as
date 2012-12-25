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
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import org.rcSpark.resManager.data.ResData;
	import org.rcSpark.resManager.events.DataEvent;
	
	/**
	 * 资源加载完成事件
	 */
	[Event(name="completed_data", type="org.rcSpark.resManager.events.DataEvent")]
	
	/**
	 * 资源加载出错
	 */
	[Event(name="error_data", type="org.rcSpark.resManager.events.DataEvent")]
	
	/****
	 * BaseRes.as class. Created 2:44:54 PM Aug 20, 2012
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/
	public class BaseRes extends EventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		protected var _loader:*;
		/**
		 * Maybe : flash.display.AVM1Movie,MovieClip,Bitmap,ByteArray,String
		 * */
		protected var _content:*;
		/**
		 *ResString：素材地址
		 * */
		public var url:String ;
		
		
		/**
		 * 資源初始化時 觸發的函數
		 */		
		public var onInitCompleteHandle:Function ;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function BaseRes(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		public function loadBytes(bytes:ByteArray, ct:LoaderContext):void
		{
			throw new Error("must be override");
		}
		
		/**
		 * 资源加载完成
		 * @param evt
		 *
		 */
		protected function onCompleteHandler(evt:Event):void
		{
			if (evt.target != null)
			{
				if((evt.target as IEventDispatcher).hasEventListener(Event.COMPLETE))
					(evt.target as IEventDispatcher).removeEventListener(Event.COMPLETE, onCompleteHandler);
				if((evt.target as IEventDispatcher).hasEventListener(IOErrorEvent.IO_ERROR))
					(evt.target as IEventDispatcher).removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandle);
			}
			var dataEvent:DataEvent = new DataEvent(DataEvent.COMPLETED);
			dataEvent.content=this._content;
			this.dispatchEvent(dataEvent);
		}
		protected function onErrorHandle(evt:IOErrorEvent):void
		{
			if (evt.target != null)
			{
				if((evt.target as IEventDispatcher).hasEventListener(Event.COMPLETE))
					(evt.target as IEventDispatcher).removeEventListener(Event.COMPLETE, onCompleteHandler);
				if((evt.target as IEventDispatcher).hasEventListener(IOErrorEvent.IO_ERROR))
					(evt.target as IEventDispatcher).removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandle);
			}
			var dataEvent:DataEvent = new DataEvent(DataEvent.ERROR);
			this.dispatchEvent(dataEvent);
		}
		
		/***
		 * to be override
		 * */
		public function dispose():void
		{
			
		}
		public function get content():*{
			return _content ;
		}
	}
}