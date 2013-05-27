/*******************************************************************************
 * Class name:	ToolTipManager.as
 * Description:	
 * Author:		ryancao
 * Create:		Mar 27, 2013 5:44:28 PM
 * Update:		Mar 27, 2013 5:44:28 PM
 ******************************************************************************/
package org.game.ui.managers
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.display.DisplayObject;
	
	import org.game.ui.core.IToolTip;
	import org.game.ui.core.IUIInterfaces;
	
	
	public class ToolTipManager implements IToolTipManager
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		private static var __impl:IToolTipManager;
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function ToolTipManager()
		{
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		public static function get impl():IToolTipManager
		{
			if(!__impl)
				__impl = new ToolTipManagerImpl();
			return __impl;
		}
		
		public function get currentTarget():DisplayObject
		{
			return impl.currentTarget;
		}
		
		public function set currentTarget(value:DisplayObject):void
		{
			impl.currentTarget = value ;
		}
		
		public function get currentToolTip():IToolTip
		{
			return impl.currentToolTip;
		}
		
		public function set currentToolTip(value:IToolTip):void
		{
			impl.currentToolTip = value ;
		}
		
		public function get enabled():Boolean
		{
			return impl.enabled ;
		}
		
		public function set enabled(value:Boolean):void
		{
			impl.enabled = value ;
		}
		
		public function get hideDelay():Number
		{
			return impl.hideDelay;
		}
		
		public function set hideDelay(value:Number):void
		{
			impl.hideDelay = value ;
		}
		
		public function get scrubDelay():Number
		{
			return impl.scrubDelay;
		}
		
		public function set scrubDelay(value:Number):void
		{
			impl.scrubDelay = value ;
		}
		
		public function get showDelay():Number
		{
			return impl.showDelay ;
		}
		
		public function set showDelay(value:Number):void
		{
			impl.showDelay = value ;
		}
		
		public function get toolTipClass():Class
		{
			return impl.toolTipClass; 
		}
		
		public function set toolTipClass(value:Class):void
		{
			impl.toolTipClass = value ;
		}
		
		public function registerToolTip(target:DisplayObject, oldToolTip:IToolTipData, newToolTip:IToolTipData):void
		{
			impl.registerToolTip(target, oldToolTip,newToolTip) ;
		}
		
		public function registerErrorString(target:DisplayObject, oldErrorString:IToolTipData, newErrorString:IToolTipData):void
		{
			impl.registerErrorString(target, oldErrorString,newErrorString) ;
		}
		
		public function sizeTip(toolTip:IToolTip):void
		{
			impl.sizeTip(toolTip);
		}
		
		public function createToolTip(data:IToolTipData, errorTipBorderStyle:String=null, context:IUIInterfaces=null):IToolTip
		{
			return impl.createToolTip(data,errorTipBorderStyle,context);
		}
		
		public function destroyToolTip(toolTip:IToolTip):void
		{
			impl.destroyToolTip(toolTip);
		}
		
		public static function registerToolTip(target:DisplayObject, oldToolTip:IToolTipData, newToolTip:IToolTipData):void
		{
			impl.registerToolTip(target, oldToolTip,newToolTip) ;
		}
		
		public static function registerErrorString(target:DisplayObject, oldErrorString:IToolTipData, newErrorString:IToolTipData):void
		{
			impl.registerErrorString(target, oldErrorString,newErrorString) ;
		}
		
		public static function sizeTip(toolTip:IToolTip):void
		{
			impl.sizeTip(toolTip);
		}
		
		public static function createToolTip(data:IToolTipData, errorTipBorderStyle:String=null, context:IUIInterfaces=null):IToolTip
		{
			return impl.createToolTip(data,errorTipBorderStyle,context);
		}
		
		public static function destroyToolTip(toolTip:IToolTip):void
		{
			impl.destroyToolTip(toolTip);
		}
	}
}