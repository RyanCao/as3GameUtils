package org.game.ui.preloaders
{
	import flash.events.IEventDispatcher;
	
	import org.game.ui.core.IApplication;

	public interface IApplicationPreloader extends IEventDispatcher
	{
		function initialize(app:IApplication):void;
	}
}