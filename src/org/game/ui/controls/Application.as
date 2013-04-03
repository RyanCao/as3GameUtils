/*******************************************************************************
 * Class name:	Application.as
 * Description:	
 * Author:		ryancao
 * Create:		Mar 29, 2013 5:27:57 PM
 * Update:		Mar 29, 2013 5:27:57 PM
 ******************************************************************************/
package org.game.ui.controls
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import org.game.gameant;
	import org.game.ui.core.BaseUI;
	import org.game.ui.core.IApplication;
	import org.game.ui.core.UIComponentGlobals;
	import org.game.ui.managers.LayoutManager;
	import org.game.ui.managers.ToolTipManager;
	import org.game.ui.preloaders.IApplicationPreloader;
	
	use namespace gameant;
	public class Application extends BaseUI implements IApplication
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function Application()
		{
			super();
			UIComponentGlobals.layoutManager = LayoutManager.getInstance();
			//ToolTipManager.defaultTooltipClass = ToolTip;
			//TopViewManager.sm = SystemManagerGlobals.topLevelSystemManager;
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		public function get preloader():IApplicationPreloader
		{
			// TODO Auto Generated method stub
			return null;
		}
	}
}