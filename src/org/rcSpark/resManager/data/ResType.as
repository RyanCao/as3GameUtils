/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.resManager.data
{
//--------------------------------------------------------------------------
//
//  Imports
//
//--------------------------------------------------------------------------

/****
 * ResType.as class. Created Aug 18, 2012 10:58:43 AM
 * <br>
 * Description:
 * @author ryan
 * @langversion 3.0
 * @playerversion Flash 10
 ****/
public final class ResType
{
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    /**文本信息*/
    public static const TEXT:String="text";

    /**image图片,swf影片,如果是AVM1Movie的话,会返回*/
    public static const MOVIE:String="movie";

    /**image图片*/
    public static const IMAGE:String="image";

    /**AVM1Movie,转AVM2Movie*/
    public static const ToAVM2:String="toAVM2";

    /**二进制数据*/
    public static const BINARY:String="binary";
    /**
     * 所有支持的扩展名
     */
    public static var AVAILABLE_EXTENSIONS:Array=["swf", "jpg", "jpeg", "gif", "png", "flv", "mp3", "xml", "txt", "js"];
    /**
     * 各种资源类型扩展名
     */
    public static var IMAGE_EXTENSIONS:Array=["jpg", "jpeg", "gif", "png"];
    public static var MOVIECLIP_EXTENSIONS:Array=['swf'];
    public static var TEXT_EXTENSIONS:Array=["txt", "js", "php", "asp", "py"];
    public static var VIDEO_EXTENSIONS:Array=["flv", "f4v", "f4p", "mp4"];
    public static var SOUND_EXTENSIONS:Array=["mp3", "f4a", "f4b"];
    public static var XML_EXTENSIONS:Array=["xml"];

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    public function ResType()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  methods
    //
    //--------------------------------------------------------------------------

}

}