/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.tools.data
{
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	
	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	
	/****
	 * SharedObjectUtil.as class. Created Jan 11, 2013 6:16:35 PM
	 * <br>
	 * Description:SharedObjectUtil.getInstance("abc").getData(key);
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/   	 
	public class SharedObjectUtil
	{		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		public static var list:Dictionary = new Dictionary();
		
		public var name:String;
		private var _so:SharedObject;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function SharedObjectUtil(key:String, _arg2:Singleton)
		{
			if (!_arg2){
				throw (new TypeError("SharedObjectUtil.getInstance"));
			};
			this.name = key;
			this._so = this.createSO();
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		public static function getInstance(key:String):SharedObjectUtil{
			if (list[key])
				return (list[key] as SharedObjectUtil);
			var soUtil:SharedObjectUtil = new SharedObjectUtil(key, new Singleton());
			list[key] = soUtil;
			return soUtil;
		}
		
		private function createSO():SharedObject{
			return SharedObject.getLocal(this.name);
		}
		
		/**
		 * ShareObject存数据 
		 * @param dataObj  	数据
		 * @param key		Key
		 * 
		 */		
		public function save(dataObj:Object, key:String=""):void{
			var _key:String;
			if (key){
				_key = key;
				this._so.data[_key] = dataObj;
			} else {
				_key = ("auto_save_" + this.list().length);
				this._so.data[_key] = dataObj;
			}
			this.flush();
		}
		
		/**
		 * 请求最小缓存空间 
		 * @param minDiskSpace
		 * @return 
		 * 
		 */		
		public function flush(minDiskSpace:int=0):String{
			return _so.flush(minDiskSpace);
		}
		/**
		 * 获取 数据 
		 * @param key
		 * @return 
		 * 
		 */		
		public function getData(key:String):Object{
			return this._so.data[key];
		}
		/**
		 * 删除数据 
		 * @param key 键值
		 * 
		 */		
		public function del(key:String):void{
			delete this._so.data[key];
		}
		/**
		 * 清空 缓存 
		 */		
		public function clear():void{
			this._so.clear();
		}
		/**
		 * 用Array取出全部SharedObject数据  
		 * @return 
		 * 
		 */		
		public function list():Array{
			var key:String;
			var rArrs:Array = [];
			for (key in this._so.data) {
				rArrs.push({name:key,value:this._so.data[key]});
			}
			return rArrs;
		}
	}
}

class Singleton {
	
	public function Singleton(){
	}
}