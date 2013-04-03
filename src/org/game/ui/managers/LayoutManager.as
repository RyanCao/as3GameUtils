/*******************************************************************************
 * Class name:	LayoutManager.as
 * Description:	
 * Author:		ryancao
 * Create:		Mar 27, 2013 8:54:15 PM
 * Update:		Mar 27, 2013 8:54:15 PM
 ******************************************************************************/
package org.game.ui.managers
{
	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.events.DynamicEvent;
	
	import org.game.ui.core.UIComponentGlobals;
	import org.game.ui.managers.layoutClasses.PriorityQueue;
	
	
	public class LayoutManager extends EventDispatcher implements ILayoutManager
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		private static var instance:LayoutManager;
		
		/**
		 * 系统管理器 
		 */	
		private var systemManager:ISystemManager;
		
		/**
		 * 是否允许属性更新 
		 */	
		private var invalidatePropertiesFlag:Boolean = false;
		
		/**
		 * 是否允许度量尺寸更新 
		 */	
		private var invalidateSizeFlag:Boolean = false;
		
		/**
		 * 是否允许布局更新
		 */	
		private var invalidateDisplayListFlag:Boolean = false;
		
		/**
		 * 属性更新队列 
		 */	
		private var invalidatePropertiseQueue:PriorityQueue = new PriorityQueue();
		/**
		 * 度量尺寸更新队列
		 */	
		private var invalidateSizeQueue:PriorityQueue = new PriorityQueue();
		
		/**
		 * 布局更新队列
		 */	
		private var invalidateDisplayListQueue:PriorityQueue = new PriorityQueue();
		
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function LayoutManager(target:IEventDispatcher=null)
		{
			super(target);
			systemManager = SystemManagerGlobals.topLevelSystemManager;
		}
		
		public static function getInstance():LayoutManager
		{
			if (!instance)
				instance = new LayoutManager();
			
			return instance;
		}
		
		public function get usePhasedInstantiation():Boolean
		{
			return false;
		}
		
		public function set usePhasedInstantiation(value:Boolean):void
		{
		}
		
		private function usingBridge(systemManager:ISystemManager):Stage
		{
			return null;
		}
		
		public function attachListeners(systemManager:ISystemManager):void
		{
			if (systemManager && systemManager.stage)
			{
				systemManager.addEventListener(Event.RENDER, doPhasedInstantiationCallback);
				systemManager.stage.invalidate();
			}
		}
		
		private function doPhasedInstantiationCallback(event:Event):void
		{
			systemManager.removeEventListener(Event.RENDER, doPhasedInstantiationCallback);		
			
			doPhasedInstantiation();
		}
		
		private function doPhasedInstantiation():void
		{      
			if(invalidatePropertiesFlag)
				validatePropertise();
			
			if(invalidateSizeFlag)
				validateSize();
			
			if (invalidateDisplayListFlag)
				validateDisplayList();
		}
		
		private function validatePropertise():void
		{
			var obj:ILayoutManagerClient = ILayoutManagerClient(invalidatePropertiseQueue.removeSmallest());
			while(obj)
			{
				obj.validateProperties();
				obj = ILayoutManagerClient(invalidatePropertiseQueue.removeSmallest());
			}
			
			if(invalidatePropertiseQueue.isEmpty())
			{
				invalidatePropertiesFlag = false;
			}
		}
		
		private function validateSize():void
		{
			var obj:ILayoutManagerClient = ILayoutManagerClient(invalidateSizeQueue.removeLargest());
			while(obj)
			{
				obj.validateSize();
				obj = ILayoutManagerClient(invalidateSizeQueue.removeLargest());
			}
			
			if(invalidateSizeQueue.isEmpty())
			{
				invalidateSizeFlag = false;
			}
		}
		
		private function validateDisplayList():void
		{
			var obj:ILayoutManagerClient = ILayoutManagerClient(invalidateDisplayListQueue.removeSmallest());
			while(obj)
			{
				obj.validateDisplayList();
				obj = ILayoutManagerClient(invalidateDisplayListQueue.removeSmallest());
			}
			
			if(invalidateDisplayListQueue.isEmpty())
			{
				invalidateDisplayListFlag = false;
			}
		}
		
		public function invalidateProperties(obj:ILayoutManagerClient):void
		{
			if (!invalidatePropertiesFlag)
			{
				invalidatePropertiesFlag = true;
				attachListeners(systemManager);
			}
			invalidatePropertiseQueue.addObject(obj, obj.nestLevel);
		}
		
		public function invalidateSize(obj:ILayoutManagerClient):void
		{
			if (!invalidateSizeFlag)
			{
				invalidateSizeFlag = true;
				
				attachListeners(systemManager);
			}
			invalidateSizeQueue.addObject(obj, obj.nestLevel);
		}
		public function invalidateDisplayList(obj:ILayoutManagerClient):void
		{
			if (!invalidateDisplayListFlag)
			{
				invalidateDisplayListFlag = true;
				
				attachListeners(systemManager);
			}
			invalidateDisplayListQueue.addObject(obj, obj.nestLevel);
		}
		
		public function validateNow():void
		{
			
		}
		
		public function validateClient(target:ILayoutManagerClient, skipDisplayList:Boolean=false):void
		{
		}
		
		public function isInvalid():Boolean
		{
			return false;
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
	}
}