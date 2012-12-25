/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.tools.core
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.rcSpark.tools.time.Tick;
	import org.rcSpark.tools.time.TickEvent;

	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	
	/****
	 * CallLaterQueue.as class. Created Aug 18, 2012 12:26:38 AM
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/   	 
	public final class CallLaterQueue
	{		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		static private var __instance:CallLaterQueue ;
		
		private var timer:Timer;
		private var timeQueue:Array;
		private var timeQueuePara:Array;
		
		private var ticker:Tick;
		private var tickQueue:Array;
		private var tickQueuePara:Array;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function CallLaterQueue()
		{
			this.timer = new Timer(0,1);
			this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerHandler);
			this.timeQueue = [];
			this.timeQueuePara = [];
			
			this.ticker = Tick.instance;
			this.ticker.addEventListener(TickEvent.TICK,tickHandler);
			this.tickQueue = [];
			this.tickQueuePara = [];
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		public static function instance(): CallLaterQueue{
			if(!__instance)
				__instance = new CallLaterQueue();
			return __instance ;
		}
		
		/**
		 * 延迟调用函数，并在此函数执行完后调用
		 * @param f
		 * @param para
		 * 
		 */
		public function callLaterByTime(f:Function,para:Array = null):void
		{
			timeQueue[timeQueue.length] = f;
			timeQueuePara[timeQueuePara.length] = para;
			if (!timer.running)
			{
				timer.repeatCount = 1;
				timer.start();
			}
		}
		
		/**
		 * 延迟调用函数，并在下一帧后调用
		 * @param f
		 * @param para
		 * 
		 */
		public function callLaterByTick(f:Function,para:Array = null):void
		{
			tickQueue[tickQueue.length] = f;
			tickQueuePara[tickQueuePara.length] = para;
		}
		
		/**
		 * 移除延迟调用 
		 * @param f
		 * 
		 */
		public function removeCallLaterByTime(f:Function):void
		{
			var index:int = timeQueue.indexOf(f);
			if (index != -1)
			{
				timeQueue.splice(index, 1);
				timeQueuePara.splice(index, 1);
			}
		}
		
		/**
		 * 移除下一帧延迟调用 
		 * @param f
		 * 
		 */
		public function removeCallLaterByTick(f:Function):void
		{
			var index:int  = tickQueue.indexOf(f);
			if (index != -1)
			{
				tickQueue.splice(index, 1);
				tickQueuePara.splice(index, 1);
			}
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			var list:Array = timeQueue.concat();
			var listPara:Array = timeQueuePara.concat();
			timeQueue.length = 0;
			timeQueuePara.length = 0;
			
			var l:int = list.length;
			for (var i:int = 0;i < l;i++)
			{
				var para:Array = listPara[i];
				if (para)
					(list[i] as Function).apply(null,listPara[i]);
				else
					(list[i] as Function)();
			}
		}
		
		private function tickHandler(event:TickEvent):void
		{
			var list:Array = tickQueue.concat();
			var listPara:Array = tickQueuePara.concat();
			tickQueue.length = 0;
			tickQueuePara.length = 0;
			
			var l:int = list.length;
			for (var i:int = 0;i < l;i++)
			{
				var para:Array = listPara[i];
				if (para)
					(list[i] as Function).apply(null,listPara[i]);
				else
					(list[i] as Function)();
			}
		}
	}
	
}