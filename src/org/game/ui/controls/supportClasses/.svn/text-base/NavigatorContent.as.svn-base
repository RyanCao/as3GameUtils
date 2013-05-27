package etolib.components.supportClasses
{
import etolib.components.accordionClasses.IAccordionHeader;
import etolib.core.UIObject;
import etolib.core.eto_internal;
	
use namespace eto_internal;
/**
 *
 * @author zhangyu 2012-11-12
 *
 **/
public class NavigatorContent
{
	//--------------------------------------------------------------------------
	//		Constructor
	//--------------------------------------------------------------------------
	public function NavigatorContent(data:Object, content:UIObject)
	{
		this.data = data;
		this.content = content;
	}
	//--------------------------------------------------------------------------
	//		Variables
	//--------------------------------------------------------------------------
	//--------------------------------------------------------------------------
	//		Propertise
	//--------------------------------------------------------------------------
	private var _data:Object = null;

	public function get data():Object
	{
		return _data;
	}

	public function set data(value:Object):void
	{
		_data = value;
	}
	//------------------------------
	//		content
	//------------------------------
	private var _content:UIObject

	public function get content():UIObject
	{
		return _content;
	}

	public function set content(value:UIObject):void
	{
		_content = value;
	}

	//------------------------------
	//		button
	//------------------------------
	private var _header:IAccordionHeader

	eto_internal function get header():IAccordionHeader
	{
		return _header;
	}

	eto_internal function set header(value:IAccordionHeader):void
	{
		_header = value;
	}

	
	//--------------------------------------------------------------------------
	//		Method
	//--------------------------------------------------------------------------
	//--------------------------------------------------------------------------
	//		Event Handler
	//--------------------------------------------------------------------------
	//--------------------------------------------------------------------------
	//		Private
	//--------------------------------------------------------------------------
}
}