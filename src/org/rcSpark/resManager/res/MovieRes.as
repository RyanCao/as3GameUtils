/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.rcSpark.resManager.res
{
//--------------------------------------------------------------------------
//
//  Imports
//
//--------------------------------------------------------------------------
import flash.display.AVM1Movie;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.system.LoaderContext;
import flash.utils.ByteArray;

import org.rcSpark.resManager.util.DisposeUtil;

/****
 * MovieRes.as class. Created 2:46:09 PM Aug 20, 2012
 * <br>
 * Description:
 * @author ryan
 * @langversion 3.0
 * @playerversion Flash 10
 ****/
public class MovieRes extends BaseRes
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
    public function MovieRes(target:IEventDispatcher=null)
    {
        super(target);
        _loader = new Loader();
    }

    //--------------------------------------------------------------------------
    //
    //  methods
    //
    //--------------------------------------------------------------------------
    override public function loadBytes(bytes:ByteArray, ct:LoaderContext):void
    {
        try
        {
            var loader:Loader=_loader as Loader;
            if(!loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
            if(!loader.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR))
                loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandle);
            loader.loadBytes(bytes, ct);
        }
        catch(e:*)
        {
            throw(new Error("ResError--:MovieRes"+this.toString()));
        }
    }

    override protected function onCompleteHandler(evt:Event):void
    {
        if (evt.type == Event.COMPLETE)
        {
            if (this._content is AVM1Movie)
            {
                //trace(this + " content is AMV1Movie");
                this._content = this._loader;
            }
            else
            {
                this._content=(this._loader as Loader).content;
            }
        }
        super.onCompleteHandler(evt);
    }

    /** Gets a  definition from a fully qualified path (can be a Class, function or namespace).
     @param className The fully qualified class name as a string.
     @return The definition object with that name or null of not found.
     */
    public function getDefinitionByName(className : String) : Object{
        var loader:Loader=_loader as Loader;
        if (loader.contentLoaderInfo.applicationDomain.hasDefinition(className)){
            return loader.contentLoaderInfo.applicationDomain.getDefinition(className);
        }
        return null;
    }

    override public function dispose():void
    {
        super.dispose();
        var loader:Loader=_loader as Loader;
        if(loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler);
        if(loader.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR))
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandle);
        loader.unload();
        loader = null ;
        DisposeUtil.dispose(_content);
        _content = null ;
    }
}
}