////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2005-2007 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package org.game.ui.managers
{

import flash.events.IEventDispatcher;

import org.game.gameant;

use namespace gameant;

public interface ILayoutManagerClient extends IEventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  initialized
    //----------------------------------

    /**
     *  A flag that determines if an object has been through all three phases
     *  of layout validation (provided that any were required)
     *  This flag should only be modified by the LayoutManager.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get initialized():Boolean;
    
    /**
     *  @private
     */
    //function set initialized(value:Boolean):void;

    //----------------------------------
    //  nestLevel
    //----------------------------------

    /**
     *  The top-level SystemManager has a nestLevel of 1.
     *  Its immediate children (the top-level Application and any pop-up
     *  windows) have a <code>nestLevel</code> of 2.
     *  Their children have a <code>nestLevel</code> of 3, and so on.  
     *
     *  The <code>nestLevel</code> is used to sort ILayoutManagerClients
     *  during the measurement and layout phases.
     *  During the commit phase, the LayoutManager commits properties on clients
     *  in order of increasing <code>nestLevel</code>, so that an object's
     *  children have already had their properties committed before Flex 
     *  commits properties on the object itself.
     *  During the measurement phase, the LayoutManager measures clients
     *  in order of decreasing <code>nestLevel</code>, so that an object's
     *  children have already been measured before Flex measures
     *  the object itself.
     *  During the layout phase, the LayoutManager lays out clients
     *  in order of increasing <code>nestLevel</code>, so that an object
     *  has a chance to set the sizes of its children before the child
     *  objects are asked to position and size their children.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get nestLevel():int;
    
    /**
     *  @private
     */
    function set nestLevel(value:int):void;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Validates the properties of a component.
     *  If the <code>LayoutManager.invalidateProperties()</code> method is called with
     *  this ILayoutManagerClient, then the <code>validateProperties()</code> method
     *  is called when it's time to commit property values.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function validateProperties():void;
    
    /**
     *  Validates the measured size of the component
     *  If the <code>LayoutManager.invalidateSize()</code> method is called with
     *  this ILayoutManagerClient, then the <code>validateSize()</code> method
     *  is called when it's time to do measurements.
     *
     *  @param recursive If <code>true</code>, call this method
     *  on the objects children.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function validateSize(recursive:Boolean = false):void;
    
    /**
     *  Validates the position and size of children and draws other
     *  visuals.
     *  If the <code>LayoutManager.invalidateDisplayList()</code> method is called with
     *  this ILayoutManagerClient, then the <code>validateDisplayList()</code> method
     *  is called when it's time to update the display list.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function validateDisplayList():void;
}

}
