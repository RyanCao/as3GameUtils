/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.resManager.util
{
import flash.display.Bitmap;
import flash.display.BitmapData;

//--------------------------------------------------------------------------
//
//  Imports
//
//--------------------------------------------------------------------------

/****
 * DisposeUtil.as class. Created 3:39:09 PM Aug 18, 2012
 * <br>
 * Description:销毁工具类，主要用于销毁一个不知道是什么类型的组件（只用于基础组件）类似于BitmapData,Bitmap,Sprite,MovieClip,Loader
 * @author ryan
 * @langversion 3.0
 * @playerversion Flash 10
 ****/
public final class DisposeUtil
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
    public function DisposeUtil()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  methods
    //
    //--------------------------------------------------------------------------
    /**
     * 此方法不会移除 监听事件，需要自己手动移除，只会针对 （只用于基础组件）类似于BitmapData,Bitmap,Sprite,MovieClip,Loader
     * @param value
     *
     */
    static public function dispose(value:*):void{
        if(!value)
            return ;
        if(value is Bitmap)
            (value as Bitmap).bitmapData.dispose();
        if(value is BitmapData)
            (value as BitmapData).dispose();
    }
}
}