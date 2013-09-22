package org.dll.interfaces {
	import flash.events.IEventDispatcher;
	
	public interface IDll extends IEventDispatcher {
		function init(_arg1:Object):void;
		function callMethod(funName:String, ... _args):*;
	}
}
