/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.resManager.manager
{
import com.adobe.crypto.MD5Stream;

import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.system.LoaderContext;
import flash.utils.Dictionary;

import org.rcSpark.rcant;
import org.rcSpark.resManager.data.ResType;
import org.rcSpark.resManager.data.StreamInfo;
import org.rcSpark.resManager.data.WaitToWake;
import org.rcSpark.resManager.events.ResEvent;
import org.rcSpark.resManager.loader.StreamLoader;
import org.rcSpark.resManager.res.BaseRes;
import org.rcSpark.resManager.util.URLCode;
import org.rcSpark.tools.debug.ILogger;
import org.rcSpark.tools.file.SharedObjectFileUtil;

//--------------------------------------------------------------------------
//
//  Imports
//
//--------------------------------------------------------------------------
/****
 * ResMan.as class. Created 2:31:52 PM Sep 6, 2012
 * <br>
 * Description:var urlData :ResData  = new ResData(url);
 CResManager.getInstance().load(urlData.resType, urlData.url, urlData.loadLevel, null, loadResComplete, null, onLoaderError);

 參數說明： type 加載類型    url 加載文件地址  loadlevel 加載文件加載優先級   ct 加載文件加載的域
 onCompleteHandle 加載成功函數   onProgressHandle  加載進度函數  onErrorHandle  加載出錯函數
 init 加載成功以後是否初始化 默認是二進制文件  ,isNew 加載成功以後是否新建一個實例

 onCompleteHandle： isNew 為否的時候用這個
 mc = (ResManager.getInstance().getResByUrl(_url));
 isNew 為真的時候用這個
 mc = evt.res.content ;
 * @author ryan
 * @langversion 3.0
 * @playerversion Flash 10
 ****/
public final class NewResManager
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
    public static var MAX_THREAD:uint = 3;
    /**
     * 是否打印加载信息
     * */
    public static var TRACE_FLAG:Boolean = false ;
    /**
     * 同一文件 加载不成功  ，重新尝试次数
     * */
    public static var RETRY_LIMIT:uint =1;
    /**
     * 开启开关 是否监视加载过程，配合时间控制
     */
    public static var OVER_LOOK:Boolean = false ;
    /**
     * 监视加载过程时间，多长时间加载无进度，重新加载，配合开启开关控制
     */
    public static var OVER_TIME:uint = 5 ;
    /**
     * 加载文件前是否判断本地缓存 默认不加载本地缓存
     */
    public static var READ_LOACL_FILE:Boolean = false ;

    private static var __instance : NewResManager;
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

    /**版本管理,resVersionDic里面包含的资源,都需要加版本号再加载*/
    public static var resVersionDic:Dictionary = new Dictionary(true);

    public static var VersionFlag:String = "res_Version";
    /**
     * Log 记录 请先实现再打开log开关
     */
    public static var ilog:ILogger ;
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    public function NewResManager()
    {
        if(__instance){
            throw new Error("NewResManager is single!")
            return ;
        }
        _initedDatas = new Dictionary(true);
        loadedDic = new Dictionary(true);
        errorDic = new Dictionary(true);
        _waitToWake = new Dictionary(true);
    }

    public static function instance() : NewResManager {
        if (!__instance)
            __instance = new NewResManager();
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
    rcant function load(initType : String, url : Object, loadLevel : int = 0, ct : LoaderContext = null, onCompleteHandler : Function = null, onProgressHandler : Function = null, onErrorHandler : Function = null,init:Boolean = false,isNew:Boolean=false,isSave:Boolean=false) : void
    {
        toLoad(initType, url, loadLevel, ct, onCompleteHandler, onProgressHandler, onErrorHandler,init,isNew,isSave);
    }

    /**
     * 处理url，查看是否需要
     * @param url
     * @return
     */
    private function urlHandle(url: Object):URLRequest{
        if(url==""||url==null) return null;
        var urlReq : URLRequest = null;
        if (url is String) {
            urlReq = URLCode.decode(url as String);
        } else {
            urlReq = url as URLRequest;
        }
        return urlReq ;
    }

    /**
     * 给Url加载加上版本号Version
     * @param url
     * @param ver
     * @return urlString
     */
    private function addVersionToUrl(url:Object,ver:String):String{
        var urlReq : URLRequest = null;
        if (url is String) {
            urlReq = URLCode.decode(url as String);
        } else {
            urlReq = url as URLRequest;
        }
        removeVersionToUrl(urlReq);
        if(ver){
            if(!urlReq.data)
                urlReq.data = new URLVariables();
            urlReq.data[VersionFlag] = ver;
        }
        return URLCode.encode(urlReq);
    }

    /**
     * 通过删除Url的Version键值来作为加载类的唯一键值
     * @param url
     * @return urlString
     */
    private function removeVersionToUrl(url:Object):String{
        var urlReq : URLRequest = null;
        if (url is String) {
            urlReq = URLCode.decode(url as String);
        } else {
            urlReq = url as URLRequest;
        }
        if(urlReq.data)
            delete urlReq.data[VersionFlag];
        return URLCode.encode(urlReq);
    }

    private function toLoad(type : String, url : Object,loadLevel:uint = 0,ct : LoaderContext = null, onCompleteHandler : Function = null, onProgressHandler : Function = null, onErrorHandler : Function = null,init:Boolean = false,isNew:Boolean=false,isSave:Boolean=false) : void
    {
        var urlReq : URLRequest = urlHandle(url);
        if(!urlReq)
            return ;
        //先查询是否存在内存文件 再查询是否存在本地文件 最后决定是否加载新文件
        var rUrl : String = URLCode.encode(urlReq);
        var keyUrl:String = removeVersionToUrl(rUrl);

        var resData:StreamInfo = new StreamInfo();
        resData.url = keyUrl ;
        if(resVersionDic[keyUrl]){
            resData.md5sum = resVersionDic[keyUrl];
            if(!urlReq.data)
                urlReq.data = new URLVariables();
            urlReq.data[VersionFlag] = resData.md5sum;
        }
        resData.dataType = type ;
        resData.loadLevel = loadLevel ;
        resData.urlReq = urlReq ;
        resData.resCt = ct ;
        resData.onCompleteHandle = onCompleteHandler ;
        resData.onProgressHandle = onProgressHandler ;
        resData.onErrorHandle = onErrorHandler ;
        resData.init = init ;
        resData.isNew = isNew ;
        resData.isSave = isSave ;
        resData.state = StreamInfo.WAITING;
        if(TRACE_FLAG){
            ilog.debug("---NewResManager--add--url--{0}",URLCode.encode(urlReq));
        }
        handleStreamInfo(resData);
    }

    private function handleStreamInfo(si:StreamInfo):void{
        var resEvent:ResEvent ;
        if(_initedDatas[si.url])
        {
            //已初始化完成
            if(!si.isNew){
                if(si.init){
                    resEvent =new ResEvent(ResEvent.COMPLETED);
                    resEvent.inited = true ;
                    resEvent.res = BaseRes(_initedDatas[si.url]);
                    si.onCompleteHandle(resEvent);
                }else{
                    resEvent =new ResEvent(ResEvent.COMPLETED);
                    resEvent.inited = false ;
                    resEvent.streamInfo = StreamInfo(loadedDic[si.url]);
                    si.onCompleteHandle(resEvent);
                }
            }else{
                ResInit.instance().initResData(StreamInfo(loadedDic[si.url]),si.onCompleteHandle);
            }
            return ;
        }

        if(loadedDic[si.url])
        {
            //已加载完成
            if(!si.init){
                resEvent =new ResEvent(ResEvent.COMPLETED);
                resEvent.inited = false ;
                resEvent.streamInfo = StreamInfo(loadedDic[si.url]);
                si.onCompleteHandle(resEvent);
            }else{
                ResInit.instance().initResData(StreamInfo(loadedDic[si.url]),si.onCompleteHandle);
            }
            return ;
        }

        if(READ_LOACL_FILE){
            si.ba = SharedObjectFileUtil.readFileData(si.url,si.md5sum);
            if(si.ba){
                si.bytesLoaded = si.bytesTotal = si.ba.bytesAvailable ;
                loadedDic[si.url] = si ;
                if(!si.init){
                    resEvent =new ResEvent(ResEvent.COMPLETED);
                    resEvent.inited = false ;
                    resEvent.streamInfo = StreamInfo(loadedDic[si.url]);
                    si.onCompleteHandle(resEvent);
                }else{
                    ResInit.instance().initResData(StreamInfo(loadedDic[si.url]),si.onCompleteHandle);
                }
                return ;
            }
        }

        if(errorDic[si.url])
        {
            resEvent =new ResEvent(ResEvent.ERROR);
            resEvent.streamInfo = si ;
            si.onErrorHandle(resEvent);
            return ;
        }

        addUrlToWaitList(si);
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
                loader.overTime = NewResManager.OVER_TIME ;
                loader.overlook = NewResManager.OVER_LOOK ;
                if(!loader.hasEventListener(ResEvent.COMPLETED))
                    loader.addEventListener(ResEvent.COMPLETED, onCompleteHandler);
                if(!loader.hasEventListener(ResEvent.ERROR))
                    loader.addEventListener(ResEvent.ERROR, onErrorHandler);
                if(!loader.hasEventListener(ResEvent.PROGRESS))
                    loader.addEventListener(ResEvent.PROGRESS, onProgressHandler);
                loader.load(resData.urlReq);
                if(TRACE_FLAG){
                    ilog.debug("---NewResManager--startLoad--url--{0}",URLCode.encode(resData.urlReq));
                }
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
        var keyUrl:String = removeVersionToUrl(streamInfo.url);

        var md5:MD5Stream = new MD5Stream();
        var md5String:String = md5.complete(streamInfo.ba);
        var ver:String = resVersionDic[keyUrl];
        if(ver&&ver!=""&& md5String != ver){
            // TODO 加载成功的文件不是所需要的文件
            //加载不成功  返回文件加载成功  但不匹配消息
            if(TRACE_FLAG){
                ilog.debug("---NewResManager--md5numWrong----url,needmd5,itsmd5----{0},{1},{2}--",[URLCode.encode(streamInfo.urlReq),ver,md5String]);
            }
        }

        if(TRACE_FLAG){
            ilog.debug("---NewResManager--loadComplete----url----{0}--",URLCode.encode(streamInfo.urlReq));
        }

        if(!streamInfo.init){
            removeUrlFromLoadingList(streamInfo);
            if(streamInfo.onCompleteHandle!=null)
                streamInfo.onCompleteHandle(evt);
            var toWake:WaitToWake = _waitToWake[keyUrl];
            if(toWake)
                toWake.onCompleteHandle(evt);
            delete _waitToWake[keyUrl];
            loadedDic[keyUrl] = streamInfo ;
            this._loadingCount--;
            startLoad();
        }else{
            loadedDic[keyUrl] = streamInfo ;
            removeUrlFromLoadingList(streamInfo);
            this._loadingCount--;
            startLoad();
            ResInit.instance().initResData(streamInfo,onInitCompleteHandler);
        }

        if(streamInfo.isSave){
            //成功加载的文件需要保存
            SharedObjectFileUtil.saveFileData(keyUrl,streamInfo.ba,md5String);
            if(TRACE_FLAG){
                ilog.debug("---NewResManager--saveFile----url----{0}--",keyUrl);
            }
        }
    }

    private function onInitCompleteHandler(evt:ResEvent):void
    {
        var resUrl:String = evt.res.url ;
        var keyUrl:String = removeVersionToUrl(resUrl);
        _initedDatas[keyUrl] = evt.res ;
        var streamInfo:StreamInfo = loadedDic[keyUrl];
        if(streamInfo==null)
            throw new Error("Why!");
        if(streamInfo.onCompleteHandle!=null)
            streamInfo.onCompleteHandle(evt);
        var toWake:WaitToWake = _waitToWake[keyUrl];
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
        delete _waitToWake[keyUrl];
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
        var keyUrl:String = removeVersionToUrl(streamInfo.url);
        if(TRACE_FLAG){
            ilog.debug("---NewResManager--loadError----url----{0}--",keyUrl);
        }
        if(errorDic[keyUrl]==null)
            errorDic[keyUrl] = true ;
        if(streamInfo.onErrorHandle!=null)
            streamInfo.onErrorHandle(evt);
        var toWake:WaitToWake = _waitToWake[keyUrl];
        if(toWake)
            toWake.onErrorHandle(evt);
        delete _waitToWake[keyUrl];
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
                compair.isSave = ((vo.isSave) || (compair.isSave));
                if (compair.init){
                    compair.isNew = ((vo.isNew) || (compair.isNew));
                }
                toWake = _waitToWake[compair.url];
                if (!(toWake)){
                    toWake = new WaitToWake();
                }
                toWake.url = compair.url;
                toWake.addCompleteHandle(vo.onCompleteHandle);
                toWake.addProgressHandles(vo.onProgressHandle);
                toWake.addErrorHandles(vo.onErrorHandle);
                _waitToWake[compair.url] = toWake;
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
                compair.isSave = ((vo.isSave) || (compair.isSave));
                if (compair.init){
                    compair.isNew = ((vo.isNew) || (compair.isNew));
                }
                toWake = _waitToWake[compair.url];
                if (!(toWake)){
                    toWake = new WaitToWake();
                }
                toWake.url = compair.url;
                toWake.addCompleteHandle(vo.onCompleteHandle);
                toWake.addProgressHandles(vo.onProgressHandle);
                toWake.addErrorHandles(vo.onErrorHandle);
                _waitToWake[compair.url] = toWake;
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
            if (_waitList[i].url == removeVersionToUrl(removeVersionToUrl(vo.url))){
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
            if (_loadingList[i].url == removeVersionToUrl(vo.url)){
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
    /**
     * 以指定url为键值，并以指定类型获取唯一的资源,
     * @param url
     * @param type
     * @return
     *
     */
    public function getResByUrl(url : String, type : String = "movie") : * {
        switch(type) {
            case ResType.BINARY:
            case ResType.TEXT:
            case ResType.ToAVM2:
                if(loadedDic[url])
                    return (loadedDic[url] as StreamInfo).ba;
                else
                    return null;
                break;
            case ResType.MOVIE:
                if(_initedDatas[url])
                    return _initedDatas[url] as BaseRes;
                else
                    return null;
                break;
            default:
                break;
                return null ;
        }
    }

    public function memoryClean():void{
        for (var key:* in _initedDatas) {
            (_initedDatas[key] as BaseRes).dispose();
            delete _initedDatas[key];
        }
        for (var key1:* in loadedDic) {
            (loadedDic[key1] as StreamInfo).dispose();
            delete loadedDic[key1];
        }
    }
}
}