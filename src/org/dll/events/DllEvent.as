package org.dll.events {
	import flash.events.Event;
	
	import org.dll.model.DllModel;
	
	public class DllEvent extends Event {
		/**
		 * 定义 <code>dllProgress</code> 事件对象的 <code>type</code> 属性值。
		 * 动态库加载进度事件
		 */
		public static const DLL_PROGRESS:String = "dllProgress";
		/**
		 * 定义 <code>dllComplete</code> 事件对象的 <code>type</code> 属性值。
		 * 动态库加载完毕事件
		 */
		public static const DLL_COMPLETE:String = "dllComplete";
		/**
		 * 定义 <code>dllInitProgress</code> 事件对象的 <code>type</code> 属性值。
		 * 动态库初始化进度事件
		 */
		public static const DLL_INIT_PROGRESS:String = "dllInitProgress";
		/**
		 * 定义 <code>dllInitComplete</code> 事件对象的 <code>type</code> 属性值。
		 * 动态库初始化完毕事件
		 */
		public static const DLL_INIT_COMPLETE:String = "dllInitComplete";
		
		private var _dll:DllModel;
		private var _bytesLoaded:uint;
		private var _bytesTotal:uint;
		private var _progress:Number;
		
		public function DllEvent(type:String="dllComplete"){
			super(type);
		}
		public function get progress():Number{
			return _progress;
		}
		public function set progress(__progress:Number):void{
			_progress = __progress;
		}
		public function get bytesTotal():uint{
			return _bytesTotal;
		}
		public function set bytesTotal(__bytesTotal:uint):void{
			_bytesTotal = __bytesTotal;
		}
		public function get bytesLoaded():uint{
			return _bytesLoaded;
		}
		public function set bytesLoaded(__bytesLoaded:uint):void{
			_bytesLoaded = __bytesLoaded
		}
		public function get dll():DllModel{
			return _dll;
		}
		public function set dll(__dll:DllModel):void{
			_dll = __dll;
		}
	}
}
