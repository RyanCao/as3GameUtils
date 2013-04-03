/*******************************************************************************
 * Class name:	ToolTipManagerImpl.as
 * Description:	
 * Author:		ryancao
 * Create:		Mar 27, 2013 5:46:16 PM
 * Update:		Mar 27, 2013 5:46:16 PM
 ******************************************************************************/
package org.game.ui.managers
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import org.game.gameant;
	import org.game.ui.core.IToolTip;
	import org.game.ui.core.IUIInterfaces;
	
	use namespace gameant ;
	public class ToolTipManagerImpl implements IToolTipManager
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function ToolTipManagerImpl()
		{
		}
		
		public function get currentTarget():DisplayObject
		{
			return null;
		}
		
		public function set currentTarget(value:DisplayObject):void
		{
		}
		
		public function get currentToolTip():IToolTip
		{
			return null;
		}
		
		public function set currentToolTip(value:IToolTip):void
		{
		}
		
		public function get enabled():Boolean
		{
			return false;
		}
		
		public function set enabled(value:Boolean):void
		{
		}
		
		public function get hideDelay():Number
		{
			return 0;
		}
		
		public function set hideDelay(value:Number):void
		{
		}
		
		public function get scrubDelay():Number
		{
			return 0;
		}
		
		public function set scrubDelay(value:Number):void
		{
		}
		
		public function get showDelay():Number
		{
			return 0;
		}
		
		public function set showDelay(value:Number):void
		{
		}
		
		public function get toolTipClass():Class
		{
			return null;
		}
		
		public function set toolTipClass(value:Class):void
		{
		}
		
		public function registerToolTip(target:DisplayObject, oldToolTip:IToolTipData, newToolTip:IToolTipData):void
		{
		}
		
		public function registerErrorString(target:DisplayObject, oldErrorString:IToolTipData, newErrorString:IToolTipData):void
		{
		}
		
		public function sizeTip(toolTip:IToolTip):void
		{
		}
		
		public function createToolTip(data:IToolTipData, errorTipBorderStyle:String=null, context:IUIInterfaces=null):IToolTip
		{
			return null;
		}
		
		public function destroyToolTip(toolTip:IToolTip):void
		{
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		
	}
}