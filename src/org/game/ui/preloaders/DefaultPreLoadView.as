/*******************************************************************************
 * Class name:	DefaultPreLoadView.as
 * Description:	
 * Author:		ryancao
 * Create:		Apr 1, 2013 5:22:36 PM
 * Update:		Apr 1, 2013 5:22:36 PM
 ******************************************************************************/
package org.game.ui.preloaders
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.display.Sprite;
	
	
	public class DefaultPreLoadView extends Sprite implements IPreloaderView
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function DefaultPreLoadView()
		{
			super();
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		public function appLoadStart():void
		{
		}
		
		public function updateAppLoaded(loaded:Number, total:Number):void
		{
		}
		
		public function appLoadComplete():void
		{
		}
		
		public function appInitStart():void
		{
		}
		
		public function updateAppInited(loaded:Number, total:Number, params:Object):void
		{
		}
		
		public function appInitComplete():void
		{
		}
	}
}