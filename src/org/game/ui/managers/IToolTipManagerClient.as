package org.game.ui.managers
{
	public interface IToolTipManagerClient
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  toolTip
		//----------------------------------
		
		/**
		 *  The text of this component's tooltip.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		function get toolTip():IToolTipData;
		
		/**
		 *  @private
		 */
		function set toolTip(value:IToolTipData):void;
	}
}