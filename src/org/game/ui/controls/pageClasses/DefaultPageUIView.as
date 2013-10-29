package org.game.ui.controls.pageClasses {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * @author ryan
	 */
	public class DefaultPageUIView extends Sprite implements IPageUIView {
		
		private var _pageString : TextField;
		private var _pageArrowLeft : Sprite;
		private var _pageArrowRight : Sprite;
		private var _currentPage : int;
		private var _pageCount : int;
		
		public function DefaultPageUIView() {
			
			_pageArrowLeft = new Arrow(16,16,0);
			_pageArrowRight = new Arrow(16,16,1);
			
			_pageArrowLeft.buttonMode = true ;
			_pageArrowRight.buttonMode = true ;
			// 将按钮及页码信息加入容器里
			addChild(_pageArrowLeft);
			_pageString = new TextField();
			_pageString.width = 40 ;
			_pageString.height = 20 ;
			_pageString.selectable = false ;
			_pageString.x = 20;
			addChild(_pageString);
			pageArrowRight.x = 60;
			addChild(_pageArrowRight);
			
			_pageArrowLeft.addEventListener(MouseEvent.CLICK, onPreClick);
			_pageArrowRight.addEventListener(MouseEvent.CLICK, onNextClick);
		}
		
		private function onNextClick(event : MouseEvent) : void {
			dispatchEvent(new PageEvent(PageEvent.NEXT_PAGE));
		}
		
		private function onPreClick(event : MouseEvent) : void {
			dispatchEvent(new PageEvent(PageEvent.PRE_PAGE));
		}
		
		// 更新页码信息
		public function updatePageString():void
		{
			_pageString.htmlText = _currentPage + "/" + _pageCount ;
		}
		
		public function setPageString(current : int = 0, total : int = 0) : void {
			_currentPage = current ;
			_pageCount = total ;
			updatePageString();
		}
		
		public function get pageArrowLeft() : DisplayObject {
			return _pageArrowLeft;
		}
		
		public function get pageArrowRight() : DisplayObject {
			return _pageArrowRight;
		}
		
		public function setStatus(status : int) : void {
			//设置 按钮的 状态
			_pageArrowLeft.mouseEnabled = Boolean(status&PageEvent.PRE_CODE);
			_pageArrowLeft.mouseEnabled = Boolean(status&PageEvent.NEXT_CODE);
		}
		
		public function dispose():void{
			_pageArrowLeft.removeEventListener(MouseEvent.CLICK, onPreClick);
			_pageArrowRight.removeEventListener(MouseEvent.CLICK, onNextClick);
			if(contains(_pageArrowLeft))
				removeChild(_pageArrowLeft);
			if(contains(_pageArrowRight))
				removeChild(_pageArrowRight);
			if(contains(_pageString))
				removeChild(_pageString);
			if(this.parent)
				parent.removeChild(this);
		}
		
	}
}

import flash.display.Sprite;

/**
 * @author ryan
 */
class Arrow extends Sprite {
	/**
	 *  0 : 1 : 2 : 3<br>
	 *  &lt; : &gt; : ^ : v
	 */
	private var _dir : int = 0;
	private var _w : int;
	private var _h : int;
	
	public function Arrow(w:int = 16 ,h:int = 16 ,dic:int = 0){
		_dir = dic ;
		_w = w;
		_h = h;
		draw();
	}
	private function draw() : void {
		graphics.clear();
		graphics.lineStyle(1,0,1);
		graphics.beginFill(0x6699cc,0.8);//填充
		switch(_dir)
		{
			case 0:
				graphics.moveTo(_w, 0);
				graphics.lineTo(0, _h/2);
				graphics.lineTo(_w, _h);
				graphics.lineTo(_w, 0);
				graphics.endFill();
				break;
			case 1:
				graphics.moveTo(0, 0);
				graphics.lineTo(_w, _h/2);
				graphics.lineTo(0, _h);
				graphics.lineTo(0, 0);
				graphics.endFill();
				break;
			case 2:
				graphics.moveTo(0, _h);
				graphics.lineTo(_w/2, 0);
				graphics.lineTo(_w, _h);
				graphics.lineTo(0, _h);
				graphics.endFill();
				break;
			case 3:
				graphics.moveTo(0, 0);
				graphics.lineTo(_w/2, _h);
				graphics.lineTo(_w, 0);
				graphics.lineTo(0, 0);
				graphics.endFill();
				break;
		}
	}
	/**
	 *  0 : 1 : 2 : 3<br>
	 *  &lt; : &gt; : ^ : v
	 */
	public function get dir() : int{
		return _dir;
	}
	
	/**
	 *  0 : 1 : 2 : 3<br>
	 *  &lt; : &gt; : ^ : v
	 */
	public function set dir(dic : int) : void{
		_dir=dic;
		draw();
	}
}
