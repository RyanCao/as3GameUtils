/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.resManager.events
{
	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	import flash.events.Event;
	
	
	/****
	 * DataEvent.as class. Created 3:53:25 PM Aug 20, 2012
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/
	public class DataEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * 定义 <code>completed</code> 事件对象的 <code>type</code> 属性值。
		 *
		 * <p>此事件具有以下属性:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>属性</th><th>值</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>false</code>; 没有要取消的默认行为。</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理事件对象的对象。</td></tr>
		 *     <tr><td><code>bytesLoaded</code></td><td><code>0</code>; 在侦听器处理事件时加载的项数或字节数。 </td></tr>
		 *     <tr><td><code>bytesTotal</code></td><td><code>0</code>; 如果加载过程成功，将加载的总项数或总字节数。</td></tr>
		 *     <tr><td><code>content</code></td><td><code>null</code>; 加载完成的内容 </td></tr>
		 *		<tr><td><code>target</code></td><td>调度了事件的对象。target 不一定是侦听该事件的对象。使用 currentTarget 属性可以访问侦听该事件的对象。</td></tr>
		 *  </table>
		 *
		 */
		public static const COMPLETED:String="completed_data";
		/**
		 * 定义 <code>error</code> 事件对象的 <code>type</code> 属性值。
		 *
		 * <p>此事件具有以下属性:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>属性</th><th>值</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>false</code>; 没有要取消的默认行为。</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理事件对象的对象。</td></tr>
		 *     <tr><td><code>target</code></td><td>报告安全错误的网络对象。</td></tr>
		 *  </table>
		 *
		 */
		public static const ERROR:String = "error_data";
		
		public var content:*;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function DataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		
	}
}