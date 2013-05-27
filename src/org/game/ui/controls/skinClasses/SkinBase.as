/*******************************************************************************
 * Class name:	SkinBase.as
 * Description:	
 * Author:		ryancao
 * Create:		Apr 7, 2013 4:53:50 PM
 * Update:		Apr 7, 2013 4:53:50 PM
 ******************************************************************************/
package org.game.ui.controls.skinClasses
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.display.DisplayObject;
	
	import org.game.ui.core.BaseUI;
	
	
	public class SkinBase extends BaseUI
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		private var _currentState:String = "";
		private var _hitSkin:DisplayObject ;
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function SkinBase()
		{
			super();
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		//------------------------------
		//		currentState
		//------------------------------
		public function get currentState():String
		{
			return _currentState;
		}
		
		public function set currentState(value:String):void
		{
			if(_currentState != value)
			{
				_currentState = value;
				
				stateChanged();
			}
		}	
		
		public function get hitSkin():DisplayObject
		{
			return _hitSkin;
		}
		
		public function set hitSkin(value:DisplayObject):void
		{
			_hitSkin = value;
			_hitSkin.alpha = 0;
			this.addChild(hitSkin);
		}
		
		protected function stateChanged():void
		{
			
		}
	}
}