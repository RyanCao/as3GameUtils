/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.tools.display
{
	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/****
	 * BitmapUtil.as class. Created Aug 17, 2012 12:58:01 AM
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/   	 
	public final class BitmapUtil
	{		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function BitmapUtil()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		/**
		 * 绘制并创建一个位图。这个位图能确保容纳整个图像。
		 * 
		 * @param displayObj
		 * @return 
		 * 
		 */
		public static function drawToBitmap(displayObj:DisplayObject,transparent:Boolean = true,fillColor:uint = 0x0,extend:int = 0):BitmapData
		{
			var rect:Rectangle = displayObj.getBounds(displayObj);
			var m:Matrix = new Matrix();
			m.translate(-rect.x+extend,-rect.y+extend);
			var bitmap:BitmapData = new BitmapData(Math.ceil(rect.width) + extend + extend,Math.ceil(rect.height) + extend + extend,transparent,fillColor);
			bitmap.draw(displayObj,m);
			return bitmap;
		}
		
		/**
		 * 用绘制的位图替换原来的显示对象，保持原来的坐标 
		 * @param displayObj
		 * @return 
		 * 
		 */
		public static function replaceWithBitmap(displayObj:DisplayObject,pixelSnapping:String = "auto",smoothing:Boolean = false,extend:int = 0):Bitmap
		{
			var bitmap:Bitmap = new Bitmap(drawToBitmap(displayObj,true,0,extend),pixelSnapping,smoothing);
			var rect:Rectangle = displayObj.getBounds(displayObj);
			bitmap.x = displayObj.x + rect.x - extend;
			bitmap.y = displayObj.y + rect.y - extend;
			return bitmap;
		}
		
		/**
		 * 缩放绘制位图填充某个区域 
		 * @param source
		 * @param target
		 * @param targetRect
		 * @param smoothing 平滑
		 */
		public static function drawToRectangle(source:IBitmapDrawable,target:BitmapData,targetRect:Rectangle,smoothing:Boolean = false):void
		{
			var m:Matrix = new Matrix();
			m.createBox(targetRect.width / source["width"],targetRect.height / source["height"],0,targetRect.x,targetRect.y);
			target.draw(source,m,null,null,null,smoothing);
		}
		
		/**
		 * 缩放BitmapData
		 * 
		 * @param source
		 * @param scaleX
		 * @param scaleY
		 * @return 
		 * 
		 */
		public static function scale(source:BitmapData,scaleX:Number =1.0,scaleY:Number = 1.0,disposeSource:Boolean = true):BitmapData
		{
			var result:BitmapData = new BitmapData(source.width * scaleX,source.height * scaleY,source.transparent,0xFFFFFF);
			var m:Matrix = new Matrix();
			m.scale(scaleX,scaleY);
			result.draw(source,m);
			if (disposeSource)
				source.dispose()
			return result;
		}
		
		/**
		 * 水平翻转
		 */
		public static function flipH(source:BitmapData,disposeSource:Boolean = true):BitmapData
		{
			var result:BitmapData = new BitmapData(source.width,source.height,source.transparent,0xFFFFFF);
			var m:Matrix = new Matrix();
			m.a = -m.a;
			m.tx = source.width;
			result.draw(source,m);
			if (disposeSource)
				source.dispose()
			return result;
		}
		
		/**
		 * 垂直翻转
		 */		
		public static function flipV(source:BitmapData,disposeSource:Boolean = true):BitmapData
		{
			var result:BitmapData = new BitmapData(source.width,source.height,source.transparent,0xFFFFFF);
			var m:Matrix = new Matrix();
			m.d = -m.d;
			m.ty = source.height;
			result.draw(source,m);
			if (disposeSource)
				source.dispose()
			return result;
		}
		
		/**
		 * 截取BitmapData
		 * 
		 * @param source
		 * @param clipRect
		 * @return 
		 * 
		 */
		public static function clip(source:BitmapData,clipRect:Rectangle,disposeSource:Boolean = true):BitmapData
		{
			var result:BitmapData = new BitmapData(clipRect.width,clipRect.height,source.transparent,0xFFFFFF);
			result.copyPixels(source,clipRect,new Point());
			if (disposeSource)
				source.dispose()
			return result;
		}
		
		/**
		 * 获得位图有像素的范围
		 * 
		 * @param source
		 * @return 
		 * 
		 */
		public static function getSoildRect(source:BitmapData):Rectangle
		{
			var mask:BitmapData = source.clone();
			mask.threshold(mask,mask.rect,new Point(),">",0,0xFFFFFFFF,0xFFFFFFFF);
			var clipRect:Rectangle = mask.getColorBoundsRect(0xFFFFFFFF,0xFFFFFFFF,true);
			mask.dispose();
			
			return clipRect;
		}
		
		/**
		 * 清除位图内容 
		 * 
		 * @param source
		 * 
		 */
		public static function clear(source:BitmapData):void
		{
			source.fillRect(source.rect,0);
		}
		
		/**
		 * 获取位图的非透明区域，可以用来做图片按钮的hitArea区域
		 * 
		 * @param source	图像源
		 * @return 
		 * 
		 */
		public static function getMask(source:BitmapData):Shape
		{
			var s:Shape = new Shape();
			s.graphics.beginFill(0);
			for(var i:int = 0;i < source.width;i++)
			{
				for(var j:int = 0;j < source.height;j++)
				{
					if (source.getPixel32(i,j))
						s.graphics.drawRect(i,j,1,1);
				}
			}
			s.graphics.endFill();
			return s;
		}
		
		/**
		 * 回收一个数组内所有的BitmapData
		 *  
		 * @param bitmapDatas
		 * 
		 */
		public static function dispose(items:Array):void
		{
			for each (var item:* in items)
			{
				if (item is BitmapData)
					(item as BitmapData).dispose();
				
				if (item is Bitmap)
				{
					(item as Bitmap).bitmapData.dispose();
					if ((item as Bitmap).parent)
						(item as Bitmap).parent.removeChild(item as Bitmap);
				}
			}
		}
		/**
		 * 分割ARGB
		 * @param _arg1
		 * @return 
		 * 
		 */		
		public static function splitARGB(_arg1:uint):Object{
			return ({
				a:((_arg1 >> 24) & 0xFF),
				r:((_arg1 >> 16) & 0xFF),
				g:((_arg1 >> 8) & 0xFF),
				b:(_arg1 & 0xFF)
			});
		}
		/**
		 * 消除空白像素 
		 * @param sourceBitmap BitmapData
		 * @return Object rect:bitmapData.rect<br>bitmapData:BitmapData
		 * 
		 */		
		public static function trim(sourceBitmap:BitmapData):Object{
			var destRect:Rectangle = sourceBitmap.rect.clone();
			var defaultPixel32:uint = sourceBitmap.getPixel32(0, 0);
			var h:int = 0;
			var w:int = 0;
			
			//获取destRect.top
			while (h < sourceBitmap.height) {
				w = 0;
				while (w < sourceBitmap.width) {
					if (defaultPixel32 != sourceBitmap.getPixel32(w, h)){
						break;
					}
					w++;
				}
				destRect.top++;
				h++;
			}
			
			//获取destRect.bottom
			h = (sourceBitmap.height - 1);
			while (h >= destRect.top) {
				w = 0;
				while (w < destRect.width) {
					if (defaultPixel32 != sourceBitmap.getPixel32(w, h)){
						break;
					}
					w++;
				}
				destRect.bottom--;
				h--;
			}
			
			//获取destRect.left
			w = 0;
			while (w < destRect.width) {
				h = destRect.top;
				while (h < destRect.bottom) {
					if (defaultPixel32 != sourceBitmap.getPixel32(w, h)){
						break;
					}
					h++;
				}
				destRect.left++;
				w++;
			}
			
			//获取destRect.right
			w = (destRect.width - 1);
			while (w >= destRect.left) {
				h = destRect.top;
				while (h < destRect.bottom) {
					if (defaultPixel32 != sourceBitmap.getPixel32(w, h)){
						break;
					}
					h++;
				}
				destRect.right--;
				w--;
			}
			
			//判断 是否是 空位图
			if ((destRect.width <= 0) || (destRect.height <= 0)){
				trace("空位图原样返回");
				return ({
					rect:sourceBitmap.rect.clone(),
					bitmapData:sourceBitmap.clone()
				});
			}
			
			var destBitmap:BitmapData = new BitmapData(destRect.width, destRect.height, sourceBitmap.transparent, 0);
			destBitmap.copyPixels(sourceBitmap, destRect, new Point(0, 0), null, null, true);
			return ({
				rect:destRect,
				bitmapData:destBitmap
			});
		}
	}
	
}