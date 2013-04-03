package org.game.ui.managers
{
	import flash.display.DisplayObject;
	
	import org.game.ui.core.IToolTip;
	import org.game.ui.core.IUIInterfaces;

	public interface IToolTipManager
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  currentTarget
		//----------------------------------
		/**
		 *  @private
		 */
		function get currentTarget():DisplayObject;
		
		/**
		 *  @private
		 */
		function set currentTarget(value:DisplayObject):void;
		
		//----------------------------------
		//  currentToolTip
		//----------------------------------
		
		/**
		 *  @private
		 */
		function get currentToolTip():IToolTip;
		
		/**
		 *  @private
		 */
		function set currentToolTip(value:IToolTip):void;
		
		//----------------------------------
		//  enabled
		//----------------------------------
		
		/**
		 *  @private
		 */
		function get enabled():Boolean;
		
		/**
		 *  @private
		 */
		function set enabled(value:Boolean):void;
		
		//----------------------------------
		//  hideDelay
		//----------------------------------
		
		/**
		 *  @private
		 */
		function get hideDelay():Number;
		
		/**
		 *  @private
		 */
		function set hideDelay(value:Number):void;
		
		//----------------------------------
		//  scrubDelay
		//----------------------------------
		
		/**
		 *  @private
		 */
		function get scrubDelay():Number;
		
		/**
		 *  @private
		 */
		function set scrubDelay(value:Number):void;
		
		//----------------------------------
		//  showDelay
		//----------------------------------
		
		/**
		 *  @private
		 */
		function get showDelay():Number;
		
		/**
		 *  @private
		 */
		function set showDelay(value:Number):void;
		
		
		/**
		 *  @private
		 */
		function get toolTipClass():Class;
		
		/**
		 *  @private
		 */
		function set toolTipClass(value:Class):void;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		function registerToolTip(target:DisplayObject, oldToolTip:IToolTipData,
								 newToolTip:IToolTipData):void;
		
		/**
		 *  @private
		 */
		function registerErrorString(target:DisplayObject, oldErrorString:IToolTipData,
									 newErrorString:IToolTipData):void;
		
		/**
		 *  @private
		 */
		function sizeTip(toolTip:IToolTip):void;
		
		/**
		 *  @private
		 */
		function createToolTip(data:IToolTipData,
							   errorTipBorderStyle:String = null,
							   context:IUIInterfaces = null):IToolTip;
		
		/**
		 *  @private
		 */
		function destroyToolTip(toolTip:IToolTip):void;
	}
}