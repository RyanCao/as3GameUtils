package org.rcSpark.tools.core
{
	public interface ICallBack extends IDispose
	{
		function addCallback(type:String,func:Function):void;
		function removeCallback(type:String,func:Function):void;
		function dispatch(type:String,data:Object=null):void;
	}
}