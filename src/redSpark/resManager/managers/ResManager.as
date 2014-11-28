/*******************************************************************************
 * Class name:	ResManager.as
 * Description:	使用說明:<br>
 * Example:	<code>
 var urlData :ResData  = new ResData(url);
 CResManager.instance().rcant::load(urlData.resType, urlData.url, urlData.loadLevel, null, loadResComplete, null, onLoaderError,true,false);

 參數說明： type 加載類型    url 加載文件地址  loadlevel 加載文件加載優先級   ct 加載文件加載的域
 onCompleteHandle 加載成功函數   onProgressHandle  加載進度函數  onErrorHandle  加載出錯函數
 init 加載成功以後是否初始化 默認是二進制文件  ,isNew 加載成功以後是否新建一個實例

 onCompleteHandle： isNew 為否的時候用這個
 mc = (ResManager.getInstance().getResByUrl(_url));
 isNew 為真的時候用這個
 mc = evt.res.content ;
 </code>
 * Author:		ryancao
 * Create:		Sep 19, 2012 11:52:42 AM
 * Update:		Sep 19, 2012 11:52:42 AM
 ******************************************************************************/
package redSpark.resManager.managers
{
import flash.system.LoaderContext;

import org.rcSpark.rcant;
import org.rcSpark.resManager.data.ResType;
import org.rcSpark.resManager.manager.NewResManager;
import org.rcSpark.tools.debug.JSLogger;
import org.rcSpark.tools.file.SharedObjectFileUtil;

//-----------------------------------------------------------------------------
// import_declaration
//-----------------------------------------------------------------------------

public final class ResManager
{
    //-----------------------------------------------------------------------------
    // Var
    //-----------------------------------------------------------------------------
    private static var _instace:ResManager ;
    //-----------------------------------------------------------------------------
    // Constructor
    //-----------------------------------------------------------------------------
    public function ResManager()
    {
        SharedObjectFileUtil.initIndex("sscq");

        NewResManager.ilog = JSLogger.instance();
        NewResManager.MAX_THREAD = 1 ;
        NewResManager.OVER_LOOK = true ;
        NewResManager.OVER_TIME = 6 ;
        NewResManager.TRACE_FLAG = true ;
        NewResManager.READ_LOACL_FILE = true ;
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
    public function getResByUrl(value:String,type:String="movie"):*
    {
        return NewResManager.instance().getResByUrl(value,type);
    }

    public function loadMovie(url:Object, loadLevel:int=0, ct:LoaderContext=null,
                              onCompleteHandle:Function=null, onProgressHandle:Function=null,
                              onErrorHandle:Function=null,init:Boolean = true,isNew:Boolean=true,
                              isSave:Boolean=false):void
    {
        NewResManager.instance().rcant::load(ResType.MOVIE,url,loadLevel,ct,onCompleteHandle,onProgressHandle,
                onErrorHandle,init,isNew,isSave);
    }

    public function loadText(url:Object, loadLevel:int=0, ct:LoaderContext=null,
                             onCompleteHandle:Function=null, onProgressHandle:Function=null,
                             onErrorHandle:Function=null,init:Boolean = true,isSave:Boolean=false):void
    {
        NewResManager.instance().rcant::load(ResType.TEXT,url,loadLevel,ct,onCompleteHandle,onProgressHandle,
                onErrorHandle,init,false,isSave);
    }

    public function loadBinary(url:Object, loadLevel:int=0, ct:LoaderContext=null,
                               onCompleteHandle:Function=null, onProgressHandle:Function=null,
                               onErrorHandle:Function=null,isSave:Boolean=false):void
    {
        NewResManager.instance().rcant::load(ResType.BINARY,url,loadLevel,ct,onCompleteHandle,onProgressHandle,
                onErrorHandle,false,false,isSave);
    }

    public function load(type:String, url:Object, loadLevel:int=0, ct:LoaderContext=null,
                         onCompleteHandle:Function=null, onProgressHandle:Function=null,
                         onErrorHandle:Function=null,init:Boolean = true,isNew:Boolean=true,
                         isSave:Boolean=false):void
    {
        NewResManager.instance().rcant::load(type,url,loadLevel,ct,onCompleteHandle,onProgressHandle,
                onErrorHandle,init,isNew,isSave);
    }

    public function unload(url:String):void
    {
        // TODO Auto Generated method stub

    }

    public function unloadAll():void
    {
        NewResManager.instance().memoryClean();
    }
}
}