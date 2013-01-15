/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.tools.time
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	
	/****
	 * SleepCheck.as class. Created Aug 18, 2012 12:57:55 AM
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/   	 
	public final class SleepCheck
	{		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		static public var onSleep:Function;
		static public var onWake:Function;
		static public var isSleep:Boolean;
		
		static private var timer:Timer;
		static private var t:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function SleepCheck()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		public static function start(onSleep:Function = null,onWake:Function = null):void
		{
			if (timer)
				stop();
			
			SleepCheck.onSleep = onSleep;
			SleepCheck.onWake = onWake;
			
			timer = new Timer(10,uint.MAX_VALUE);
			timer.addEventListener(TimerEvent.TIMER,timeHandler);
			timer.start();
			
			t = getTimer();
		}
		
		public static function stop():void
		{
			SleepCheck.onSleep = null;
			SleepCheck.onWake = null;
			
			if (timer)
			{
				timer.removeEventListener(TimerEvent.TIMER,timeHandler);
				timer.stop();
				timer = null;
			}
			
			t = 0;
		}
		
		private static function timeHandler(event:TimerEvent):void
		{
			if (getTimer() - t >= 100 && !isSleep)
			{
				isSleep = true;
				if (onSleep != null)
					onSleep();
			}
			else if (getTimer() - t < 100 && isSleep)
			{
				isSleep = false;
				
				if (onWake != null)
					onWake();
			}
		}
	}
	
}