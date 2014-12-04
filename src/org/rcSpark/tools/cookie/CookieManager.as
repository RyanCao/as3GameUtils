package org.rcSpark.tools.cookie
{
/**
 * 
 * @author yu.zhang
 * 
 */
public class CookieManager
{
	//--------------------------------------------------------------------------
    //  	Variables
    //--------------------------------------------------------------------------
	private static var cookieList:Array = [];
	
	private static var initialized:Boolean = false;
	//--------------------------------------------------------------------------
	//  	Propertise
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
    //  	Methods
    //--------------------------------------------------------------------------
	/**
	 * 获取一个Icookie对象 
	 */	
	public static function getCookie(cookiePath:String):ICookieLocator
	{
		if(!cookieList[cookiePath])
			cookieList[cookiePath] = new CookieLocator(cookiePath);
		
		return ICookieLocator(cookieList[cookiePath]);
	}
	
	public static function hasCookie(cookiePath:String):Boolean
	{
		if(cookieList[cookiePath] && cookieList[cookiePath] is ICookieLocator)
		{
			return true;
		}
		
		return false;
	}
	/**
	 * 从指定的cookie实例中获取指定key的值; 
	 * 
	 */	
	public static function read(cookiePath:String, key:String):CookieVO
	{
		var cookie:ICookieLocator = getCookie(cookiePath);
		return cookie.read(key);
	}
	
	/**
	 * 保存key值到指定的cookie中 
	 */	
	public static function save(cookiePath:String, key:String, value:Object, time:Number = -1,
                         expireTime:Number = -1):void
	{
		var cookie:ICookieLocator = getCookie(cookiePath);
		cookie.save(key, value, time, expireTime);
	}
	
	public static function clear(cookiePath:String, key:String):void
	{
		var cookie:ICookieLocator = getCookie(cookiePath);
		
		cookie.clear(key);
	}
	
	//--------------------------------------------------------------------------
	//  	Event Handler
	//--------------------------------------------------------------------------
}
}