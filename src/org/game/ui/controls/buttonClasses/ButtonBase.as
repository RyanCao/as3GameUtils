/*******************************************************************************
 * Class name:	ButtonBase.as
 * Description:	
 * Author:		ryancao
 * Create:		Apr 7, 2013 3:50:52 PM
 * Update:		Apr 7, 2013 3:50:52 PM
 ******************************************************************************/
package org.game.ui.controls.buttonClasses
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.events.MouseEvent;
	
	import org.game.ui.core.BaseUI;
	
	
	public class ButtonBase extends BaseUI
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		protected var skinState:String = ButtonSkinState.UP;
		protected var isOver:Boolean = false;
		protected var uiState:String = UIState.MOUSE_UP;
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function ButtonBase()
		{
			super();
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			addEventListener(MouseEvent.ROLL_OVER, mouseRollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, mouseRollOutHandler);
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		//------------------------------
		//		selected
		//------------------------------
		private var _selected:Boolean = false;
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected != value)
			{
				_selected = value;
				validateSkinState();
			}
		}
		
		override public function set enabled(value:Boolean):void
		{
			if(enabled != value)
			{
				super.enabled = value;
				validateSkinState()
			}
		}
		//--------------------------------------------------------------------------
		//		Method
		//--------------------------------------------------------------------------
		override public function dispose():void
		{
			super.dispose();
			
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			removeEventListener(MouseEvent.ROLL_OVER, mouseRollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, mouseRollOutHandler);
		}
		//--------------------------------------------------------------------------
		//		Event Handler
		//--------------------------------------------------------------------------
		protected function mouseDownHandler(event:MouseEvent):void
		{
			uiState = UIState.MOUSE_DOWN;
			validateSkinState();
			
			event.updateAfterEvent();
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			if(isOver)
				uiState = UIState.MOUSE_OVER;
			else
				uiState = UIState.MOUSE_UP;
			
			validateSkinState();
		}
		
		protected function mouseRollOverHandler(event:MouseEvent):void
		{
			isOver = true;
			uiState = UIState.MOUSE_OVER;
			validateSkinState();
		}
		
		protected function mouseRollOutHandler(event:MouseEvent):void
		{
			isOver = false;
			uiState = UIState.MOUSE_UP;
			validateSkinState();
		}
		//--------------------------------------------------------------------------
		//		Private
		//--------------------------------------------------------------------------
		private function validateSkinState():void
		{
			if(enabled)
			{
				if(!selected)
				{
					switch(uiState)
					{
						case UIState.MOUSE_UP : 
							skinStateChanged(ButtonSkinState.UP);break;
						case UIState.MOUSE_DOWN : 
							skinStateChanged(ButtonSkinState.DOWN);break;
						case UIState.MOUSE_OVER : 
							skinStateChanged(ButtonSkinState.OVER);break;
						case UIState.DISABLED : 
							skinStateChanged(ButtonSkinState.DISABLED);break;
						default : break;
					}
				}
				else
				{
					switch(uiState)
					{
						case UIState.MOUSE_UP : 
							skinStateChanged(ButtonSkinState.SELECTED_UP);break;
						case UIState.MOUSE_DOWN : 
							skinStateChanged(ButtonSkinState.SELECTED_DOWN);break;
						case UIState.MOUSE_OVER : 
							skinStateChanged(ButtonSkinState.SELECTED_OVER);break;
						case UIState.DISABLED : 
							skinStateChanged(ButtonSkinState.SELECTED_DISABLED);break;
						default : break;
					}
				}
			}
			else
			{
				if(selected)
					skinStateChanged(ButtonSkinState.SELECTED_DISABLED);
				else
					skinStateChanged(ButtonSkinState.DISABLED);
			}
		}
		
		protected function skinStateChanged(skinState:String):void
		{
			this.skinState = skinState;
		}
	}
}