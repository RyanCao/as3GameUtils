/*******************************************************************************
 * Class name:	LangManager.as
 * Description:	提供一个语言文件对应一个或多个静态类的绑定,每个语言文件里的key与静态类的属性名绑定,同名绑定
 * Author:		ryan
 * Create:		Jan 21, 2013 5:58:24 PM
 * Update:		Jan 21, 2013 5:58:24 PM
 ******************************************************************************/
package org.rcSpark.lang
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 提供一个语言文件对应一个或多个静态类的绑定,每个语言文件里的key与静态类的属性名绑定,同名绑定
	 */
	public class LangManager extends EventDispatcher
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		/**
		 * 以语言文件名为Key存放目标对象,一个语言包对应该多个目标
		 */
		private var langSet:Object={};
		private var totalLoad:Number = 0;
		private var totalLoaded:Number = 0;
		
		private static var _langManager:LangManager;
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function LangManager(target:IEventDispatcher=null)
		{
			super(target);
			LangControler.addEventListener(LangEvent.LANG_CHANGED,localLangChanged);
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		[Bindable(event="localeChange")]		
		public function set locale(str:String):void
		{
			LangControler.gLocale=str;
		}
		/**
		 * 该属性可用数据绑定源
		 * <p>与LangControler.gFileDir效果一样</p>
		 */
		public function get locale():String
		{
			return LangControler.gLocale;
		}
		
		/**
		 * 设置全局的语言放置的目录
		 * 与LangControler.gFileDir一样
		 */
		public function set fileDir(str:String):void
		{
			LangControler.gFileDir=str;
		}
		
		public function get fileDir():String
		{
			return LangControler.gFileDir;
		}
		
		/**
		 * 设置全局的语言扩展名
		 *
		 */
		public function set extension(str:String):void
		{
			LangControler.gExtension=str;
		}
		
		public function get extension():String
		{
			return LangControler.gExtension;
		}
		public function get langSets():Object
		{
			return langSet;
		}
		/***
		 * 获取单例
		 */
		public static function getInstance():LangManager
		{
			if (!_langManager)
				_langManager=new LangManager();
			return _langManager;
		}
		private function localLangChanged(evt:LangEvent):void
		{
			this.dispatchEvent(new LangEvent(LangEvent.LOCAL_CHANGED));
		}
		
		/**
		 * 把一个静态类国际化
		 * @param target 绑定的静态类
		 * @param fileName 绑定语言文件,如果为null则跟target类名相同
		 * @return Language
		 */
		public function add(target:Object, fileName:String=null):LangControler
		{
			if (fileName == null)
			{
				fileName=getQualifiedClassName(target);
				fileName=fileName.slice(fileName.lastIndexOf(":") + 1);
			}
			
			var langObj:LangObj=langSet[fileName];
			var langControler:LangControler;
			if (langObj == null)
			{
				langControler = new LangControler();
				langControler.fileName=fileName;
				langControler.addEventListener(LangEvent.LANG_CHANGED, changeHandler);
				langObj=new LangObj();
				langObj.langControler=langControler;
				langSet[fileName]=langObj;
			}
			else
				setText(target, langObj.langControler);
			langObj.targetSet[target]=langControler;
			return langObj.langControler;
		}
		/**
		 * 如果资源以zip包的形式加载进来，则直接设置以ByteArray的形式设置数据 
		 * @param target
		 * @param data
		 * @return 
		 * 
		 */		
		public function setData(target:Object,data:ByteArray):*
		{
			var className:String = getQualifiedClassName(target);
			className=className.slice(className.lastIndexOf(":") + 1);
			
			var langObj:LangObj=langSet[className];
			var langControler:LangControler = new LangControler();
			
			langControler.setTextData(data.readMultiByte(data.bytesAvailable,"utf-8"));
			//langControler.addEventListener(LangChangeEvent.LANG_CHANGED, changeHandler);
			
			langObj=new LangObj();
			langObj.langControler=langControler;
			langSet[className]=langObj;
			langObj.targetSet[target]=langControler;
			for (var o:*in langObj.targetSet)
			{
				totalLoad++;
				setText(o, langControler);
			}
			
			return langObj.langControler;
		}
		/**
		 * 语言版本改变事件处理
		 */
		private function changeHandler(event:Event):void
		{
			var language:LangControler=event.target as LangControler;
			var fileName:String=language.fileName;
			var langObj:LangObj=langSet[fileName];
			for (var o:*in langObj.targetSet)
			{
				totalLoad++;
				setText(o, language);
			}
		}
		
		/**
		 * 移除一个类的国际化绑定
		 * @param target 静态类
		 * @param fileName 语言文件
		 */
		public function remove(target:Object, fileName:String=null):void
		{
			if (fileName == null)
			{
				fileName=getQualifiedClassName(target);
				fileName=fileName.slice(fileName.lastIndexOf(":") + 1);
			}
			var langObj:LangObj=langSet[fileName];
			if (langObj == null)
				return;
			delete langObj.targetSet[target];
		}
		
		/**
		 * 把语言包设为地象属性,可以递到对象内的属性对象里的对象
		 */
		private function setText(target:Object, language:LangControler):void
		{
			totalLoaded++;
			for (var i:String in language.keySet)
			{
				//key包含.时,则设置对象里面的对象的属性
				var pop:Array=i.split(".");
				var o:Object=target;
				for (var j:int=0; j < (pop.length - 1); j++)
				{
					if (!o.hasOwnProperty(pop[j]))
						break;
					o=o[pop[j]];
				}
				if (!o.hasOwnProperty(pop[pop.length - 1]))
				{
					trace("##" + o + "has not property :" + pop[pop.length - 1]);
					continue;
				}
				o[pop[pop.length - 1]]=language.getText(i);
			}
			if(totalLoad == totalLoaded)
			{
				totalLoad = 0;
				totalLoaded = 0;
				LangControler.allConfigured();
			}
		}
	}
}