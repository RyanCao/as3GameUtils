package org.game.ui.controls.pageClasses {
	import flash.events.IEventDispatcher;
	/**
	 * @author ryan
	 */
	public interface IPageUIView extends IEventDispatcher {
		/**
		 * 设置分页的当前页码显示
		 */
		function setPageString(current:int = 0 , total:int = 0):void ;
		/**
		 * 设置按钮的状态<br>
		 * HOME_STATUS = status & PageEvent.HOME_CODE;<br>
		 * END_STATUS = status & PageEvent.END_CODE;<br>
		 * PRE_STATUS = status & PageEvent.PRE_CODE;<br>
		 * NEXT_STATUS = status & PageEvent.NEXT_CODE;
		 */
		function setStatus(status:int):void ;
	}
}
