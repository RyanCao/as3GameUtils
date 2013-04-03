/*******************************************************************************
 * Class name:	BaseUI.as
 * Description:	
 * Author:		ryancao
 * Create:		Mar 27, 2013 5:18:09 PM
 * Update:		Mar 27, 2013 5:18:09 PM
 ******************************************************************************/
package org.game.ui.core
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.game.gameant;
	import org.game.ui.events.UIObjectEvent;
	import org.game.ui.managers.ILayoutManagerClient;
	import org.game.ui.managers.ISystemManager;
	import org.game.ui.managers.IToolTipData;
	import org.game.ui.managers.IToolTipManagerClient;
	import org.game.ui.managers.ToolTipManager;
	import org.game.ui.styles.StyleDeclaration;
	import org.game.ui.styles.StyleManager;
	
	[Event(name="add", type="org.game.ui.events.UIObjectEvent")]
	
	[Event(name="remove", type="org.game.ui.events.UIObjectEvent")]
	
	[Event(name="creationComplete", type="org.game.ui.events.UIObjectEvent")]
	
	use namespace gameant ;
	
	public class BaseUI extends Sprite implements IToolTipManagerClient, IDispose, IUIInterfaces , ILayoutManagerClient
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		private var _toolTip:IToolTipData ;
		
		gameant var __initialize:Boolean = false;
		
		gameant var invalidatePropertiesFlag:Boolean = false;
		gameant var invalidateSizeFlag:Boolean = false;
		gameant var invalidateDisplayListFlag:Boolean = false;
		
		protected var _styleName:String = "";
		protected var _defaultStyleName:String = "";
		protected var styleChanged:Boolean = false;
		
		gameant var deferredSetStyles:StyleDeclaration;
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function BaseUI()
		{
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		
		//----------- toolTip ---------
		public function get toolTip():IToolTipData
		{
			return _toolTip;
		}
		
		public function set toolTip(value:IToolTipData):void
		{
			var oldValue:IToolTipData = _toolTip;
			_toolTip = value;
			ToolTipManager.impl.registerToolTip(this, oldValue, value);
		}
		
		//----------- dispose ---------
		public function dispose():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			if(stage)
				stage.removeEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		//----------- initialize ---------
		public function initialize():void
		{
			if(__initialize)
				return ;
			createStyle();
			
			createChildren();
			
			childrenCreated();
			
			__initialize = true;
			
			validateNow();
		}
		
		final public function validateNow():void
		{
			invalidatePropertiesFlag = true;
			invalidateSizeFlag = true;
			invalidateDisplayListFlag = true;
			
			if(!initialized){
				initialize();
			}else{
				validateProperties();
				validateSize();
				validateDisplayList();
			}
		}
		
		final public function validateProperties():void
		{
			if(invalidatePropertiesFlag)
			{
				commitProperties();
				invalidatePropertiesFlag = false;
			}
		}
		
		final public function validateSize(recursive:Boolean = false):void
		{
			if(invalidateSizeFlag)
			{
				measure();
				invalidateSizeFlag = false;
			}
		}
		
		final public function validateDisplayList():void
		{
			if(invalidateDisplayListFlag)
			{
				updateDisplayList(this.getExplicitOrMeasuredWidth(), this.getExplicitOrMeasuredHeight());
				invalidateDisplayListFlag = false;
			}
		}
		
		final public function invalidateProperties():void
		{
			if(!invalidatePropertiesFlag && initialized)
			{
				invalidatePropertiesFlag = true;
				if(UIComponentGlobals.layoutManager)
					UIComponentGlobals.layoutManager.invalidateProperties(this);
			}
		}
		
		final public function invalidateSize():void
		{
			if(!invalidateSizeFlag && initialized)
			{
				invalidateSizeFlag = true;
				if(UIComponentGlobals.layoutManager)
					UIComponentGlobals.layoutManager.invalidateSize(this);
			}
		}
		
		final public function invalidateDisplayList():void
		{
			if(!invalidateDisplayListFlag && initialized)
			{
				invalidateDisplayListFlag = true;
				if(UIComponentGlobals.layoutManager)
					UIComponentGlobals.layoutManager.invalidateDisplayList(this);
			}
		}
		
		//----------- addToStage ---------
		protected function addToStageHandler(event:Event):void
		{
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		protected function removeFromStageHandler(event:Event):void
		{
			stage.removeEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		protected function stageResizeHandler(event:Event):void
		{
			
		}
		
		protected function measure():void
		{
			
		}
		
		protected function updateDisplayList(unscaleWidth:Number, unscaleHeight:Number):void
		{
			
		}
		
		protected function childrenCreated():void
		{
			
		}
		
		protected function createChildren():void
		{
			
		}
		protected function commitProperties():void{
			
		}
		
		public function get initialized():Boolean
		{
			return __initialize;
		}
		
		//----------- style ---------
		public function get styleName():String
		{
			return _styleName;
		}
		
		public function set styleName(value:String):void
		{
			_styleName = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		public function get defaultStyleName():String
		{
			return _defaultStyleName;
		}

		public function set defaultStyleName(value:String):void
		{
			_defaultStyleName = value ;
		}
		
		public function getStyle(styleProp:String):*
		{
			if (!deferredSetStyles)
				createStyle(true);
			
			if (deferredSetStyles && deferredSetStyles is StyleDeclaration)
			{
				var style:* = deferredSetStyles.getStyle(styleProp);
				if(style !== undefined)
					return style;
			}
			return null;
		}
		
		public function setStyle(styleProp:String, newValue:*):void
		{
			if (!deferredSetStyles)
				createStyle(true);
			StyleDeclaration(deferredSetStyles).setStyle(styleProp, newValue);  
			styleChanged = true;
		}
		
		protected function createStyle(useAnonymousStyle:Boolean = false):void
		{
			if(!styleName && _defaultStyleName){
				styleName = defaultStyleName;
			}	
			
			if(!deferredSetStyles){
				if(styleName){
					this.deferredSetStyles = StyleManager.impl.getStyleDeclaration(styleName);
				}else{
					if(useAnonymousStyle){
						this.deferredSetStyles = new StyleDeclaration(this.name, {});
					}
				}
			}
		}
		
		//----------- resize ---------
		/**
		 * 获取有效的长度 
		 * @return 
		 * 
		 */	
		public function getExplicitOrMeasuredWidth():Number
		{
			var width:Number = isNaN(explicitWidth) ? measuredWidth : explicitWidth;
			return width;
		}
		
		/**
		 * 获取有效的高度 
		 * @return 
		 * 
		 */
		public function getExplicitOrMeasuredHeight():Number
		{
			var height:Number = isNaN(explicitHeight) ? measuredHeight : explicitHeight;
			return height
		}
		//------------------------------
		//		explicitWidth
		//------------------------------
		private var _explicitWidth:Number;
		/**
		 * 如果有手动设置width/height属性，此属性将用作记录设置的属性.并且在布局中会优先使用此属性，
		 * 如果没有设置width/height属性, 在使用组件的时候，会使用measuredWidth属性.
		 * @return 
		 */	
		public function get explicitWidth():Number
		{
			return _explicitWidth;
		}
		
		public function set explicitWidth(value:Number):void
		{
			_explicitWidth = value;
			
			invalidateDisplayList();
		}
		
		//------------------------------
		//		explicitHeight
		//------------------------------
		private var _explicitHeight:Number;
		
		/**
		 * 记录指定的高度
		 * @return 
		 */	
		public function get explicitHeight():Number
		{
			return _explicitHeight;
		}
		
		public function set explicitHeight(value:Number):void
		{
			_explicitHeight = value;
			
			invalidateDisplayList();
		}
		//------------------------------
		//		measuredWidth
		//------------------------------
		private var _measuredWidth:Number;
		
		public function get measuredWidth():Number
		{
			return isNaN(_measuredWidth) ? $width : _measuredWidth;
		}
		
		public function set measuredWidth(value:Number):void
		{
			_measuredWidth = value;
		}
		
		//------------------------------
		//		measuredHeight
		//------------------------------
		private var _measuredHeight:Number;
		
		public function get measuredHeight():Number
		{
			return isNaN(_measuredHeight) ? $height : _measuredHeight;
		}
		
		public function set measuredHeight(value:Number):void
		{
			_measuredHeight = value;
		}
		
		//------------------------------
		//		$width
		//------------------------------
		gameant function get $width():Number
		{
			return super.width;
		}
		
		gameant function set $width(value:Number):void
		{
			super.width = value;
		}
		
		//------------------------------
		//		$height
		//------------------------------
		gameant function get $height():Number
		{
			return super.height;
		}
		
		gameant function set $height(value:Number):void
		{
			super.height = value;
		}
		
		//------------------------------
		//		width
		//------------------------------
		private var _width:Number;
		
		override public function get width():Number
		{
			return isNaN(_width) ? $width : _width;
		}
		
		override public function set width(value:Number):void
		{
			if(explicitWidth != value)
			{
				explicitWidth = value;
				invalidateSize();
			}
			
			if(width != value)
			{
				_width = value;
				invalidateDisplayList();
			}
		}
		
		//------------------------------
		//		height
		//------------------------------
		private var _height:Number;
		
		override public function get height():Number
		{
			return isNaN(_height) ? $height : _height;
		}
		
		override public function set height(value:Number):void
		{
			if(explicitHeight != value)
			{
				explicitHeight = value;
				invalidateSize();
			}
			
			if(height != value)
			{
				_height = value;
				invalidateDisplayList();
			}
		}
		
		public function setSize(w:Number, h:Number):void
		{
			width = w ;
			height = h ;
		}
		
		// ----------- nestLevel --------------
		private var _nestLevel:int;
		[Inspectable(environment="none")]
		public function get nestLevel():int
		{
			return _nestLevel;
		}
		
		/**
		 *  @private
		 */
		public function set nestLevel(value:int):void
		{
			// If my parent hasn't been attached to the display list, then its nestLevel
			// will be zero.  If it tries to set my nestLevel to 1, ignore it.  We'll
			// update nest levels again after the parent is added to the display list.
			if (value == 1)
				return;
			// Also punt if the new value for nestLevel is the same as my current value.
			// TODO: (aharui) add early exit if nestLevel isn't changing
			if (value > 1 && _nestLevel != value)
			{
				_nestLevel = value;
				updateCallbacks();
				value ++;
			}
			else if (value == 0)
				_nestLevel = value = 0;
			else
				value ++;
			
			var childList:IChildList = IChildList(this);
			
			var n:int = childList.numChildren;
			for (var i:int = 0; i < n; i++)
			{
				var ui:ILayoutManagerClient  = childList.getChildAt(i) as ILayoutManagerClient;
				if (ui)
				{
					ui.nestLevel = value;
				}
				else
				{
//					var textField:IUITextField = childList.getChildAt(i) as IUITextField;
//					
//					if (textField)
//						textField.nestLevel = value;
				}
			}
		}
		
		gameant function updateCallbacks():void
		{
			if (invalidateDisplayListFlag&&UIComponentGlobals.layoutManager)
				UIComponentGlobals.layoutManager.invalidateDisplayList(this);
			
			if (invalidateSizeFlag&&UIComponentGlobals.layoutManager)
				UIComponentGlobals.layoutManager.invalidateSize(this);
			
			if (invalidatePropertiesFlag&&UIComponentGlobals.layoutManager)
				UIComponentGlobals.layoutManager.invalidateProperties(this);
		}
		
		//-----------  IchildList ---------------------
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var formerParent:DisplayObjectContainer = child.parent;
			if (formerParent && !(formerParent is Loader))
				formerParent.removeChild(child);
			
			// If there is an overlay, place the child underneath it.
			
			//var index:int = effectOverlayReferenceCount && child != effectOverlay ?
			//	Math.max(0, super.numChildren - 1) :
			//	super.numChildren;
			
			// Do anything that needs to be done before the child is added.
			// When adding a child to UIComponent, this will set the child's
			// virtual parent, its nestLevel, its document, etc.
			// When adding a child to a Container, the override will also
			// invalidate the container, adjust its content/chrome partitions,
			// etc.
			addingChild(child);
			
			// Call a low-level player method in DisplayObjectContainer which
			// actually attaches the child to this component.
			// The player dispatches an "added" event from the child just after
			// it is attached, so all "added" handlers execute during this call.
			// UIComponent registers an addedHandler() in its constructor,
			// which makes it runs before any other "added" handlers except
			// capture-phase ones; it sets up the child's styles.
			
			//$addChildAt(child, index);
			$addChild(child);
			
			// Do anything that needs to be done after the child is added
			// and after all "added" handlers have executed.
			// This is where
			childAdded(child);
			
			return child;
		}
		
		gameant final function $addChild(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		gameant function childAdded(child:DisplayObject):void
		{
			if(child.hasEventListener(UIObjectEvent.ADD))
			{
				child.dispatchEvent(new UIObjectEvent(UIObjectEvent.ADD));
			}
		}
		gameant function addingChild(child:DisplayObject):void
		{
			if(child is IUIInterfaces)
			{
				IUIInterfaces(child).systemManager = systemManager;
				
				if (child is ILayoutManagerClient)
					ILayoutManagerClient(child).nestLevel = nestLevel + 1;
				
				if(!IUIInterfaces(child).initialized)
				{
					IUIInterfaces(child).initialize();
				}
			}
		}
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			var formerParent:DisplayObjectContainer = child.parent;
			if (formerParent && !(formerParent is Loader))
				formerParent.removeChild(child);
			
			addingChild(child);
			
			$addChildAt(child, index);
			
			childAdded(child);
			
			return child;
		}
		
		gameant final function $addChildAt(child:DisplayObject,
											   index:int):DisplayObject
		{
			return super.addChildAt(child, index);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			removingChild(child);
			
			$removeChild(child);
			
			childRemoved(child);
			return child;
		}
		gameant function removingChild(child:DisplayObject):void
		{
			if(child is IUIInterfaces)
			{
				IUIInterfaces(child).systemManager = null;
			}
		}
		
		gameant function childRemoved(child:DisplayObject):void
		{
			if(child.hasEventListener(UIObjectEvent.REMOVE))
			{
				child.dispatchEvent(new UIObjectEvent(UIObjectEvent.REMOVE));
			}
		}
		gameant final function $removeChild(child:DisplayObject):DisplayObject
		{
			return super.removeChild(child);
		}
		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = getChildAt(index);
			
			removingChild(child);
			
			$removeChild(child);
			
			childRemoved(child);
			
			return child;
		}
		gameant final function $removeChildAt(index:int):DisplayObject
		{
			return super.removeChildAt(index);
		}
		
		//----------------------------------
		//  	systemManager
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _systemManager:ISystemManager;
		
		/**
		 * 
		 */
		public function get systemManager():ISystemManager
		{
			if (!_systemManager)
			{
				var r:DisplayObject = root;
				if (r && !(r is Stage) && r is ISystemManager){
					_systemManager = (r as ISystemManager);
				}else if (r && r is Stage){
					_systemManager = Stage(r).getChildAt(0) as ISystemManager;
				}else{
					var o:DisplayObjectContainer = parent;
					while (o)
					{
						var ui:IUIInterfaces = o as IUIInterfaces;
						if (ui)
						{
							_systemManager = ui.systemManager;
							break;
						}
						else if (o is ISystemManager)
						{
							_systemManager = o as ISystemManager;
							break;
						}
						o = o.parent;
					}
				}
			}
			return _systemManager;
		}
		
		public function set systemManager(value:ISystemManager):void
		{
			_systemManager = value;
		}
		
		//----------------------------------
		//  	styleManager
		//----------------------------------
		
//		private var _styleManager:IStyleManager
//		
//		public function get styleManager():IStyleManager
//		{
//			if(!_styleManager)
//				_styleManager = StyleManager.getStyleManger();
//			return _styleManager;
//		}
//		
//		public function set styleManager(value:IStyleManager):void
//		{
//			_styleManager = value;
//		}
	}
}