package org.game.ui.controls {
    import flash.display.*;

	public class TextSpBg extends Sprite {
		private var _w : int = 120;
		private var _h : int = 20;
		
		private var _lineThick:int = 1;
		private var _lineColor:uint = 0x227700;
		private var _lineAlpha:Number = 1;
		
		private var _backColor : uint = 0x443388;
		private var _backAlpha : Number = 1;
		
        public function TextSpBg(){
            super();
            commitProperties();
        }
        
        public function setSize(w:int,h:int):void{
			if(_w==w && _h==h)
				return ;
			_w = w ;
			_h = h ;
			commitProperties();
		}
		
		public function setStyle(lt:int = 1, lc:uint = 0x227700 ,la:Number = 1,bc:uint = 0xEEEEEE,ba:Number = 1):void{
			_lineThick = lt ;
			_lineColor = lc ;
			_lineAlpha = la ;
			_backColor = bc ;
			_backAlpha = ba ;
			commitProperties();
		}
		
		internal function commitProperties():void{
			graphics.clear();
            graphics.lineStyle(_lineThick, _lineColor , _lineAlpha);
            graphics.moveTo(0, 0);
            
            if(_w > 0 && _h>0){
	            graphics.lineTo(_w, 0);
	            graphics.lineTo(_w, _h);
	            graphics.lineTo(0, _h);
	            graphics.lineTo(0, 0);
            }
            if(_w > 2 && _h>2){
	            graphics.beginFill(_backColor,_backAlpha);
	            graphics.drawRect(1, 1, _w-2, _h-2);
	            graphics.endFill();
            }
		}
    }
}//package 