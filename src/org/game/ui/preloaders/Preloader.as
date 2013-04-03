/*******************************************************************************
 * Class name:	Preloader.as
 * Description:	
 * Author:		ryancao
 * Create:		Apr 1, 2013 5:11:32 PM
 * Update:		Apr 1, 2013 5:11:32 PM
 ******************************************************************************/
package org.game.ui.preloaders
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	
	import org.game.ui.core.IApplication;
	import org.game.ui.events.PreloadEvent;
	
	
	public class Preloader extends EventDispatcher implements IPreloader
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		private var root:DisplayObject;
		
		private var appPreloader:IApplicationPreloader;
		//--------------------------------------------------------------------------
		//		Propertise
		//--------------------------------------------------------------------------
		private var _view:IPreloaderView
		
		public function get view():IPreloaderView
		{
			return _view;
		}
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function Preloader()
		{
			
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		public function initialize(displayClass:Class, root:DisplayObject):void
		{
			if(displayClass is Class)
				this._view = new displayClass();
			else
				this._view = new DefaultPreLoadView();
			this._view.appLoadStart();
			
			this.root = root;
			root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			root.loaderInfo.addEventListener(Event.COMPLETE, completeHandler);
		}
		
		protected function completeHandler(event:Event):void
		{
			_view.appLoadComplete();
			dispatchEvent(new PreloadEvent(PreloadEvent.PRELOAD_COMPLETE, 100, 100));
		}
		
		protected function progressHandler(event:ProgressEvent):void
		{
			_view.updateAppLoaded(event.bytesLoaded, event.bytesTotal);
		}
		
		public function registerApplication(app:IApplication):void
		{
			if(app.preloader)
			{
				this.appPreloader = app.preloader;
				this.appPreloader.addEventListener(PreloadEvent.HIDE, hideHandler);
				this.appPreloader.addEventListener(PreloadEvent.SHOW, showHandler);
				this.appPreloader.addEventListener(PreloadEvent.APPLICATION_INIT_START, appInitStartHandler);
				this.appPreloader.addEventListener(PreloadEvent.APPLICATION_INIT_PROGRESS, appInitProgressHandler);
				this.appPreloader.addEventListener(PreloadEvent.APPLICATION_COMPLETE, appCreationCompleteHandler);
				
				dispatchEvent(new PreloadEvent(PreloadEvent.APPLICATION_INIT_START));
				
				this.appPreloader.initialize(app);
			}
			else
			{
				dispatchEvent(new PreloadEvent(PreloadEvent.APPLICATION_COMPLETE, 1,1));
			}
		}
		
		private function appCreationCompleteHandler(event:PreloadEvent):void
		{
			_view.appInitComplete();
			dispatchEvent(new PreloadEvent(PreloadEvent.APPLICATION_COMPLETE, 100, 100, event.params));
		}
		
		private function appInitProgressHandler(event:PreloadEvent):void
		{
			_view.updateAppInited(event.progress, event.total, event.params);
		}
		
		private function appInitStartHandler():void
		{
			_view.appInitStart();
		}
		
		private function showHandler(event:PreloadEvent):void
		{
			this.view.visible = true;
		}
		
		private function hideHandler(event:PreloadEvent):void
		{
			this.view.visible = false;
		}
		
		public function dispose():void
		{
			root.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			root.loaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			
			if(this.appPreloader)
			{
				this.appPreloader.removeEventListener(PreloadEvent.APPLICATION_INIT_START, appInitStartHandler);
				this.appPreloader.removeEventListener(PreloadEvent.APPLICATION_INIT_PROGRESS, appInitProgressHandler);
				this.appPreloader.removeEventListener(PreloadEvent.APPLICATION_COMPLETE, appCreationCompleteHandler);
				this.appPreloader.removeEventListener(PreloadEvent.HIDE, hideHandler);
				this.appPreloader.removeEventListener(PreloadEvent.SHOW, showHandler);
			}
		}
		
	}
}