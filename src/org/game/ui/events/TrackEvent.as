package org.game.ui.events
{
	import flash.events.Event;
	
	/**
	 *
	 * @author zhangyu 2012-10-24
	 *
	 **/
	public class TrackEvent extends Event
	{
		/**
		 * 当用户执行操作导致value发生改变时触发; 
		 */	
		public static const CHANGE:String = "change";
		
		/**
		 * 当value值被修改时触发;
		 */
		public static const VALUE_CHANGED:String = "valueChanged";
		//--------------------------------------------------------------------------
		//		Constructor
		//--------------------------------------------------------------------------
		public function TrackEvent(type:String, oldValue:Number, newValue:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this._oldValue = oldValue;
			this._newValue = newValue;
			this._delta = newValue - oldValue;
		}
		//--------------------------------------------------------------------------
		//		Variables
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//		Propertise
		//--------------------------------------------------------------------------
		private var _oldValue:Number;
		
		public function get oldValue():Number
		{
			return _oldValue;
		}
		
		
		private var _newValue:Number;
		
		public function get newValue():Number
		{
			return _newValue;
		}
		
		private var _delta:Number;
		
		public function get delta():Number
		{
			return _delta;
		}
		
		//--------------------------------------------------------------------------
		//		Method
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//		Event Handler
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//		Private
		//--------------------------------------------------------------------------
	}
}