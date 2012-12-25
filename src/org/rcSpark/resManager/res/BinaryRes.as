/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.resManager.res
{
	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	
	/****
	 * BinaryRes.as class. Created 2:46:49 PM Aug 20, 2012
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/
	public class BinaryRes extends BaseRes
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function BinaryRes(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		
		override public function loadBytes(bytes:ByteArray, ct:LoaderContext):void
		{
			this._content= bytes;
			super.onCompleteHandler(new Event(Event.COMPLETE));
		}
			
	}
}