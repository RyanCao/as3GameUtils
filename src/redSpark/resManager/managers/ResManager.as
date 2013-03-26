/*******************************************************************************
 * Class name:	ResManager.as
 * Description:	
 * Author:		ryancao
 * Create:		Sep 19, 2012 11:52:42 AM
 * Update:		Sep 19, 2012 11:52:42 AM
 ******************************************************************************/
package redSpark.resManager.managers
{
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import org.rcSpark.rcant;
	import org.rcSpark.resManager.data.ResType;
	import org.rcSpark.resManager.events.ResEvent;
	import org.rcSpark.resManager.manager.CResManager;
	import org.rcSpark.resManager.res.BaseRes;

	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	
	public final class ResManager
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		/**版本管理,resVersionDic里面包含的资源,都需要加版本号再加载*/
		public static var resVersionDic:Dictionary = new Dictionary(true);
		
		private static var _instace:ResManager ;
		
		public var _loadResDatas:Dictionary;
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function ResManager()
		{
			CResManager.MAX_THREAD = 1 ;
			CResManager.OVER_LOOK = true ;
			CResManager.OVER_TIME = 6 ;
			_loadResDatas = new Dictionary(true) 
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		
		public static function getInstance():ResManager
		{
			// TODO Auto Generated method stub
			if(!_instace)
				_instace = new ResManager();
			return _instace;
		}
		
		/**
		 * 获取数据
		 * @param value
		 * @return 
		 * 
		 */		
		public function getResByUrl(value:String,type:String=ResType.MOVIE):*
		{
			var res:BaseRes = getBaseResByUrl(value) as BaseRes;
			if(res)
				return res.content ;
			return null;
		}

		/**
		 * 获取数据
		 * @param value
		 * @return 
		 * 
		 */		
		public function getBaseResByUrl(value:String):BaseRes
		{
			var res:BaseRes ;
			if(resVersionDic[value]!=null) {
				res = CResManager.instance().rcant::initedDatas[resVersionDic[value]] as BaseRes;
			}else{
				res = CResManager.instance().rcant::initedDatas[value] as BaseRes;
			}
			return res ;
		}
		
		public function load(type:String, url:Object, loadLevel:int=0, ct:LoaderContext=null, onCompleteHandle:Function=null, onProgressHandle:Function=null,onErrorHandle:Function=null,init:Boolean = true,isNew:Boolean=true):void
		{
			if(resVersionDic[url]!=null) {
				//_loadResDatas[url] = [onCompleteHandle,onProgressHandle,onErrorHandle];
				/** 添加记录到Res列表中 */
				if(url is String)
					addToLoadResData(String(url),onCompleteHandle,onProgressHandle,onErrorHandle);
				CResManager.instance().rcant::load(type,resVersionDic[url],loadLevel,ct,onCompleteHandler,onProgressHandler,onErrorHandler,init,isNew);
			}else
				CResManager.instance().rcant::load(type,url,loadLevel,ct,onCompleteHandle,onProgressHandle,onErrorHandle,init,isNew);
		}
		
		private function addToLoadResData(url:String,onCompleteHandle:Function,onProgressHandle:Function,onErrorHandle:Function):void
		{
			var loadFuns:Array = _loadResDatas[url] as Array;
			var onCompletes:Vector.<Function> ;
			var onProgress:Vector.<Function> ;
			var onErrors:Vector.<Function> ;
			if(loadFuns==null){
				onCompletes = new Vector.<Function>();
				onCompletes.push(onCompleteHandle);
				onProgress = new Vector.<Function>();
				onProgress.push(onProgressHandle);
				onErrors = new Vector.<Function>();
				onErrors.push(onErrorHandle);
				loadFuns = [onCompletes,onProgress,onErrors];
				_loadResDatas[url] = loadFuns;
				return ;
			}else{
				onCompletes = loadFuns[0];
				onProgress = loadFuns[1];
				onErrors = loadFuns[2];
				
				onCompletes.push(onCompleteHandle);
				onProgress.push(onProgressHandle);
				onErrors.push(onErrorHandle);
			}
		}
		
		/**
		 * 版本控制记录
		 * */
		private function onCompleteHandler(evt:ResEvent):void{
			var url:String = "" ;
			if(evt.inited)
				url = evt.res.url ;
			else
				url = evt.streamInfo.url ;
			
			if(_loadResDatas[url]==null)
				return ;
			var onCompletes:Vector.<Function> = _loadResDatas[url][0] as Vector.<Function> ;
			
			if(resVersionDic[url]!=null){
				if(evt.inited)
					evt.res.url = resVersionDic[url];
				else
					evt.streamInfo.url = resVersionDic[url];
			}
			
			for each (var onComplete:Function in onCompletes) 
			{
				if(onComplete!=null)
				{
					onComplete(evt);
				}
			}
			
			delete _loadResDatas[url];
			
		}
		private function onProgressHandler(evt:ResEvent):void{
			var url:String = "" ;
			if(evt.inited)
				url = evt.res.url ;
			else
				url = evt.streamInfo.url ;
			
			if(_loadResDatas[url]==null)
				return ;
			var onProgresss:Vector.<Function> = _loadResDatas[url][1] as Vector.<Function> ;
			if(resVersionDic[url]!=null){
				if(evt.inited)
					evt.res.url = resVersionDic[url];
				else
					evt.streamInfo.url = resVersionDic[url];
			}
			for each (var onProgress:Function in onProgresss) 
			{
				if(onProgress!=null)
				{
					onProgress(evt);
				}
			}
		}
		private function onErrorHandler(evt:ResEvent):void{
			var url:String = "" ;
			if(evt.inited)
				url = evt.res.url ;
			else
				url = evt.streamInfo.url ;
			
			if(_loadResDatas[url]==null)
				return ;
			var onErrors:Vector.<Function> = _loadResDatas[url][2] as Vector.<Function> ;
			if(resVersionDic[url]!=null){
				if(evt.inited)
					evt.res.url = resVersionDic[url];
				else
					evt.streamInfo.url = resVersionDic[url];
			}
			for each (var onError:Function in onErrors) 
			{
				if(onError!=null)
				{
					onError(evt);
				}
			}
			
			delete _loadResDatas[url];
		}
			
		public function unload(url:String):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function unloadAll():void
		{
			// TODO Auto Generated method stub
			
		}
	}
}