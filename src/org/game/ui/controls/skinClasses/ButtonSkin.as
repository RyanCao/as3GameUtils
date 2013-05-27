/*******************************************************************************
 * Class name:	ButtonSkin.as
 * Description:	
 * Author:		ryancao
 * Create:		Apr 7, 2013 4:55:26 PM
 * Update:		Apr 7, 2013 4:55:26 PM
 ******************************************************************************/
package org.game.ui.controls.skinClasses
{
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import org.game.ui.controls.buttonClasses.ButtonSkinState;
	import org.rcSpark.tools.display.FilterUtil;

	//-----------------------------------------------------------------------------
	// import_declaration
	//-----------------------------------------------------------------------------
	
	public class ButtonSkin extends SkinBase
	{
		//-----------------------------------------------------------------------------
		// Var
		//-----------------------------------------------------------------------------
		private var skinMap:Object = {};
		private var currentSkin:DisplayObject;
		//-----------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------
		public function ButtonSkin(skinMap:Object, hitSkin:DisplayObject = null)
		{
			super();
			this.skinMap = skinMap;
			if(!this.hitSkin && skinMap[ButtonSkinState.UP])
			{
				var className:String = getQualifiedClassName(skinMap[ButtonSkinState.UP]);
				var objClass:Class = getDefinitionByName(className) as Class;
				this.hitSkin = new objClass();
			}
		}
		
		//-----------------------------------------------------------------------------
		// Methods
		//-----------------------------------------------------------------------------
		override protected function stateChanged():void
		{
			super.stateChanged();
			
			if(currentSkin)
			{
				removeChild(currentSkin);
			}
			
			currentSkin = skinMap[currentState];
			if(!currentSkin)
			{
				currentSkin = skinMap[ButtonSkinState.UP];
				if(currentState == ButtonSkinState.DISABLED){
					this.filters = [FilterUtil.getBlackAndWhiteFilter()]
				}else{
					this.filters = null;
				}
			}
			else
			{
				this.filters = null;
			}
			addChildAt(currentSkin, 0);
			
			invalidateDisplayList();
		}
		
		override protected function measure():void
		{
			if(currentSkin)
			{
				this.measuredWidth = currentSkin.width;
				this.measuredHeight = currentSkin.height;
			}
			else
			{
				this.measuredWidth = 0;
				this.measuredHeight = 0;
			}
		}
		
		override protected function updateDisplayList(unscaleWidth:Number, unscaleHeight:Number):void
		{
			if(!isNaN(explicitWidth))
			{
				currentSkin.width = explicitWidth;
				if(hitSkin)
					hitSkin.width = explicitWidth;
			}
			
			if(!isNaN(explicitHeight))
			{
				currentSkin.height = explicitHeight;
				if(hitSkin)
					hitSkin.height = explicitHeight;
			}
		}
	}
}