/**
 *  Copyright (c) 2009 - 2010 LOOKBACKON All rights reserved.
 */
package org.game.ui.controls.pageClasses
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	
	//--------------------------------------------------------------------------
	//
	//  Imports
	//
	//--------------------------------------------------------------------------
	
	/****
	 * PageUI.as class. Created Sep 25, 2013 5:56:55 PM
	 * <br>
	 * Description:
	 * @author ryan
	 * @langversion 3.0
	 * @playerversion Flash 10
	 ****/   	 
	public class PageUI
	{		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private var owner : DisplayObjectContainer;
		private var view : IPageUIView;
		private var _eventDispatcher : EventDispatcher;
		private var _pageSize : int;
		private var _currentPage : int;
		private var _recordCount : int;
		private var _startRecord : int;
		private var _endRecord : int;
		private var _pageCount : int;
		private var _dataprovider : Array;
		private var hasData : Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function PageUI(owner : DisplayObjectContainer, view : IPageUIView = null)
		{
			this.owner = owner;
			this.setView(view);
			_eventDispatcher = new EventDispatcher();
		}
		
		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		public function setView(_view : IPageUIView) : void {
			if (_view == null) {
				_view = new DefaultPageUIView();
			}
			
			view = _view;
			owner.addChild(this.view as DisplayObject);
			
			view.addEventListener(PageEvent.HOME_PAGE, onPageChangeHandle);
			view.addEventListener(PageEvent.END_PAGE, onPageChangeHandle);
			view.addEventListener(PageEvent.PRE_PAGE, onPageChangeHandle);
			view.addEventListener(PageEvent.NEXT_PAGE, onPageChangeHandle);
		}
		
		
		private function onPageChangeHandle(event : PageEvent) : void {
			var _residueRecord : int;
			switch(event.type) {
				case PageEvent.HOME_PAGE:
					_currentPage = 1;
					_startRecord = 1;
					_endRecord = _startRecord + _pageSize;
					view.setPageString(_currentPage, _pageCount);
					break;
				case PageEvent.END_PAGE:
					_currentPage = _pageCount;
					_startRecord = (_currentPage - 1) * _pageSize + 1;
					_residueRecord = (_recordCount % _pageSize == 0) ? _pageSize : _recordCount % _pageSize;
					_endRecord = _startRecord + _residueRecord;
					view.setPageString(_currentPage, _pageCount);
					break;
				case PageEvent.PRE_PAGE:
					if (_pageCount == 0)
						return ;
					if (_currentPage > 1) {
						_currentPage -= 1;
						if (_currentPage == 1)
							_startRecord = 1;
						else
							_startRecord = (_currentPage - 1) * _pageSize + 1;
						_endRecord = _startRecord + _pageSize;
					} else {
						_currentPage = _pageCount;
						_startRecord = (_currentPage - 1) * _pageSize + 1;
						// 取余
						_residueRecord = (_recordCount % _pageSize == 0) ? _pageSize : _recordCount % _pageSize;
						_endRecord = _startRecord + _residueRecord;
					}
					view.setPageString(_currentPage, _pageCount);
					break;
				case PageEvent.NEXT_PAGE:
					if (_pageCount == 0)
						return ;
					if (_currentPage < _pageCount) {
						_currentPage += 1;
						_startRecord = (_currentPage - 1) * _pageSize + 1;
						if (_currentPage == _pageCount) {
							// 取余
							_residueRecord = (_recordCount % _pageSize == 0) ? _pageSize : _recordCount % _pageSize;
							_endRecord = _startRecord + _residueRecord;
						} else {
							_endRecord = _startRecord + _pageSize;
						}
					} else {
						_currentPage = 1;
						_startRecord = 1;
						_endRecord = _startRecord + _pageSize;
					}
					view.setPageString(_currentPage, _pageCount);
					break;
			}
			
			var evt : PageEvent = new PageEvent(PageEvent.PAGE_CHANGED);
			if (hasData) {
				evt.data = showDataProvider ;
			} else {
				evt.data = [_startRecord, _endRecord - _startRecord] ;
			}
			_eventDispatcher.dispatchEvent(evt);
		}
		
		public function getView() : IPageUIView {
			return view;
		}
		
		// 设置每页记录数
		public function set pageSize(pagesize : int) : void {
			_pageSize = pagesize;
		}
		
		// 跳转到当前页码
		public function set currentPage(currentPage : int) : void {
			_currentPage = currentPage;
			
			if (_currentPage > _pageCount)
				_currentPage = _pageCount ;
			
			_startRecord = (_currentPage - 1) * _pageSize + 1;
			
			if (_currentPage == _pageCount) {
				// 取余
				var _residueRecord : int = (_recordCount % _pageSize == 0) ? _pageSize : _recordCount % _pageSize;
				_endRecord = _startRecord + _residueRecord;
			} else {
				_endRecord = _startRecord + _pageSize;
			}
			
			view.setPageString(_currentPage, _pageCount);
			
			var evt : PageEvent = new PageEvent(PageEvent.PAGE_CHANGED);
			if (hasData) {
				evt.data = showDataProvider ;
				_eventDispatcher.dispatchEvent(evt);
			} else {
				evt.data = [_startRecord, _endRecord - _startRecord] ;
				_eventDispatcher.dispatchEvent(evt);
			}
		}
		
		// 设置 数组
		public function set dataProvider(arr : Array) : void {
			_dataprovider = arr ;
			if (arr){
				if(_recordCount != arr.length||arr.length == 0)
					recordCount = arr.length;
			}else
				recordCount = 0 ;
			var evt : PageEvent = new PageEvent(PageEvent.PAGE_CHANGED);
			if (hasData) {
				evt.data = showDataProvider ;
			} else {
				evt.data = [_startRecord, _endRecord - _startRecord] ;
			}
			evt.is_Data_Update = true ;
			_eventDispatcher.dispatchEvent(evt);
		}
		
		// 记录总数改变
		public function set recordCount(recordCount : int) : void {
			if (_dataprovider) {
				hasData = true ;
			} else {
				hasData = false ;
			}
			_recordCount = recordCount;
			_pageCount = Math.ceil(_recordCount / _pageSize);
			if (_pageCount > 0) {
				_currentPage = 1 ;
				_startRecord = 1;
				_endRecord = _startRecord + _pageSize;
			}
			view.setPageString(_currentPage, _pageCount);
		}
		
		// 获取起始记录数
		public function get startRecord() : int {
			return _startRecord;
		}
		
		// 获取结束记录数
		public function get endRecord() : int {
			return _endRecord;
		}
		
		public function get pageCount():int{
			return _pageCount;
		}
		
		// 获取显示所需的数组内容
		public function get showDataProvider() : Array {
			return _dataprovider.slice(_startRecord - 1, _endRecord - 1);
		}
		
		public function addEventListener(pageChanged : String, onPagerChanged : Function) : void {
			_eventDispatcher.addEventListener(pageChanged, onPagerChanged);
		}
		
		public function removeEventListener(pageChanged : String, onPagerChanged : Function) : void {
			_eventDispatcher.removeEventListener(pageChanged, onPagerChanged);
		}
		
		public function get currentPage() : int {
			return _currentPage;
		}
		
		public function dispose():void{
			_eventDispatcher = null ;
			if(view){
				view.removeEventListener(PageEvent.HOME_PAGE, onPageChangeHandle);
				view.removeEventListener(PageEvent.END_PAGE, onPageChangeHandle);
				view.removeEventListener(PageEvent.PRE_PAGE, onPageChangeHandle);
				view.removeEventListener(PageEvent.NEXT_PAGE, onPageChangeHandle);
				if(owner && owner.contains(view as DisplayObject)){
					owner.removeChild(view as DisplayObject);
					owner = null ;
				}
				view.dispose();
				view = null ;
			}
			_dataprovider = null ;
		}
	}
	
}