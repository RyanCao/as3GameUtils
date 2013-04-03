/*******************************************************************************
 * Class name:	SystemManager.as
 * Description:	
 * Author:		ryancao
 * Create:		Mar 29, 2013 12:38:34 PM
 * Update:		Mar 29, 2013 12:38:34 PM
 ******************************************************************************/
package org.game.ui.managers
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import org.game.gameant;
	import org.game.ui.core.BaseUI;
	import org.game.ui.core.IApplication;
	import org.game.ui.core.IChildList;
	import org.game.ui.core.IUIInterfaces;
	import org.game.ui.events.PreloadEvent;
	import org.game.ui.preloaders.IPreloader;
	import org.game.ui.preloaders.Preloader;
	
	use namespace gameant ;
	public class SystemManager extends MovieClip implements ISystemManager
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		private var isStageRoot:Boolean = false ;
		/**
		 * 是否为顶级管理者 
		 */	
		gameant var topLevel:Boolean = true;
		
		/**
		 * 是否可以发布 
		 */	
		private var readyForKickOff:Boolean = false;
		
		private var _width:int;
		private var _height:int;
		
		/**
		 *  @private
		 *  第一级视窗.
		 */
		gameant var topLevelWindow:BaseUI;
		
		gameant var preloader:IPreloader;
		gameant var nextFrameTimer:Timer;
		public var preloaderDisplayClass:Class;
		
		/**
		 * 文档类 
		 */	
		private var _document:Object;
		//------------------------------
		//		documentClassName
		//------------------------------
		protected var _documentClassName:String = "bbb";
		
		private var mouseCatcher:Sprite;
		private var noTopMostIndex:int;
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function SystemManager()
		{
			super();
			//设置舞台属性
			if (stage)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				stage.quality = StageQuality.HIGH;
			}
			
			//temp: 这里的写法暂不支持多级SystemManger;
			if (!stage)
				isStageRoot = false;
			
			stop();
			
			if(root && root.loaderInfo)
			{
				root.loaderInfo.addEventListener(Event.INIT, loaderInfoInitHandler);
			}
			SystemManagerGlobals.topLevelSystemManager = this;
		}
		
		protected function loaderInfoInitHandler(event:Event):void
		{
			root.loaderInfo.removeEventListener(Event.INIT, loaderInfoInitHandler);
			SystemManagerGlobals.url = root.loaderInfo.url;
			//addEventListener(Event.ENTER_FRAME, docFrameListener);
			initialize();
		}
		
		protected function initialize():void
		{
			if (isStageRoot) 
			{ 
				_width = stage.stageWidth;
				_height = stage.stageHeight;
			}
			else
			{
				_width = loaderInfo.width;
				_height = loaderInfo.height;
			}
			
			preloader = new Preloader();
			
			preloader.addEventListener(PreloadEvent.PRELOAD_COMPLETE, 
				preloadCompleteHandler);
			preloader.addEventListener(PreloadEvent.APPLICATION_COMPLETE, 
				applicationCompleteHandler);
			preloader.initialize(preloaderDisplayClass, this);
		}
		
		protected function applicationCompleteHandler(event:PreloadEvent):void
		{
			if(currentFrame < 2)
			{
				nextFrame();
			}
			
			var app:IUIInterfaces = topLevelWindow;
			app.initialize();
			
			removePreloadEventHandlers();
			
			preloader.dispose();
			preloader = null;
			
			// 添加鼠标检测层在最底
			mouseCatcher = new Sprite();
			mouseCatcher.cacheAsBitmap = true;
			mouseCatcher.name = "mouseCatcher";
			
			noTopMostIndex++;
			
			super.addChildAt(mouseCatcher, 0);
			
			if (!topLevel)
			{
				mouseCatcher.visible = false;
				mask = mouseCatcher;
			}
			
			// 将主应用程序添加到索引1;
			noTopMostIndex++;
			super.addChildAt(DisplayObject(app), 1);
		}
		
		private function removePreloadEventHandlers():void
		{
			preloader.removeEventListener(PreloadEvent.PRELOAD_COMPLETE, 
				preloadCompleteHandler);
			preloader.removeEventListener(PreloadEvent.APPLICATION_COMPLETE, 
				applicationCompleteHandler);
		}
		
		protected function preloadCompleteHandler(event:PreloadEvent):void
		{
			preloader.removeEventListener(PreloadEvent.PRELOAD_COMPLETE, 
				preloadCompleteHandler);
			readyForKickOff = true;
			
			deferredNextFrame();
			
			if (currentFrame >= 2)
				kickOff();
		}
		
		/**
		 *  @private
		 */
		private function deferredNextFrame():void
		{
			if (currentFrame + 1 > totalFrames)
				return;
			
			if (currentFrame + 1 <= framesLoaded)
			{
				nextFrame();
			}
			else
			{
				nextFrameTimer = new Timer(100);
				nextFrameTimer.addEventListener(TimerEvent.TIMER,
					nextFrameTimerHandler);
				nextFrameTimer.start();
			}
		}
		
		protected function nextFrameTimerHandler(event:TimerEvent):void
		{
			if (currentFrame + 1 <= framesLoaded)
			{
				nextFrame();
				nextFrameTimer.removeEventListener(TimerEvent.TIMER, 
					nextFrameTimerHandler);
				nextFrameTimer.reset();
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */	
		private function docFrameListener(event:Event):void
		{
			if (currentFrame == 2)
			{
				removeEventListener(Event.ENTER_FRAME, docFrameListener);
				docFrameHandler();
			}
		}
		
		gameant function docFrameHandler(event:Event = null):void
		{
			if (readyForKickOff)
				kickOff();
		}
		
		gameant function kickOff():void
		{
			if(document)
				return;
			//Get and init the application
			this.document = topLevelWindow = BaseUI(create());
			BaseUI(topLevelWindow).systemManager = this;
			preloader.registerApplication(IApplication(topLevelWindow));
//			this.childManager = ISystemManagerChildManager(new ChildManager(this));
		}
		
		
		/**
		 * 默认的文档类类名 
		 */
		public function get documentClassName():String
		{
			return _documentClassName;
		}
		
		/**
		 * @private
		 */
		public function set documentClassName(value:String):void
		{
			_documentClassName = value;
		}
		
		/**
		 * 创建主应用程序 
		 * @param params
		 * @return 
		 * 
		 */	
		public function create(... params):Object
		{
			var mainClassName:String = documentClassName;
			var mainClass:Class;
			
			if(documentClassName)
			{
				try
				{
					mainClass = getDefinitionByName(documentClassName) as Class;
				}
				catch(e:Error)
				{
					//当检测不到默认名称时，确保不要报错。
				}
			}
			
			if(mainClass == null)
			{
				try
				{
					mainClass = getDefinitionByName(this.currentFrameLabel) as Class;
				}
				catch(e:Error)
				{
					//当检测不到默认名称时，确保不要报错。
				}
			}
			
			if (mainClass == null)
			{
				var pattern:RegExp = /\\/g;
				var url:String = loaderInfo.loaderURL.replace(pattern, "/");
				var dot:int = url.lastIndexOf(".swf");
				var slash:int = url.lastIndexOf("/");
				mainClassName = url.substring(slash + 1, dot);
				mainClass = Class(getDefinitionByName(decodeURI(mainClassName)));
			}
			
			return mainClass ? new mainClass() : null;
		}
		
		public function get cursorChildren():IChildList
		{
			return null;
		}
		
		public function get document():Object
		{
			return _document;
		}
		
		public function set document(value:Object):void
		{
			_document = value ;
		}
		
		public function get embeddedFontList():Object
		{
			return null;
		}
		
		public function get focusPane():Sprite
		{
			return null;
		}
		
		public function set focusPane(value:Sprite):void
		{
		}
		
		public function get isProxy():Boolean
		{
			return false;
		}
		
		public function get numModalWindows():int
		{
			return 0;
		}
		
		public function set numModalWindows(value:int):void
		{
		}
		
		public function get popUpChildren():IChildList
		{
			return null;
		}
		
		public function get screen():Rectangle
		{
			return null;
		}
		
		public function get toolTipChildren():IChildList
		{
			return null;
		}
		
		public function get topLevelSystemManager():ISystemManager
		{
			return this;
		}
		
		public function isTopLevel():Boolean
		{
			return false;
		}
		
		public function isFontFaceEmbedded(tf:TextFormat):Boolean
		{
			return false;
		}
		
		public function isTopLevelRoot():Boolean
		{
			return false;
		}
		
		public function getTopLevelRoot():DisplayObject
		{
			return null;
		}
		
		public function getSandboxRoot():DisplayObject
		{
			return null;
		}
		
		public function getVisibleApplicationRect(bounds:Rectangle=null, skipToSandboxRoot:Boolean=false):Rectangle
		{
			return null;
		}
		
		public function deployMouseShields(deploy:Boolean):void
		{
		}
		
		public function invalidateParentSizeAndDisplayList():void
		{
			
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
	}
}