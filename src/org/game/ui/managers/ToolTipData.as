/*******************************************************************************
 * Class name:	ToolTipData.as
 * Description:	
 * Author:		ryancao
 * Create:		Apr 9, 2013 4:40:34 PM
 * Update:		Apr 9, 2013 4:40:34 PM
 ******************************************************************************/
package org.game.ui.managers
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.geom.Point;
	
	
	public class ToolTipData implements IToolTipData
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		private var _data:Object ;
		private var _toolTipClass:Class;
		private var _displayType:String = "";
		private var _point:Point ;
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function ToolTipData(data:Object, toolTipClass:Class = null, displayType:String = "", point:Point = null)
		{
			_data = data;
			_toolTipClass = toolTipClass;
			
			if(!displayType)
				displayType = ToolTipDisplayType.MOUSE;
			_displayType = displayType;
			
			if(!point)
				point = new Point(0, 0);
			_point = point;
		}
		
		public function get data():Object
		{
			return null;
		}
		
		public function set data(value:Object):void
		{
		}
		
		public function get point():Point
		{
			return null;
		}
		
		public function set point(value:Point):void
		{
		}
		
		public function get displayType():String
		{
			return null;
		}
		
		public function set displayType(value:String):void
		{
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
	}
}