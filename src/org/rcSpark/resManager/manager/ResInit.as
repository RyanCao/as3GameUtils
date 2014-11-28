/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.resManager.manager
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.rcSpark.resManager.data.ResType;
	import org.rcSpark.resManager.data.StreamInfo;
	import org.rcSpark.resManager.events.DataEvent;
	import org.rcSpark.resManager.events.ResEvent;
	import org.rcSpark.resManager.res.BaseRes;
	import org.rcSpark.resManager.res.BinaryRes;
	import org.rcSpark.resManager.res.ImageRes;
	import org.rcSpark.resManager.res.MovieRes;
	import org.rcSpark.resManager.res.TextRes;

	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	
	/****
	 * ResInit.as class. Created 2:05:42 PM Sep 6, 2012
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/
	public final class ResInit
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private static var __instance:ResInit;
		/**
		 * 初始化資源類型列表
		 * */
		private var initResTypes:Dictionary;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function ResInit()
		{
			if(__instance){
				throw new Error("ResInit is Single");
				return ;
			}
			//init ResType
			initResTypes = new Dictionary(true);
			initResTypes[ResType.MOVIE] = MovieRes;
			initResTypes[ResType.BINARY]= BinaryRes;
			initResTypes[ResType.IMAGE]= ImageRes;
			initResTypes[ResType.TEXT] = TextRes;
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		public static function instance():ResInit
		{
			if(!__instance)
				__instance = new ResInit();
			return __instance ;
		}
		
		public function initResData(data:StreamInfo,onCompleteHandle:Function = null ):void
		{
			if(!data){
				trace("ResInit...data == ",data);
				return ;
			}
			var classRef:Class = initResTypes[data.dataType];
			var res:BaseRes = new classRef() as BaseRes;
			res.onInitCompleteHandle = onCompleteHandle;
			res.url = data.url ;
			res.addEventListener(DataEvent.COMPLETED,onResInitCompleteHandle);
			res.loadBytes(data.ba,data.resCt);
		}
		
		protected function onResInitCompleteHandle(event:DataEvent):void
		{
			var res:BaseRes = event.target as BaseRes ;
			res.removeEventListener(DataEvent.COMPLETED,onResInitCompleteHandle);
			if(res.onInitCompleteHandle!=null){
                var resEvent:ResEvent =new ResEvent(ResEvent.COMPLETED);
                resEvent.inited = true ;
				resEvent.res = res;
				res.onInitCompleteHandle(resEvent);
			}
		}
		
	}
}