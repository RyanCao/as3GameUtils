package org.game.ui.core {
	import org.game.ui.managers.ISystemManager;

	/**
	 * @author ryan
	 */
	public interface IUIInterfaces extends IDisplayObject {
		
		function initialize():void ;
		function get initialized():Boolean ;
		
		function set systemManager(value:ISystemManager):void;
		function get systemManager():ISystemManager ;
		
		function getStyle(styleProp:String):*;
		
		function setSize(w:Number,h:Number):void;
//		function set width(value:Number):void;
//		function set height(value:Number):void;
//		function get width():Number;
//		function get height():Number;
	}
}
