/*******************************************************************************
 * Class name:	LangControler.as
 * Description:	
 * Author:		ryan
 * Create:		Jan 21, 2013 5:06:56 PM
 * Update:		Jan 21, 2013 5:06:56 PM
 ******************************************************************************/
package org.rcSpark.lang
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import mx.utils.StringUtil;
	
	/**
	 * 语言改变事件
	 * @eventType org.rcSpark.lang.LangEvent:LANG_CHANGED
	 * @see #event:lang_changed
	 */
	[Event(name="lang_changed", type="org.rcSpark.lang.LangEvent")]
	/**
	 * 语言配置完成事件
	 * @eventType org.rcSpark.lang.LangEvent.LANG_CONFIGURED
	 * @see #event:lang_configured
	 */
	[Event(name="lang_configured", type="org.rcSpark.lang.LangEvent")]
	public class LangControler extends EventDispatcher
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		/**
		 * 当前语言类型,可用作绑定
		 * 直接设置无效,必需使用gLocale属性设置
		 */
		private static var currentLocale:String="en_US";
		
		/**
		 * 全局语言文件的目录
		 * @default langTxt
		 */
		private static var _gFileDir:String="../langTxt/";
		
		/**
		 * 语言文件的扩展名
		 * @default txt
		 */
		private static var _gExtension:String="txt";
		
		public static var SPLIT_TXT:String = "=";
		/***
		 * 注释行标志
		 * */
		public static var REMARK_TXT:String = "#";
		
		/**存储所有Language对象,统一处理用*/
		private static var _languageSet:Dictionary=new Dictionary(false);
		
		/**事件转发对象*/
		private static var _eventDispatcher:EventDispatcher=new EventDispatcher();
		
		/**语言文件目录*/
		private var _fileDir:String;
		
		/**语言文件名*/
		private var _fileName:String;
		
		/**当前语言*/
		private var _locale:String;
		
		/**语言文件扩展名*/
		private var _extension:String;
		
		/**加载器*/
		private var _loader:URLLoader;
		
		/**語言值对表,_keySet[key]=String*/
		private var _keySet:Object={};
		
		/**存储所有绑定的对象,_targetSet[target]={prop:KeyData} */
		private var _targetSet:Dictionary=new Dictionary(true);
		
		/**语言文件的路径*/
		private var _path:String;
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		/**
		 * 任何一个参数设置,则该参数对应的属性不再受全局控制,fileName除外
		 * @param fileName 文件名
		 * @param fileDir 目录
		 * @param extension 扩展名
		 * @param locale 语言版本
		 */
		public function LangControler(fileName:String=null, fileDir:String=null, extension:String=null, locale:String=null)
		{
			if (!fileDir || !extension || !locale)
				_languageSet[this]=this;
			if (fileName != null)
				this.fileName=fileName;
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		
		/**
		 * 设置全局的语言版本
		 */
		public static function get gLocale():String
		{
			return currentLocale;
		}
		
		public static function set gLocale(str:String):void
		{
			if (currentLocale == str)
				return;
			currentLocale=str;
			for (var o:*in _languageSet)
			{
				(_languageSet[o] as LangControler).invalidatePath();
			}
			_eventDispatcher.dispatchEvent(new LangEvent(LangEvent.LANG_CHANGED));
		}
		
		/**
		 * 设置全局的语言放置的目录
		 */
		public static function get gFileDir():String
		{
			return _gFileDir;
		}
		
		public static function set gFileDir(str:String):void
		{
			if (_gFileDir == str)
				return;
			_gFileDir=str;
			for (var o:*in _languageSet)
			{
				(_languageSet[o] as LangControler).invalidatePath();
			}
		}
		
		/**
		 * 设置全局的语言扩展名
		 */
		public static function get gExtension():String
		{
			return _gExtension;
		}
		
		public static function set gExtension(str:String):void
		{
			if (_gExtension == str)
				return;
			_gExtension=str;
			for (var o:*in _languageSet)
			{
				(_languageSet[o] as LangControler).invalidatePath();
			}
		}
		
		/**
		 * 语言文件名,不含语言类型
		 */
		public function get fileName():String
		{
			return _fileName;
		}
		
		public function set fileName(value:String):void
		{
			_fileName=value;
			invalidatePath();
		}
		/**
		 * 语言文件目录,默认会返回全局目录,
		 * 一旦设置,就不会再受全局控制
		 */
		public function get fileDir():String
		{
			if (_fileDir == null)
				return LangControler.gFileDir;
			return _fileDir;
		}
		
		public function set fileDir(value:String):void
		{
			if (_fileDir == value)
				return;
			_fileDir=value;
			invalidatePath();
		}
		
		/**
		 * 语言版本,默认为全局版本
		 * 一旦设置,就不会再受全局控制
		 */
		public function get locale():String
		{
			if (_locale == null)
				return LangControler.gLocale;
			return _locale;
		}
		
		public function set locale(value:String):void
		{
			if (_locale == value)
				return;
			_locale=value;
			invalidatePath();
		}
		
		/**
		 * 语言文件扩展名,默认为全局扩展名
		 * 一旦设置,就不会再受全局控制
		 * @return 返回当前的语言版本的扩展名
		 */
		public function get extension():String
		{
			if (_extension == null)
				return LangControler.gExtension;
			return _extension;
		}
		
		public function set extension(value:String):void
		{
			if (_extension == value)
				return;
			_extension=value;
			invalidatePath();
		}
		
		/**
		 * 语言文件路径,一旦设置语言目录,扩展名都不会再受全局控制.
		 * 如果路径中包含语言版本在内,语言版也不再受全局控制
		 * @return 返回当前的语言版本的文件路径
		 */		
		public function get path():String
		{
			if (this.locale)
				return this.fileDir + this.fileName + "_" + this.locale + "." + this.extension;
			else
				return this.fileDir + this.fileName + "." + this.extension;
		}
		
		public function set path(value:String):void
		{
			var i:int=value.lastIndexOf(".");
			var myPath:String=value.slice(0, i);
			_extension=value.slice(i + 1);
			i=Math.max(myPath.lastIndexOf("/"), myPath.lastIndexOf("\\"));
			_fileDir=myPath.slice(0, i) + "/";
			_fileName=myPath.slice(i);
			i=myPath.indexOf("_");
			if (i != -1)
			{
				_locale=_fileName.slice(i);
				_fileName=_fileName.slice(0, i);
			}
			invalidatePath();
		}
		
		/**
		 * 语言文件的值对表
		 */
		public function get keySet():Object
		{
			return _keySet;
		}
		
		/**
		 * 添加全局事件侦听器
		 */
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * 移除全局事件侦听器
		 */
		public static function removeEventListener(type:String, listener:Function):void
		{
			_eventDispatcher.removeEventListener(type, listener);
		}
		
		/**
		 * 把指定的语言移出全局管理
		 */
		public static function removeLangauge(language:LangControler):void
		{
			delete _languageSet[language];
		}
		
		/**
		 * 把目标对象的属性值或方法,绑定到语言文件的指定key上
		 * @param target  目录
		 * @param prop 属性名,如果绑定是方法,则该方法,有且只有一个字符串参数,且prop的值应为方法名加双括号,如果 "gotoAndPlay()"
		 * @param key key
		 * @param args 替换数组
		 */
		public function bind(target:Object, prop:String, key:String, args:Array=null):void
		{
			prop=StringUtil.trim(prop);
			var isFun:Boolean=false;
			if (prop.indexOf("()") != -1)
			{
				isFun=true;
				prop=prop.split("()").join("");
			}
			if (!target.hasOwnProperty(prop))
				return;
			if (!_targetSet[target])
				myTarget=_targetSet[target]={};
			var myTarget:Object=_targetSet[target];
			if (!myTarget[prop])
				myTarget[prop]=new KeyData(prop, key, isFun, args);
			if (isFun)
				target[prop](getText(key, args));
			else
				target[prop]=getText(key, args);
		}
		
		/**
		 * 移除语言绑定,
		 * @param target 移去目标
		 * @param prop 移除目标指定属性的绑定,如果为null,则整个目录绑定都移除
		 */
		public function removeBind(target:Object, prop:String=null):void
		{
			if (prop != null)
			{
				var myTarget:Object=_targetSet[target];
				delete myTarget[prop];
			}
			else
				delete _targetSet[target];
		}
		
		/**
		 * 取得指定key对象的值
		 * @param key key
		 * @param arrs 根据{0} {1}来替换成args里的指定索引处值
		 */
		public function getText(key:String, args:Array=null):String
		{
			var str:String=_keySet[key];
			if (args != null && str != null)
			{
				for (var i:int=0; i < args.length; i++)
				{
					str=str.split("{" + i + "}").join(args[i]);
				}
			}
			return str;
		}
		
		/**
		 * 把对象持有的目录绑定释放,从全局中移除
		 */
		public function distroy():void
		{
			delete _languageSet[this];
			for (var o:*in _targetSet)
			{
				delete _targetSet[o];
			}
		}
		
		/**使语言路径无效,200毫秒后重载*/
		private var _invalidateTimeoutId:int=0;
		
		private function invalidatePath():void
		{
			if (_invalidateTimeoutId == 0)
				_invalidateTimeoutId=setTimeout(updatePath, 200);
		}
		
		/**检查是否需要重载语言文件*/
		private function updatePath():void
		{
			_invalidateTimeoutId=0;
			//如果_fileDir,_extension,_locale都不为null,则表明该实例不再受全局控制,可以从全局中去除,以便没引用时回收
			if (_fileDir && _extension && _locale)
				delete _languageSet[this];
			if (fileName != null)
				loadFile(path);
		}
		
		/**
		 * 加载语言文件
		 */
		private function loadFile(path:String):void
		{
			if (path == _path)
				return;
			if (!_loader)
			{
				_loader=new URLLoader();
				_loader.addEventListener(Event.COMPLETE, completeListener);
			}
			_path=path;
			try
			{
				_loader.load(new URLRequest(_path));
			}
			catch (e:Error)
			{
				
			}
		}
		
		/**
		 * 加载完成事件处理
		 */
		private function completeListener(e:Event):void
		{
			setTextData(_loader.data);
		}
		
		private var UNICODE_CHAR:RegExp = /\\u[A-F0-9]{4}/gi;
		/**
		 * sdk4执行的带"\"的正则表达式和sdk3.x执行结果不一样，暂时不做处理
		 */
		public function setTextData(data:String):void
		{
			var arr:Array=data.split("\r").join("").split("\n");
			for (var i:int=0; i < arr.length; i++)
			{
				var line:String=arr[i];
				//#开头为注释,不作处理
				if (line.indexOf(LangControler.REMARK_TXT) != 0)
				{
					var items:Array=line.split(LangControler.SPLIT_TXT);
					var key:String=items[0];
					var value:String=items[1];
					//是否为合法的值对,没有值则不处理
					if (value != null)
					{
						var tmpKey:String = StringUtil.trim(key);
						_keySet[tmpKey] = value;
					}
				}
			}
			for (var o:Object in _targetSet)
			{
				var target:Object=_targetSet[o];
				for (var p:Object in target)
				{
					var keyData:KeyData=target[p];
					if (o.hasOwnProperty(keyData.prop))
					{
						if (keyData.isFun)
							o[keyData.prop](getText(keyData.key, keyData.args));
						else
							o[keyData.prop]=getText(keyData.key, keyData.args);
					}
				}
			}
			dispatchEvent(new LangEvent(LangEvent.LANG_CHANGED));
		}
		
		/**
		 * 把语言文件的格式替换成可读格式
		 */
		private function replaceStr():String
		{
			var c:String=arguments[0];
			c=c.slice(2);
			var num:Number=Number("0x" + c);
			if (!isNaN(num))
				c=String.fromCharCode(num);
			return c;
		}
		public static function allConfigured():void
		{
			_eventDispatcher.dispatchEvent(new LangEvent(LangEvent.LANG_CONFIGURED));
		}
	}
}