package org.game.ui.core
{
	import org.game.ui.managers.IToolTipData;

	public interface IToolTip extends IUIInterfaces
	{
		/**
		 *  The text that appears in the tooltip.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		function get data():IToolTipData;
		
		/**
		 *  @private
		 */
		function set data(value:IToolTipData):void;
	}
}