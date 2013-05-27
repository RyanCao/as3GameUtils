package etolib.components.supportClasses
{
	
import etolib.components.listClasses.IDataRenderer;
import etolib.components.listClasses.ISelectedRenderer;
import etolib.core.IDispose;
import etolib.core.UIObject;
import etolib.skins.ItemRendererSkin;
import etolib.skins.ItemRendererSkinState;
import etolib.skins.UIState;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;

/**
 * 
 * @author yu.zhang
 * 
 */
public class ItemRenderer extends UIObject implements IDataRenderer, IDispose, ISelectedRenderer
{
	//--------------------------------------------------------------------------
	//		Constructor
	//--------------------------------------------------------------------------
	public function ItemRenderer()
	{
		super(); 
		
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		addEventListener(MouseEvent.ROLL_OVER, mouseRollOverHandler);
		addEventListener(MouseEvent.ROLL_OUT, mouseRollOutHandler);
	} 
	//--------------------------------------------------------------------------
	//		Variables
	//--------------------------------------------------------------------------
	protected var skinState:String = "";
	protected var isOver:Boolean = false;
	protected var uiState:String = UIState.MOUSE_UP;
	//--------------------------------------------------------------------------
	//		Propertise
	//--------------------------------------------------------------------------
	/*private var _selectedEnabled:Boolean = true;

	public function get selectedEnabled():Boolean
	{
		return _selectedEnabled;
	}

	public function set selectedEnabled(value:Boolean):void
	{
		_selectedEnabled = value;
	}*/

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
	
	//------------------------------
	//		data
	//------------------------------
	private var _data:Object
	
	public function get data():Object
	{
		return _data;
	}
	
	public function set data(value:Object):void
	{
		_data = value;
		
		invalidateProperties();
	}
	//--------------------------------------------------------------------------
	//		Methods
	//--------------------------------------------------------------------------
	override protected function commitProperties():void
	{
		super.commitProperties();
		
		validateSkinState();
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
	protected function validateSkinState():void
	{
		if(!selected)
		{
			switch(uiState)
			{
				case UIState.MOUSE_UP : 
					skinStateChanged(ItemRendererSkinState.UP);break;
				case UIState.MOUSE_DOWN : 
					skinStateChanged(ItemRendererSkinState.SELECTION);break;
				case UIState.MOUSE_OVER : 
					skinStateChanged(ItemRendererSkinState.OVER);break;
				default : break;
			}
		}
		else
		{
			skinStateChanged(ItemRendererSkinState.SELECTION);
		}
	}
	
	protected function skinStateChanged(skinState:String):void
	{
		this.skinState = skinState;
	}
}
}