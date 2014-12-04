
package org.rcSpark.tools.cookie
{
import flash.events.NetStatusEvent;
import flash.net.SharedObject;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

/**
 * 
 * @author yu.zhang
 * 
 */
public class CookieLocator implements ICookieLocator
{
	//----------------------------------------- ---------------------------------
    //  	Constructor
    //--------------------------------------------------------------------------
    public function CookieLocator(path:String)
    {
        this.init(path);
    }
	
	//--------------------------------------------------------------------------
    //  	Variabels
    //--------------------------------------------------------------------------
    private var _so:SharedObject;
	
    private var _isAvailable:Boolean = true;
	
	private var flushTimeOut:uint = 0;
	//--------------------------------------------------------------------------
	//  	Propertise
	//--------------------------------------------------------------------------
	
	private var _flushTimeDelay:uint = 0;

	public function get flushTimeDelay():uint
	{
		return _flushTimeDelay;
	}

	public function set flushTimeDelay(value:uint):void
	{
		_flushTimeDelay = value;
	}

    //--------------------------------------------------------------------------
    //  	Init methods
    //--------------------------------------------------------------------------
	private function init(path:String):void
    {
        if(!this._so)
        {
            var availableInSameDomain:String = "/";
            this._so = SharedObject.getLocal(path, availableInSameDomain);
        }
    }
    
    //--------------------------------------------------------------------------
    //  	Public methods
    //--------------------------------------------------------------------------
	/**
	 *  load the data
	 */
	public function read(key:String):CookieVO
	{
		var cookie:CookieVO = new CookieVO();
		var object:Object = this._so.data[key];
		if(!object)
		{
			return null;
		}
		try
		{
			cookie.time = object.time;
			cookie.vo = object.vo;
			if (!object.expireTime)
			{
				cookie.expireTime = -1;
			}
			else
			{
				cookie.expireTime = object.expireTime;
			}
		}
		catch (error:ReferenceError)
		{
			this._so.data[key] = null;
			return null;
		}
		return cookie;
	}
	
	/**
     *  save the data with key.
     */
    public function save(key:String, value:Object, time:Number = -1,
                         expireTime:Number = -1):void
    {
        var cookie:CookieVO = new CookieVO();
        cookie.time = time;
        cookie.vo = value;
        cookie.expireTime = expireTime;
        this._so.data[key] = cookie;
		
		flush();
    }

    

    /**
     *  delete the data
     */
    public function clear(key:String):void
    {
        delete this._so.data[key];
		
		flush();
    }
    
	private function flush():void
	{
		if(this.flushTimeOut > 0)
			clearTimeout(this.flushTimeOut);
		
		if(this.flushTimeDelay > 0)
		{
			this.flushTimeOut = setTimeout($flush, flushTimeDelay);
		}
		else
		{
			$flush();
		}
	}
	
	private function $flush():void
	{
		this.flushTimeOut = 0;
		
		try
		{
			this._so.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			this._so.flush();
		}
		catch(E:Error)
		{
			if(this._so.hasEventListener(NetStatusEvent.NET_STATUS))
			{
				this._so.removeEventListener(
					NetStatusEvent.NET_STATUS, onNetStatus);
			}
			this._isAvailable = false;
		}
	}
    //--------------------------------------------------------------------------
    //  	Event Handler
    //--------------------------------------------------------------------------
    private function onNetStatus(evt:NetStatusEvent):void
    {
        if(evt.info.code == "SharedObject.Flush.Success")
        {
            this._isAvailable = true;
        }
        else if(evt.info.code == "SharedObject.Flush.Failed")
        {
            this._isAvailable = false;
        }
        if(this._so.hasEventListener(NetStatusEvent.NET_STATUS))
        {
            this._so.removeEventListener(
                    NetStatusEvent.NET_STATUS, onNetStatus);
        }
    }
}
}
