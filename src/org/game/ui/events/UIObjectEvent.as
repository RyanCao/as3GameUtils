/*******************************************************************************
 * Class name:	UIObjectEvent.as
 * Description:	
 * Author:		ryancao
 * Create:		Mar 28, 2013 10:17:06 AM
 * Update:		Mar 28, 2013 10:17:06 AM
 ******************************************************************************/
package org.game.ui.events
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.events.Event;
	
	
	public class UIObjectEvent extends Event
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		/**
		 * 对象添加到舞台并且完成初始化后执行 
		 */	
		public static const ADD:String = "UIObject_Add";
		
		/**
		 * 对象从舞台完全删除后执行 
		 */	
		public static const REMOVE:String = "UIObject_Remove";
		
		/**
		 *  对象创建完毕后执行;
		 */	
		public static const CREATION_COMPLETE:String = "UIObject_CreationComplete";
		
		/**
		 *  对象大小计算完毕;
		 * 只限于 list 和tree
		 */	
		public static const MEASURE_COMPLETE:String = "measureComplete";
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function UIObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
	}
}