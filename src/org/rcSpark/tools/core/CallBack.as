/*******************************************************************************
 * Class name:	CallBack.as
 * Description:	
 * Author:		ryancao
 * Create:		Jul 31, 2013 5:49:23 PM
 * Update:		Jul 31, 2013 5:49:23 PM
 ******************************************************************************/
package org.rcSpark.tools.core
{
	import flash.utils.Dictionary;
	
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	
	public class CallBack implements ICallBack
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		private var funcDic:Dictionary;
		
		//类型是全局共享记录的
		private static var allType:Vector.<String>;
		private static var funcCount:int = 0;
		private static var counter:Dictionary = new Dictionary();
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function CallBack()
		{
			funcDic = new Dictionary();
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		public function addCallback(type:String, func:Function):void
		{
			if(!funcDic[type]){
				funcDic[type] = new Vector.<Function>();
			}
			if(!allType){
				allType = new Vector.<String>;
			}
			
			if(!counter[type]){
				counter[type] = {};
				counter[type].num = 0;
				if(allType.indexOf(type)==-1)
					allType.push(type);
			}
			
			if(funcDic[type].indexOf(func)==-1){
				counter[type].num += 1;		
				funcCount += 1;
				funcDic[type].push(func);
			}
		}
		
		public function removeCallback(type:String, func:Function):void
		{
			if(!funcDic[type])
				return ;
			var idx:int = (funcDic[type] as Vector.<Function>).indexOf(func);
			if(idx<0)
				return ;
			
			//如果在数组里能找到相应的方法，就把它从数组中删除
			(funcDic[type] as Vector.<Function>).splice(idx,1);
			funcCount -= 1;
			
			if(counter[type].num > 0){
				counter[type].num -= 1;
				if(counter[type].num == 0){
					delete counter[type];
					idx = allType.indexOf(type);
					if(idx >= 0){
						allType.splice(idx,1);
					}
				}
			}
			
			//如果相应类型的回调已经删除干净，把相应的键也删了
			if(funcDic[type].length == 0){
				delete funcDic[type];
			}
		}
		
		public function dispose():void
		{
			funcDic = null ;
		}
		
		/**
		 *得到所有已经被注册的回调类型 
		 * @return 
		 * 
		 */		
		public static function getTypes():Vector.<String>{
			return allType;
		}
		/**
		 *得到所有已经被注册的回调方法数量 
		 * @return 
		 * 
		 */		
		public static function getFunctionCount():int{
			return funcCount;
		}
		
		/**
		 *得到注册的回调明细信息 
		 */		
		public static function getDetail():void{
			if(allType){
				for each(var obj:String in allType){
					trace(obj+":"+counter[obj].num);
				}
				if(allType.length == 0){
					trace("啥都没");
				}
			}else{
				trace("啥都没");
			}
		}
		
		/**
		 *发出事件 
		 * @param type 回调类型
		 * @param data 事件携带的数据
		 * 
		 */		
		public function dispatch(type:String, data:Object=null):void
		{
			if(funcDic[type]){
				for each(var func:Function in funcDic[type]){
					func(data);
				}
			}
			getDetail();
		}
	}
}