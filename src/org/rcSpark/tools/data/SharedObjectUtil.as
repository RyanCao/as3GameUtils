/*******************************************************************************
 * Class name:	SharedUtil.as
 * Description:	
 * Author:		caoqingshan
 * Create:		Sep 4, 2013 1:50:05 PM
 * Update:		Sep 4, 2013 1:50:05 PM
 ******************************************************************************/
package org.rcSpark.tools.data
{
	import flash.net.SharedObject;
	
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	
	public class SharedObjectUtil
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		public static var localName:String = "sscq" ;
		public static var cookieName:String = "sscqCookie" ;
		private static var localData:Object = {};
		private static var cookieData:Object = {};
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function SharedObjectUtil()
		{
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		
		public static function readSharedObject(key:String):*{
			if(localData&&localData[key]!=null)
				return localData[key];
			var _so:SharedObject = SharedObject.getLocal(localName) ;
			return isExist(key) ? _so.data.cookie[key]:null ;
		}
		/**
		 * 永久存取在机器上 
		 * @param key
		 * @param value
		 * @return 
		 * 
		 */		
		public static function saveSharedObject(key:String,value:*):String{
			var _so:SharedObject = SharedObject.getLocal(localName) ;
			if(_so.data.cookie == null){
				_so.data.cookie = {} ;
				_so.flush();
			}
			_so.data.cookie[key] = value ;
			if(localData == null)
				localData = {} ;
			localData[key] = value ;
			return _so.flush();
		}
		
		public static function readCookie(key:String):*{
			var obj:Object ;
			if(cookieData&&cookieData[key]!=null){
				obj = cookieData[key] ;
				if(isTimeout(obj.time,obj.timeOut)){
					delete cookieData[key];
					delete _so.data.cookie[key];
					_so.flush();
					obj = null ;
					return null ;
				}else{
					return obj.value ;
				}
			}
			var _so:SharedObject = SharedObject.getLocal(cookieName) ;
			if(isExistCookie(key)){
				obj = _so.data.cookie[key] ;
				if(isTimeout(obj.time,obj.timeOut)){
					delete _so.data.cookie[key];
					_so.flush();
					obj = null ;
					return null ;
				}else{
					return obj.value ;
				}
			}
			return null ;
		}
		
		/**
		 * 有时间限制的存取在机器上的Cookie
		 * @param key
		 * @param value
		 * @param timeOut
		 * @return 
		 * 
		 */		
		public static function saveCookie(key:String,value:*,timeOut:Number=3600):String{
			var obj:Object = {} ;
			if(!cookieData)
				cookieData = {} ;
			
			var today:Date = new Date();
			obj.time = today.getTime().toString();
			obj.timeOut = timeOut.toString();
			obj.key = key;
			obj.value = value;
			cookieData[key] = obj ;
			
			var _so:SharedObject = SharedObject.getLocal(cookieName) ;
			if(_so.data.cookie == null){
				_so.data.cookie = {} ;
				_so.flush();
			}
			_so.data.cookie[key] = obj ;
			return _so.flush();
		}
		
		private static function isExist(key:String):Boolean{
			var _so:SharedObject = SharedObject.getLocal(localName) ;
			return _so.data.cookie != null && _so.data.cookie[key]!=null ;
		}
		
		private static function isExistCookie(key:String):Boolean{
			var _so:SharedObject = SharedObject.getLocal(cookieName) ;
			return _so.data.cookie != null && _so.data.cookie[key]!=null ;
		}
		
		private static function isTimeout(time:Number,timeOut:Number):Boolean{
			var today:Date = new Date();
			return time + timeOut*1000 < today.getTime();
		}
	}
}