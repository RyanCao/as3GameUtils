/**
 @author	   Nelson Diotto
 @url          www.nelsond8.com
 @date         London Mar 05, 2009
 @version      2.1
 @parameter    var myDevMenu:DevMenu = new DevMenu("1.0",0XCCCC00,true); stage.addChild(myDevMenu);
 @last_updated Jul 24, 2010
 */
package org.rcSpark.tools.debug
{
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getTimer;
	
	public class DevMenu extends Sprite
	{
		private static const GAUGE_COLOR:int = 0XFFFFFF;
		private static const SCREEN_RES_X:Number = Capabilities.screenResolutionX;
		private static const SCREEN_RES_Y:Number = Capabilities.screenResolutionY;
		private static const FLASH_PLAYER_VERSION:String = Capabilities.version;
		
		private var _parent:Sprite = new Sprite();
		private var _myMenu:ContextMenu = new ContextMenu();
		private var _monitorItem:ContextMenuItem = new ContextMenuItem("Display Monitor");
		private var _bg:Sprite = new Sprite();
		private var _bar:Sprite = new Sprite();
		private var _txtBox:TextField = new TextField();
		private var _txtVersion:TextField = new TextField();
		private var _version:String = new String();
		private var _fps:String = new String();
		private var _color:int = 0;
		private var _monitor:Boolean = false;
		private var _time:Number = 0;
		private var _frameTime:Number = 0;
		private var _frames:Number = 0;
		private var _secondTime:Number = 0;
		private var _prevSecondTime:Number = getTimer();
		private var _prevFrameTime:Number = getTimer();
		
		
		public function DevMenu (versionBuild:String="1.0",color:int=0xCCCCCC,monitor:Boolean=false)
		{
			_version = versionBuild;
			_color = color;
			_monitor = monitor;
			
			addEventListener (Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * 
		 * @return void
		 */		
		private function init (e:Event):void
		{			
			removeEventListener (Event.ADDED_TO_STAGE, init);
			
			_parent = Sprite(this.parent);
			
			//hide flash default menu items
			_myMenu.hideBuiltInItems();
			
			//Only display the project version build
			var menuItem1:ContextMenuItem = new ContextMenuItem("Version Build: " + _version);
			_myMenu.customItems.push (menuItem1);
			
			//also display developer monitor 
			if (_monitor)
			{
				_myMenu.customItems.push (_monitorItem);
				_monitorItem.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, displayMonitor);
				displayMonitor ();
			}
			
			_parent.contextMenu = _myMenu;
		}
		/**
		 * display and hide dev monitor 
		 * @return void
		 */
		private function displayMonitor (e:ContextMenuEvent=null):void
		{
			_monitorItem.caption = "Hide Monitor";
			_monitorItem.removeEventListener (ContextMenuEvent.MENU_ITEM_SELECT, displayMonitor);
			_monitorItem.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, hideMonitor);
			buidMonitor ();
			
		}
		private function hideMonitor (e:ContextMenuEvent):void
		{
			_monitorItem.caption = "Display Monitor";
			_monitorItem.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, displayMonitor);
			_monitorItem.removeEventListener (ContextMenuEvent.MENU_ITEM_SELECT, hideMonitor);
			removeMonitor ();
		}
		/**
		 * buid dev monitor
		 * @return void
		 */
		private function buidMonitor ():void
		{
			//create background
			_bg.graphics.beginFill (_color,.8);
			_bg.graphics.drawRect (0,0,_parent.stage.stageWidth,18);
			_bg.graphics.endFill ();
			
			//create memory gauge
			_bar.graphics.beginFill (GAUGE_COLOR);
			_bar.graphics.drawRect (0, 0, 50, 3);
			_bar.graphics.endFill ();
			
			//Memory+fps text field
			_txtBox.x = 0;
			_txtBox.y = 0;
			_txtBox.autoSize = TextFieldAutoSize.LEFT;
			_txtBox.defaultTextFormat = new TextFormat("_sans",12,0x000000);
			_txtBox.selectable = false;
			
			//version text field
			_txtVersion.x = _parent.stage.stageWidth - _txtVersion.width;
			_txtVersion.y = 0;
			_txtVersion.autoSize = TextFieldAutoSize.RIGHT;
			_txtVersion.defaultTextFormat = new TextFormat("_sans",12,0x000000);
			_txtVersion.selectable = false;
			_txtVersion.text = "Version Build: " + _version;
			
			addChild (_bg);
			addChild (_bar);
			addChild (_txtBox);
			addChild (_txtVersion);
			
			if(!_parent.contains(this)) //if not added by parent mc add to stage
				_parent.addChild(this); 
			
			addEventListener (Event.ENTER_FRAME,update); //update gauge
			
			_parent.addEventListener(Event.ADDED,main_AddedHanddler);//keep monitor always on the top	
		}
		
		/**
		 * 
		 * @return void
		 */		
		private function main_AddedHanddler (e:Event):void
		{
			//display it always on the top
			_parent.setChildIndex (this, _parent.numChildren-1);		
		}
		
		/**
		 * stop monitor and remove elements from stage
		 * @return void
		 */
		private function removeMonitor ():void
		{
			_parent.removeChild (this);
			removeEventListener (Event.ENTER_FRAME,update);
			_parent.removeEventListener(Event.ADDED,main_AddedHanddler);
		}
		
		/**
		 * update monitor on enter frame 
		 * @return void
		 */
		private function update (e:Event):void
		{			
			//memory usage formated as MB
			var mem:String = Number(System.totalMemory / 1024 / 1024).toFixed(2);
			
			//frames per second
			_time = getTimer();
			_frameTime = _time - _prevFrameTime;
			_secondTime = _time - _prevSecondTime;
			
			if (_secondTime >= 1000)
			{
				_fps = _frames.toString();
				_frames = 0;
				_prevSecondTime = _time;
			}
			else
			{
				_frames++;
			}
			_prevFrameTime = _time;
			
			_txtBox.text = "Display: " + SCREEN_RES_X + "x" + SCREEN_RES_Y + "  |  Player Version: " + FLASH_PLAYER_VERSION + "  |  Memory: " + mem + " MB  |  FPS: " + _fps;
			_bar.scaleX = _bar.scaleX - ((_bar.scaleX - (_frameTime/10)) / 5);
			
		}
	}
}