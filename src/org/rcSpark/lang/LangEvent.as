/*******************************************************************************
 * Class name:	LangEvent.as
 * Description:	语言包触发事件
 * Author:		ryan
 * Create:		Jan 21, 2013 5:04:35 PM
 * Update:		Jan 21, 2013 5:04:35 PM
 ******************************************************************************/
package org.rcSpark.lang
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.events.Event;
	
	
	public class LangEvent extends Event
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		/**
		 * 语言已改变
		 */		
		public static const LANG_CHANGED:String = "lang_changed";
		/**
		 * 本地语言改变事件 
		 */		
		public static const LOCAL_CHANGED:String = "local_changed";
		/**
		 * 语言文件配置完成 
		 */		
		public static const LANG_CONFIGURED:String = "lang_configured";
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function LangEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
	}
}