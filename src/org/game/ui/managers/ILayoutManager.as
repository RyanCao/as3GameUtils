////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2006-2007 Adobe Systems Incorporated
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

public interface ILayoutManager extends IEventDispatcher
{
	function get usePhasedInstantiation():Boolean;

	function set usePhasedInstantiation(value:Boolean):void;

	function invalidateProperties(obj:ILayoutManagerClient ):void;

	function invalidateSize(obj:ILayoutManagerClient ):void;

	function invalidateDisplayList(obj:ILayoutManagerClient ):void;

	//--------------------------------------------------------------------------
	//
	//  Methods: Commitment, measurement, layout, and drawing
	//
	//--------------------------------------------------------------------------

	function validateNow():void;

	function validateClient(target:ILayoutManagerClient, skipDisplayList:Boolean = false):void;

	function isInvalid():Boolean;
}

}
