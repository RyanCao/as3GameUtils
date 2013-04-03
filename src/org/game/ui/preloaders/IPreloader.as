package org.game.ui.preloaders
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	import org.game.ui.core.IApplication;

	public interface IPreloader extends IEventDispatcher
	{
		/**
		 * 获取加载实例 
		 * @return 
		 * 
		 */	
		function get view():IPreloaderView;
		/**
		 * 初始化加载
		 * @param displayClass 加载显示类
		 * @param rslList 额外加载资源列表
		 * 
		 */	
		function initialize(displayClass:Class, root:DisplayObject):void;
		
		/**
		 * 注册主应用程序 
		 * @param app
		 * 
		 */	
		function registerApplication(app:IApplication):void;
		
		function dispose():void;
	}
}