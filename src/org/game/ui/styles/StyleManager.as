/*******************************************************************************
 * Class name:	StyleManager.as
 * Description:	
 * Author:		ryancao
 * Create:		Mar 27, 2013 4:14:35 PM
 * Update:		Mar 27, 2013 4:14:35 PM
 ******************************************************************************/
package org.game.ui.styles
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	
	
	public class StyleManager implements IStyleManager
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		private static var __impl:IStyleManager;
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function StyleManager()
		{
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		public static function get impl():IStyleManager
		{
			if(!__impl)
				__impl = new StyleManagerImpl();
			return __impl;
		}
		
		public function getStyleDeclaration(styleName:String):StyleDeclaration
		{
			return impl.getStyleDeclaration(styleName);
		}
		
		public function registerStyleDeclaration(styleName:String, style:Object):void
		{
			impl.registerStyleDeclaration(styleName,style);
		}
		
		public function createAnonymousStyle(styleName:String=""):StyleDeclaration
		{
			return impl.createAnonymousStyle(styleName);
		}
	}
}