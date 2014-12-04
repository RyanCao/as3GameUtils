
package org.rcSpark.tools.cookie
{
public interface ICookieLocator
{
    //==========================================================================
    //  Public methods
    //==========================================================================
    function save(key:String, value:Object, time:Number = -1,
                  expireTime:Number = -1):void;
	
    function read(key:String):CookieVO;
	
    function clear(key:String):void;
}
}