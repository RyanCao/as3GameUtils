package org.game.ui.controls.pageClasses {
	import flash.events.Event;
	
	/**
	 * @author ryan
	 */
	public class PageEvent extends Event {
		
		/***
		 * 首页事件
		 * */
		public static const HOME_PAGE : String = "HOME_PAGE";
		/***
		 * 末页事件
		 * */
		public static const END_PAGE : String = "END_PAGE";
		/***
		 * 前页事件
		 * */
		public static const PRE_PAGE : String = "PRE_PAGE";
		/***
		 * 后页事件
		 * */
		public static const NEXT_PAGE : String = "NEXT_PAGE";
		/***
		 * 数据改变派发的事件
		 * */
		public static const PAGE_CHANGED : String = "changed";
		
		public static const HOME_CODE : uint = 1;
		public static const END_CODE : uint = 2;
		public static const PRE_CODE : uint = 4;
		public static const NEXT_CODE : uint = 8;
		
		public var data:Array ;
		/**
		 * 是否是数据更新导致的事件
		 * */
		public var is_Data_Update:Boolean = false ;
		
		public function PageEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
