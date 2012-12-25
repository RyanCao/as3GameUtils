/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.tools.time
{
	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	
	/****
	 * SleepTimer.as class. Created Aug 18, 2012 12:59:59 AM
	 * <br>
	 * Description:扩展的Timer，会修正省电模式Timer次数减少的问题
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/   	 
	public class SleepTimer extends EventDispatcher
	{		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private var prevTimer:int;
		private var timer:Timer;
		
		public var delay:Number;
		public var currentCount:int;
		public var repeatCount:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function SleepTimer(delay:Number, repeatCount:int = 0)
		{
			this.timer = new Timer(delay, int.MAX_VALUE);
			this.delay = delay;
			this.repeatCount = repeatCount;
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		public function start():void
		{
			this.prevTimer = getTimer();
			this.currentCount = 0;
			
			this.timer.addEventListener(TimerEvent.TIMER,timerHandler);
			this.timer.start();
		}
		
		public function stop():void
		{
			this.timer.removeEventListener(TimerEvent.TIMER,timerHandler);
			this.timer.stop();
		}
		
		public function reset():void
		{
			this.stop();
			this.start();
		}
		
		public function get running():Boolean
		{
			return timer.running;
		}
		
		protected function timerHandler(event:TimerEvent):void
		{
			var t:int = getTimer();
			while (t - prevTimer >= timer.delay)
			{
				prevTimer += timer.delay;
				
				this.currentCount++;
				dispatchEvent(event);
				
				if (currentCount == repeatCount)
				{
					this.stop();
					this.dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
				}
			}
		}
	}
	
}