/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.resManager.data
{
import flash.net.URLRequest;
import flash.system.LoaderContext;
import flash.utils.ByteArray;

import org.rcSpark.resManager.util.DisposeUtil;

//--------------------------------------------------------------------------
//
//  Imports
//
//--------------------------------------------------------------------------

/****
 * ResData.as class. Created Aug 18, 2012 10:54:41 AM
 * <br>
 * Description:
 * @author ryan
 * @langversion 3.0
 * @playerversion Flash 10
 ****/
public class ResData
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
    /**资源已實例化*/
    public static const INITED:String="inited";

    //public var contexts:Dictionary=new Dictionary();

    /**当前状态*/
    public var state:String=NONE;

    /**资源类型：Ascii，binary ,image , audio*/
    //public var type:String ;

    /**是否立即初始化*/
    public var init:Boolean=false;

    /**加载级别：0表示无级别，>0表示要等前面的level加载后才能加载*/
    public var loadLevel:int=0;

    /**资源地址,唯一的,可用于数据绑定*/
    public var url:String;

    /**二进制 存取所有数据*/
    public var byteArray:ByteArray;

    /**已加载的字节数*/
    public var bytesLoaded:uint=0;

    /**资源总大小
     * <p>如果资源是实时流,或大小未知,那麼總大小與<code>bytesLoaded<code>的值一样,会随着下载数据增加而动态增加</p>
     * <p>可用于数据绑定</p>
     */
    public var bytesTotal:uint=0;
    /**请求*/
    public var urlRequest:URLRequest;
    public var resType:String = ResType.MOVIE;
    public var resCt:LoaderContext=null;

    public var content:* ;

    public var onCompleteHandle:Function ;
    public var onErrorHandle:Function ;
    public var onProgressHandle:Function ;
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    public function ResData(_url:String="",_restype:String = "movie",_init:Boolean=false,_loadLevel:uint=0,complete:Function=null,error:Function=null,progress:Function=null)
    {
        url = _url;
        urlRequest = new URLRequest(url);
        resType = _restype;
        init = _init;
        loadLevel = _loadLevel ;
        onCompleteHandle = complete ;
        onErrorHandle = error ;
        onProgressHandle = progress ;
    }

    //--------------------------------------------------------------------------
    //
    //  methods
    //
    //--------------------------------------------------------------------------

    public function dispose():void
    {
        if(byteArray){
            byteArray.clear()
            byteArray = null ;
        }
        DisposeUtil.dispose(content);
        content = null ;
        urlRequest = null;
        onCompleteHandle = null
        onErrorHandle = null ;
        onProgressHandle = null ;
        resCt = null ;
    }
    public function clone():ResData{
        var rd:ResData = new ResData();
        rd.byteArray = byteArray ;
        rd.bytesLoaded = bytesLoaded;
        rd.bytesTotal = bytesTotal ;
        rd.content = content ;
        rd.init = init;
        rd.loadLevel = loadLevel;
        rd.onCompleteHandle = onCompleteHandle ;
        rd.onErrorHandle = onErrorHandle;
        rd.onProgressHandle = onProgressHandle;
        rd.resCt = resCt ;
        rd.resType = resType ;
        rd.state = state ;
        rd.url = url ;
        rd.urlRequest = urlRequest ;
        return rd ;
    }
}

}