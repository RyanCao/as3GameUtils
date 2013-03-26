/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.resManager.data
{
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.system.LoaderContext;

	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	
	/****
	 * SteamInfo.as class. Created 4:18:51 PM Sep 1, 2012
	 * <br>
	 * Description: 用於存取ByteArray 加載到的文件均以byteArray存取 
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/
	public class StreamInfo
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**还沒有添加该资源**/
		public static const NONE:String="none";
		/**资源等待中*/
		public static const WAITING:String="waiting";
		/**资源下载中*/
		public static const LOADING:String="loading";
		/**资源已下载*/
		public static const COMPLETED:String="completed";
		/**资源下载错误*/
		public static const ERROR:String="error";
		
		/**当前状态*/
		public var state:String=NONE;
		/**
		 * 數據內容 
		 */
		public var ba:ByteArray ;
		public var url:String ;
		public var urlReq:URLRequest ;
		/**已加载的字节数*/
		public var bytesLoaded:uint=0;
		/**
		 * 数据类型
		 * */
		public var dataType:String ;
		/**
		 * 数据域
		 * */
		public var resCt:LoaderContext;
		/**资源总大小
		 * <p>如果资源是实时流,或大小未知,那麼總大小與<code>bytesLoaded<code>的值一样,会随着下载数据增加而动态增加</p>
		 * <p>可用于数据绑定</p>
		 */
		public var bytesTotal:uint=0;
		/**
		 * 是否初始化
		 * */
		public var init:Boolean = false ;
		/***
		 * 加载等级
		 * */
		public var loadLevel:uint = 0;
		/**
		 * 是否创建新对象返回
		 * */
		public var isNew:Boolean = false;
		public var onCompleteHandle:Function ;
		public var onErrorHandle:Function ;
		public var onProgressHandle:Function ;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function StreamInfo(_url:String="",_restype:String = "movie",_init:Boolean=false,_loadLevel:uint=0,complete:Function=null,error:Function=null,progress:Function=null)
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			
		}
	}
}