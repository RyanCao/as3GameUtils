/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.resManager.manager
{
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import org.rcSpark.rcant;
	import org.rcSpark.resManager.data.StreamInfo;
	import org.rcSpark.resManager.data.WaitToWake;
	import org.rcSpark.resManager.events.ResEvent;
	import org.rcSpark.resManager.loader.StreamLoader;
	import org.rcSpark.resManager.res.BaseRes;
	import org.rcSpark.resManager.util.URLCode;
	
	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	/****
	 * ResMan.as class. Created 2:31:52 PM Sep 6, 2012
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/
	public final class CResManager
	{
		//namespace rcant ;
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * 使用ResManager同时可以加载的文件数量
		 * */
		public static var TRACE_FLAG:Boolean = false ;
		public static var MAX_THREAD:uint = 3;
		public static var RETRY_LIMIT:uint =1;
		
		public static var OVER_LOOK:Boolean = false ;
		public static var OVER_TIME:uint = 5 ;
		
		private static var __instance : CResManager;
		/**
		 * 资源地址库[String]
		 * */
		private var _urlDic:Dictionary;
		/***
		 * 重複加載庫
		 * */
		private var retryDic:Dictionary;
		private var _initedDatas:Dictionary ;
		/***
		 * 已经加载完成的资源[SteamInfo]
		 * */
		private var loadedDic:Dictionary;
		/**
		 * 不能加载的资源
		 * */
		private var errorDic:Dictionary ;
		/**
		 *正在加载的资源列表 
		 */
		private var _loadingList:Vector.<StreamInfo>;
		/**
		 * 等待加载库 
		 * see StreamInfo
		 * */
		private var _waitList:Vector.<StreamInfo>;
		/**
		 * 等待加载库 
		 * see WaitToWake
		 * */
		private var _waitToWake:Dictionary;
		/**
		 * 当前正在进行的文件加载数量
		 * */
		private var _loadingCount:uint = 0;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function CResManager()
		{
			if(__instance){
				throw new Error("ResMan is single!")
				return ;
			}
			_initedDatas = new Dictionary(true);
			loadedDic = new Dictionary(true);
			errorDic = new Dictionary(true);
			_waitToWake = new Dictionary(true);
		}
		
		public static function instance() : CResManager {
			if (!__instance) 
				__instance = new CResManager();
			return __instance;
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------

		/***
		 * 已经初始化的资源[BaseRes]
		 * */
		rcant function get initedDatas():Dictionary
		{
			return _initedDatas;
		}

		/**
		 * @private
		 */
		rcant function set initedDatas(value:Dictionary):void
		{
			_initedDatas = value;
		}

		/**
		 * 按设置的方式加载资源
		 * @param initType 指定资源类型,参考ResType
		 * @param url url地址 可以是String 也可以是UrlRequest
		 * @param loadLevel 加载优先级
		 * @param ct 加载到目标域
		 * @param onCompleteHandler 完成函数回调接口
		 * @param onProgressHandler 进度函数回调接口
		 * @param onErrorHandler 资源加载异常捕捉接口
		 * @param init 是否使用自动初始化 false 只加载，不初始化，true 既加载
		 * @param isNew 是否使用New创建新对象返回  false 不创建，true 创建  初始化等级
		 * @return
		 *
		 */
		rcant function load(initType : String, url : Object, loadLevel : int = 0, ct : LoaderContext = null, onCompleteHandler : Function = null, onProgressHandler : Function = null, onErrorHandler : Function = null,init:Boolean = false,isNew:Boolean=false) : void
		{
			toLoad(initType, url, loadLevel, ct, onCompleteHandler, onProgressHandler, onErrorHandler,init,isNew);
		}
		
		private function toLoad(type : String, url : Object,loadLevel:uint = 0,ct : LoaderContext = null, onCompleteHandler : Function = null, onProgressHandler : Function = null, onErrorHandler : Function = null,init:Boolean = false,isNew:Boolean=false) : void
		{
			if(url==""||url==null) return;
			var urlReq : URLRequest = null;
			if (url is String) {
				urlReq = URLCode.decode(url as String);
			} else {
				urlReq = url as URLRequest;
			}
			var rUrl : String = URLCode.encode(urlReq);
			var resEvent:ResEvent ;
			if(_initedDatas[rUrl])
			{
				//已初始化完成
				if(!isNew){
					resEvent =new ResEvent(ResEvent.COMPLETED);
					resEvent.inited = true ;
					resEvent.res = BaseRes(_initedDatas[rUrl]);
					onCompleteHandler(resEvent);
				}else{
					ResInit.instance().initResData(StreamInfo(loadedDic[rUrl]),onCompleteHandler);
				}
				return ;
			}
			
			if(loadedDic[rUrl])
			{
				//已加载完成
				if(!init){
					resEvent =new ResEvent(ResEvent.COMPLETED);
					resEvent.inited = false ;
					resEvent.streamInfo = StreamInfo(loadedDic[rUrl]);
					onCompleteHandler(resEvent);
				}else{
					ResInit.instance().initResData(StreamInfo(loadedDic[rUrl]),onCompleteHandler);
				}
				return ;
			}
			if(errorDic[rUrl])
			{
				resEvent =new ResEvent(ResEvent.ERROR);
				onErrorHandler(resEvent);
				return ;
			}
			
			var resData:StreamInfo = new StreamInfo();
			resData.url = rUrl ;
			resData.dataType = type ;
			resData.loadLevel = loadLevel ;
			resData.urlReq = urlReq ;
			resData.resCt = ct ;
			resData.onCompleteHandle = onCompleteHandler ;
			resData.onProgressHandle = onProgressHandler ;
			resData.onErrorHandle = onErrorHandler ;
			resData.init = init ;
			resData.isNew = isNew ;
			resData.state = StreamInfo.WAITING;
			addUrlToWaitList(resData);
			_waitList.sort(compareWaitRes);
			startLoad();
		}
		
		protected function startLoad() : void {
			if (this._loadingCount < MAX_THREAD && this._waitList.length > 0) {
				var resData:StreamInfo = this._waitList.shift();
				if (resData != null) {
					resData.state = StreamInfo.LOADING;
					this._loadingCount++;
					if(!_loadingList)
						_loadingList = new Vector.<StreamInfo>();
					_loadingList.push(resData);
					var loader : StreamLoader = new StreamLoader(resData);
					loader.overTime = CResManager.OVER_TIME ;
					loader.overlook = CResManager.OVER_LOOK ;
					if(!loader.hasEventListener(ResEvent.COMPLETED))
						loader.addEventListener(ResEvent.COMPLETED, onCompleteHandler);
					if(!loader.hasEventListener(ResEvent.ERROR))
						loader.addEventListener(ResEvent.ERROR, onErrorHandler);
					if(!loader.hasEventListener(ResEvent.PROGRESS))
						loader.addEventListener(ResEvent.PROGRESS, onProgressHandler);
					loader.load(resData.urlReq);
				} else {
				}
			}
		}
		
		protected function onProgressHandler(evt : ResEvent) : void {
			var loader : StreamLoader = (evt.target as StreamLoader);
			var reData : StreamInfo = loader.getResData();
			reData.bytesLoaded = evt.bytesLoaded;
			reData.bytesTotal = evt.bytesTotal;
			if(reData.onProgressHandle!=null)
				reData.onProgressHandle(evt);
			var toWake:WaitToWake = _waitToWake[reData.url];
			if(toWake)
				toWake.onProgressHandle(evt);
		}
		
		protected function onCompleteHandler(evt : ResEvent) : void {
			var loader : StreamLoader = (evt.target as StreamLoader);
			if(loader.hasEventListener(ResEvent.COMPLETED))
				loader.removeEventListener(ResEvent.COMPLETED, onCompleteHandler);
			if(loader.hasEventListener(ResEvent.PROGRESS))
				loader.removeEventListener(ResEvent.PROGRESS, onProgressHandler);
			if(loader.hasEventListener(ResEvent.ERROR))
				loader.removeEventListener(ResEvent.ERROR, onErrorHandler);
			var streamInfo:StreamInfo = loader.getResData() ;
			if(!streamInfo.init){
				removeUrlFromLoadingList(streamInfo);
				if(streamInfo.onCompleteHandle!=null)
					streamInfo.onCompleteHandle(evt);
				var toWake:WaitToWake = _waitToWake[streamInfo.url];
				if(toWake)
					toWake.onCompleteHandle(evt);
				delete _waitToWake[streamInfo.url];
				loadedDic[streamInfo.url] = streamInfo ;
				this._loadingCount--;
				startLoad();
			}else{
				loadedDic[streamInfo.url] = streamInfo ;
				removeUrlFromLoadingList(streamInfo);
				this._loadingCount--;
				startLoad();
				ResInit.instance().initResData(streamInfo,onInitCompleteHandler);
			}
		}
		
		private function onInitCompleteHandler(evt:ResEvent):void
		{
			var resUrl:String = evt.res.url ;
			_initedDatas[resUrl] = evt.res ;
			
			var streamInfo:StreamInfo = loadedDic[resUrl];
			if(streamInfo==null)
				throw new Error("Why!");
			if(streamInfo.onCompleteHandle!=null)
				streamInfo.onCompleteHandle(evt);
			var toWake:WaitToWake = _waitToWake[streamInfo.url];
			if(toWake){
				if(!streamInfo.isNew)
					toWake.onCompleteHandle(evt);
				else{
					var i:int = 0;
					while (i < toWake.completeHandles.length) {
						var handle:Function = toWake.completeHandles[i];
						ResInit.instance().initResData(streamInfo, handle);
						i++;
					}
				}
			}
			delete _waitToWake[streamInfo.url];
		}
		
		/***
		 *
		 * */
		protected function onErrorHandler(evt : ResEvent):void
		{
			var loader : StreamLoader = (evt.target as StreamLoader);
			if(loader.hasEventListener(ResEvent.COMPLETED))
				loader.removeEventListener(ResEvent.COMPLETED, onCompleteHandler);
			if(loader.hasEventListener(ResEvent.PROGRESS))
				loader.removeEventListener(ResEvent.PROGRESS, onProgressHandler);
			if(loader.hasEventListener(ResEvent.ERROR))
				loader.removeEventListener(ResEvent.ERROR, onErrorHandler);
			var streamInfo:StreamInfo = loader.getResData() ;
			if(errorDic[streamInfo.url]==null)
				errorDic[streamInfo.url] = true ;
			if(streamInfo.onErrorHandle!=null)
				streamInfo.onErrorHandle(evt);
			var toWake:WaitToWake = _waitToWake[streamInfo.url];
			if(toWake)
				toWake.onErrorHandle(evt);
			delete _waitToWake[streamInfo.url];
			loader.dispose();
			streamInfo.dispose();
			loader = null ;
			
			this._loadingCount--;
			startLoad();
		}
		
		
		/***
		 * 添加地址到等待列表中
		 * */
		private function addUrlToWaitList(vo:StreamInfo):void
		{
			if(!vo)
				return ;
			var i:int = 0;
			var compair:StreamInfo ;
			var toWake:WaitToWake ;
			
			if(!_waitList){
				_waitList = new Vector.<StreamInfo>() ;
				_waitList.push(vo);
				return ;
			}
			while (i < _waitList.length) {
				compair = (_waitList[i] as StreamInfo);
				if (compair.url == vo.url){
					compair.loadLevel = Math.max(Math.min(vo.loadLevel, compair.loadLevel), 0);
					compair.init = ((vo.init) || (compair.init));
					if (compair.init){
						compair.isNew = ((vo.isNew) || (compair.isNew));
					}
					toWake = _waitToWake[vo.url];
					if (!(toWake)){
						toWake = new WaitToWake();
					}
					toWake.url = vo.url;
					toWake.addCompleteHandle(vo.onCompleteHandle);
					toWake.addProgressHandles(vo.onProgressHandle);
					toWake.addErrorHandles(vo.onErrorHandle);
					_waitToWake[vo.url] = toWake;
					return;
				}
				i++;
			}
			i = 0;
			while (i < _loadingList.length) {
				compair = (_loadingList[i] as StreamInfo);
				if (compair.url == vo.url){
					compair.loadLevel = Math.max(Math.min(vo.loadLevel, compair.loadLevel), 0);
					compair.init = ((vo.init) || (compair.init));
					if (compair.init){
						compair.isNew = ((vo.isNew) || (compair.isNew));
					}
					toWake = _waitToWake[vo.url];
					if (!(toWake)){
						toWake = new WaitToWake();
					}
					toWake.url = vo.url;
					toWake.addCompleteHandle(vo.onCompleteHandle);
					toWake.addProgressHandles(vo.onProgressHandle);
					toWake.addErrorHandles(vo.onErrorHandle);
					_waitToWake[vo.url] = toWake;
					return;
				}
				i++;
			}
			_waitList.push(vo);
		}
		
		private function compareWaitRes(resData1:StreamInfo,resData2:StreamInfo):Number{
			if(resData1.loadLevel<resData2.loadLevel) return -1 ;
			else if(resData1.loadLevel==resData2.loadLevel) return 0 ;
			else  return 1 ;
		}
		
		private function removeUrlFromWaitList(vo:StreamInfo):void
		{
			if(!vo)
				return ;
			var i:int = 0;
			while (i < _waitList.length) {
				if (_waitList[i].url == vo.url){
					_waitList.splice(i, 1);
					break;
				}
				i++;
			}
		}
		private function removeUrlFromLoadingList(vo:StreamInfo):void
		{
			if(!vo)
				return ;
			var i:int;
			while (i < _loadingList.length) {
				if (_loadingList[i].url == vo.url){
					_loadingList.splice(i, 1);
					break;
				}
				i++;
			}
		}
		private function getStreamInfoFromLoadingList(url:String):StreamInfo
		{
			if(!url||url=="")
				return null;
			for each (var itemInfo:StreamInfo in _loadingList) 
			{
				if(itemInfo.url == url)
				{
					return itemInfo;
				}
			}
			return null ;
		}
	}
}