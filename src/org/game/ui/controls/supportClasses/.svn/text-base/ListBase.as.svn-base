package etolib.components.supportClasses
{
import etolib.collections.IList;
import etolib.core.UIObject;
import etolib.events.CollectionEvent;
import etolib.skins.BorderSkin;

/**
 *
 * @author zhangyu 2012-10-31
 *
 **/
public class ListBase extends UIObject
{
	//--------------------------------------------------------------------------
	//		Constructor
	//--------------------------------------------------------------------------
	public function ListBase()
	{
		super();
	}
	//--------------------------------------------------------------------------
	//		Variables
	//--------------------------------------------------------------------------
	/**
	 * 边框皮肤 
	 */	
	private var borderSkin:BorderSkin;
	
	protected var itemContentChanged:Boolean = true;
	//--------------------------------------------------------------------------
	//		Propertise
	//--------------------------------------------------------------------------
	//------------------------------
	//		labelFiled
	//------------------------------
	private var _labelFiled:String = "";
	
	public function get labelFiled():String
	{
		return _labelFiled;
	}
	
	public function set labelFiled(value:String):void
	{
		_labelFiled = value;
	}
	
	//------------------------------
	//		dataProvider
	//------------------------------
	protected var _dataProvider:Object
	
	public function get dataProvider():Object
	{
		return _dataProvider;
	}
	
	public function set dataProvider(value:Object):void
	{
		if(_dataProvider)
		{
			_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, dataProvider_collectionChangeHandler);
			_dataProvider.removeEventListener(CollectionEvent.LIST_CHANGE, collectionListChangedHandler);
		}
		
		_dataProvider = value;
		
		if(_dataProvider)
		{
			_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, dataProvider_collectionChangeHandler);
			_dataProvider.addEventListener(CollectionEvent.LIST_CHANGE, collectionListChangedHandler);
		}
		
		invalidateProperties();
		invalidateSize();
		invalidateDisplayList();
		
		itemContentChanged = true;
	}
	
	//------------------------------
	//		itemRenderer
	//------------------------------
	protected var _itemRenderer:Object
	
	public function set itemRenderer(value:Object):void
	{
		if(value && _itemRenderer != value)
		{
			_itemRenderer = value;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			
			itemContentChanged = true;
		}
	}
	
	public function get itemRenderer():Object
	{
		return _itemRenderer;
	}
	//--------------------------------------------------------------------------
	//		Method
	//--------------------------------------------------------------------------
	override protected function createChildren():void
	{
		super.createChildren();
		
		if(!borderSkin)
		{
			borderSkin = new BorderSkin();
			addChild(borderSkin);
		}
	}
	override protected function updateDisplayList(unscaleWidth:Number, unscaleHeight:Number):void
	{
		super.updateDisplayList(unscaleWidth, unscaleHeight);
		
		if(borderSkin)
			borderSkin.update(this, unscaleWidth, unscaleHeight);
	}
	
	override public function dispose():void
	{
		super.dispose();
		
		if(_dataProvider)
		{
			_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, dataProvider_collectionChangeHandler);
			_dataProvider.removeEventListener(CollectionEvent.LIST_CHANGE, collectionListChangedHandler);
		}
	}
	//--------------------------------------------------------------------------
	//		Event Handler
	//--------------------------------------------------------------------------
	protected function collectionListChangedHandler(event:CollectionEvent):void
	{

	}
	
	protected function dataProvider_collectionChangeHandler(event:CollectionEvent):void
	{
		
	}
	//--------------------------------------------------------------------------
	//		Private
	//--------------------------------------------------------------------------
}
}