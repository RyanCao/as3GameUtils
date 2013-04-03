package org.game.ui.core
{
	import org.game.ui.preloaders.IApplicationPreloader;

public interface IApplication extends IUIInterfaces
{
	function get preloader():IApplicationPreloader
}
}