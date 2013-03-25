package org.game.ui.modules
{
	import flash.display.DisplayObjectContainer;
	
	public interface IModule
	{
		function show(p_parent : DisplayObjectContainer, ... rest) : void;
		function dispose() : void;
		function addEventListener(type : String, 
								  listener : Function, 
								  useCapture : Boolean = false, 
								  priority : int = 0, 
								  useWeakReference : Boolean = false) : void;
		function removeEventListener(type : String, 
									 listener : Function, 
									 useCapture : Boolean = false) : void 
	}
}