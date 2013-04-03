package org.game.ui.managers
{
	import flash.geom.Point;

	public interface IToolTipData
	{
		function get data():Object;
		function set data(value:Object):void;
		
		/**
		 * 鼠标模式中，point代码鼠标便宜量;
		 * 固定坐标模式中, point代表指定的舞台坐标 
		 * @return 
		 * 
		 */	
		function get point():Point;
		function set point(value:Point):void;
		
		function get displayType():String;
		function set displayType(value:String):void;
	}
}