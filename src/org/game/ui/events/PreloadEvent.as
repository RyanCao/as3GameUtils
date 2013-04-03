/*******************************************************************************
 * Class name:	PreloadEvent.as
 * Description:	
 * Author:		ryancao
 * Create:		Apr 1, 2013 5:11:50 PM
 * Update:		Apr 1, 2013 5:11:50 PM
 ******************************************************************************/
package org.game.ui.events
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.events.Event;
	
	
	public class PreloadEvent extends Event
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		/**
		 * 指示应用程序开始加载
		 **/
		public static const PRELOAD_START:String = "preloadStart";
		
		/**
		 * 指示应用程序加载进度
		 */
		public static const PRELOAD_PROGRESS:String = "preloadProgress";
		
		/**
		 * 指示应用程序已加载完毕 
		 */	
		public static const PRELOAD_COMPLETE:String = "preloadComplete";
		
		/**
		 * 指示应用程序开始初始化 
		 */	
		public static const APPLICATION_INIT_START:String = "applicationInitStart";
		
		/**
		 * 指示应用程序初始化的进度
		 */	
		public static const APPLICATION_INIT_PROGRESS:String = "applicationInitProgress";
		
		/**
		 * 指示应用程序初始化完毕，通知移除加载显示并显示主应用程序 
		 */	
		public static const APPLICATION_COMPLETE:String = "applicationComplete";
		
		/**
		 * 指示加载页面暂时隐藏;
		 */
		public static const HIDE:String = "hide";
		
		/**
		 * 指示加载页面显示;
		 */
		public static const SHOW:String = "show";
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function PreloadEvent(type:String, progress:Number = 0, total:Number = 0, params:Object = null)
		{
			super(type,false,false);
			this._progress = progress;
			this._total = total;
			this._params = params;
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		private var _progress:Number;
		private var _total:Number;
		private var _params:Object;

		public function get params():Object
		{
			return _params;
		}

		public function get total():Number
		{
			return _total;
		}

		public function get progress():Number
		{
			return _progress;
		}

	}
}