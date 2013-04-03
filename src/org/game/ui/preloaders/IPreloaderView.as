package org.game.ui.preloaders
{
	public interface IPreloaderView
	{
		function appLoadStart():void;
		
		function updateAppLoaded(loaded:Number, total:Number):void;
		
		function appLoadComplete():void;
		
		function appInitStart():void;
		
		function updateAppInited(loaded:Number, total:Number, params:Object):void;
		
		function appInitComplete():void;
		
		function set visible(value:Boolean):void;
	}
}