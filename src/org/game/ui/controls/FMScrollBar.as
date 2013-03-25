package org.game.ui.controls {
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import flash.geom.*;

    public class FMScrollBar extends Sprite {

        private const _arrowSpeed:Number = 1;
        private const _timerDelay:Number = 0;

        private var _sp_barBG:Sprite;
        private var _targetOX:Number;
        private var _targetOY:Number;
        private var _barHeight:Number;
        private var _dragHeight:Number;
        private var _sp_dragBarImg:Sprite;
        private var _trigColor:uint;
        private var _timerArrowDown:Timer;
        private var _target:DisplayObject;
        private var _sp_arrowUp:Sprite;
        private var _maskWidth:Number;
        private var _sp_arrowDown:Sprite;
        private var _dataBarY:Number;
        private var _maskHeight:Number;
        private var _sp_mask:Sprite;
        private var _borderColor:uint;
        private var _barWidth:Number;
        private var _enterFrameHeight:Number = 0;
        private var _timerArrowUp:Timer;
        private var _bgColor:uint;
        private var _sp_trigDown:Sprite;
        private var _dataDownY:Number;
        private var _barColor:uint;
        private var _sp_barBGClick:Sprite;
        private var _sp_trigUp:Sprite;
        private var _sp_dragBar:Sprite;

        public function FMScrollBar(target:DisplayObject=null, thisX:Number=0, thisY:Number=0, maskWidth:Number=100, maskHeight:Number=100, barHeight:Number=200, barWidth:Number=8, dragHeight:Number=40, barColor:uint=0, trigColor:uint=0xFFFFFF, bgColor:uint=0xFFFFFF, borderColor:uint=0x606060){
            super();
            this._target = target;
            this.x = thisX;
            this.y = thisY;
            this._maskWidth = maskWidth;
            this._maskHeight = maskHeight;
            this._barHeight = barHeight;
            this._barColor = barColor;
            this._trigColor = trigColor;
            this._bgColor = bgColor;
            this._borderColor = borderColor;
            this._targetOX = target.x;
            this._targetOY = target.y;
            this._barWidth = barWidth;
            this._dragHeight = dragHeight;
            this.buildBar();
        }
        private function buildMask():void{
            this._sp_mask = new Sprite();
            this._sp_mask.graphics.beginFill(0xFF00);
            this._sp_mask.graphics.lineStyle(undefined);
            this._sp_mask.graphics.drawRect(0, 0, this._maskWidth, this._maskHeight);
            this._sp_mask.graphics.endFill();
            this._sp_mask.x = (this._targetOX - this.x);
            this._sp_mask.y = (this._targetOY - this.y);
            this._target.mask = this._sp_mask;
            this.addChild(this._sp_mask);
        }
        private function listenerDragOver(evt:MouseEvent):void{
            this._sp_dragBarImg.alpha = 0.5;
        }
        private function initScroll():void{
            this.addEventListener(Event.ENTER_FRAME, listenerTargetResize);
            this._target.addEventListener(Event.REMOVED_FROM_STAGE, listenerTargetRemoved);
        }
        private function dragDown():void{
            this._dataDownY = this.mouseY;
            this._dataBarY = this._sp_dragBar.y;
            this._sp_dragBar.stage.addEventListener(MouseEvent.MOUSE_UP, listenerDragUp);
            this._sp_dragBar.stage.addEventListener(MouseEvent.MOUSE_MOVE, listenerDraging);
        }
        private function timerArrowDown(evt:TimerEvent):void{
            this._sp_dragBar.y = this.checkDragBarPosition((this._sp_dragBar.y + this._arrowSpeed));
            this.changeTargetPosition();
        }
        private function dragUp():void{
            this._sp_dragBar.stage.removeEventListener(MouseEvent.MOUSE_MOVE, listenerDraging);
            this._sp_dragBar.stage.removeEventListener(MouseEvent.MOUSE_UP, listenerDragUp);
        }
        private function buildArrowUp():void{
            this._sp_arrowUp = new Sprite();
            this._sp_arrowUp.graphics.beginFill(this._borderColor);
            this._sp_arrowUp.graphics.lineStyle(undefined);
            this._sp_arrowUp.graphics.drawRect(0, 0, this._barWidth, this._barWidth);
            this._sp_arrowUp.graphics.endFill();
            this._sp_arrowUp.graphics.beginFill(this._barColor);
            this._sp_arrowUp.graphics.lineStyle(undefined);
            this._sp_arrowUp.graphics.drawRect(1, 1, (this._barWidth - 2), (this._barWidth - 2));
            this._sp_arrowUp.graphics.endFill();
            this.addChild(this._sp_arrowUp);
            this.buildTrigUp();
        }
        private function arrowDownDown():void{
            this._timerArrowDown = new Timer(this._timerDelay, 0);
            this._timerArrowDown.addEventListener(TimerEvent.TIMER, timerArrowDown);
            this._timerArrowDown.start();
            this._sp_arrowDown.stage.addEventListener(MouseEvent.MOUSE_UP, listenerArrowDown);
        }
        private function listenerBGClick(evt:MouseEvent):void{
            this.bgClick();
        }
        private function buildBGClick():void{
            this._sp_barBGClick = new Sprite();
            this._sp_barBGClick.graphics.beginFill(this._bgColor);
            this._sp_barBGClick.graphics.lineStyle(undefined);
            this._sp_barBGClick.graphics.drawRect(0, 0, (this._barWidth - 2), (this._barHeight - 2));
            this._sp_barBGClick.graphics.endFill();
            this._sp_barBGClick.x = (this._sp_barBGClick.y = 1);
            this._sp_barBG.addChild(_sp_barBGClick);
            this._sp_barBGClick.addEventListener(MouseEvent.CLICK, listenerBGClick);
        }
        private function listenerDragOut(evt:MouseEvent):void{
            this._sp_dragBarImg.alpha = 1;
        }
        private function checkVisible():Boolean{
            if (this._target.height <= this._maskHeight){
                this._target.y = this._targetOY;
                this._sp_dragBar.y = this._barWidth;
                this.setVisible(false);
                return (false);
            };
            if ((this._targetOY - this._target.y) > (this._target.height - this._maskHeight)){
                this._target.y = (this._targetOY - (this._target.height - this._maskHeight));
            };
            this.setDragBarPosition(((this._targetOY - this._target.y) / (this._target.height - this._maskHeight)));
            this.setVisible(true);
            return (true);
        }
        private function draging():void{
            this._sp_dragBar.y = this.checkDragBarPosition(((this._dataBarY + this.mouseY) - this._dataDownY));
            this.changeTargetPosition();
        }
        private function changeTargetPosition():void{
            var per:Number = ((this._sp_dragBar.y - this._barWidth) / ((this._barHeight - (2 * this._barWidth)) - this._dragHeight));
            this._target.y = (this._targetOY - ((this._target.height - this._maskHeight) * per));
        }
        private function listenerArrowDownDown(evt:MouseEvent):void{
            this.arrowDownDown();
        }
        private function listenerArrowUp(evt:MouseEvent):void{
            this._timerArrowUp.stop();
            this._sp_arrowUp.stage.removeEventListener(MouseEvent.MOUSE_UP, listenerArrowUp);
            this._timerArrowUp.removeEventListener(TimerEvent.TIMER, timerArrowUp);
        }
        private function bgClick():void{
            this.setDragBarPosition(((this._sp_barBGClick.mouseY - this._barWidth) / (this._barHeight - (2 * this._barWidth))));
        }
        private function buildBar():void{
            this.buildBG();
            this.buildArrow();
            this.buildDragBar();
            this.buildMask();
            this.initScroll();
        }
        private function arrowUpDown():void{
            this._timerArrowUp = new Timer(this._timerDelay, 0);
            this._timerArrowUp.addEventListener(TimerEvent.TIMER, timerArrowUp);
            this._timerArrowUp.start();
            this._sp_arrowUp.stage.addEventListener(MouseEvent.MOUSE_UP, listenerArrowUp);
        }
        private function buildBG():void{
            this._sp_barBG = new Sprite();
            this._sp_barBG.graphics.beginFill(this._borderColor);
            this._sp_barBG.graphics.lineStyle(undefined);
            this._sp_barBG.graphics.drawRect(0, 0, this._barWidth, this._barHeight);
            this._sp_barBG.graphics.endFill();
            this.addChild(_sp_barBG);
            this.buildBGClick();
        }
        private function setDragBarPosition(per:Number):void{
            this._sp_dragBar.y = (this._barWidth + (((this._barHeight - (2 * this._barWidth)) - this._dragHeight) * per));
            this.changeTargetPosition();
        }
        private function listenerArrowUpOver(evt:MouseEvent):void{
            this._sp_trigUp.alpha = 0.5;
        }
        private function buildArrow():void{
            this.buildArrowUp();
            this.buildArrowDown();
        }
        private function listenerArrowDownOut(evt:MouseEvent):void{
            this._sp_trigDown.alpha = 1;
        }
        private function buildDragImg():void{
            var fillType:String = GradientType.LINEAR;
            var colors:Array = [this._borderColor, this._borderColor, this._borderColor];
            var alphas:Array = [0, 1, 0];
            var ratios:Array = [0, 127, 0xFF];
            var matr:Matrix = new Matrix();
            matr.createGradientBox(this._sp_dragBar.width, this._sp_dragBar.height, (Math.PI / 2), 0, 0);
            var spreadMethod:String = SpreadMethod.PAD;
            this._sp_dragBarImg = new Sprite();
            this._sp_dragBarImg.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
            this._sp_dragBarImg.graphics.drawRect(1, 1, (this._sp_dragBar.width - 2), (this._sp_dragBar.height - 2));
            this._sp_dragBarImg.x = 1;
            this._sp_dragBarImg.graphics.beginFill(this._borderColor);
            this._sp_dragBarImg.graphics.lineStyle(undefined);
            this._sp_dragBarImg.graphics.drawRect(1, 1, (this._sp_dragBar.width - 2), 1);
            this._sp_dragBarImg.graphics.endFill();
            this._sp_dragBarImg.graphics.beginFill(this._borderColor);
            this._sp_dragBarImg.graphics.lineStyle(undefined);
            this._sp_dragBarImg.graphics.drawRect(1, (this._sp_dragBar.height - 2), (this._sp_dragBar.width - 2), 1);
            this._sp_dragBarImg.graphics.endFill();
            this._sp_dragBar.addChild(this._sp_dragBarImg);
            this._sp_dragBar.addEventListener(MouseEvent.MOUSE_OVER, listenerDragOver);
            this._sp_dragBar.addEventListener(MouseEvent.MOUSE_OUT, listenerDragOut);
            this._sp_dragBar.addEventListener(MouseEvent.MOUSE_DOWN, listenerDragDown);
        }
        private function listenerDraging(evt:MouseEvent):void{
            this.draging();
        }
        private function listenerDragDown(evt:MouseEvent):void{
            this.dragDown();
        }
        private function checkDragBarPosition(py:Number):Number{
            if (py < this._barWidth){
                return (this._barWidth);
            };
            if (py > ((this._barHeight - this._dragHeight) - this._barWidth)){
                return (((this._barHeight - this._dragHeight) - this._barWidth));
            };
            return (py);
        }
        private function listenerTargetRemoved(evt:Event):void{
            trace("FMScrollBar Target Removed!!");
            this.setVisible(false);
            this.removeEventListener(Event.ENTER_FRAME, listenerTargetResize);
        }
        private function setVisible(b:Boolean):void{
            var b:* = b;
            if (b){
                this.alpha = 1;
                this._sp_dragBar.visible = true;
                this._sp_barBGClick.addEventListener(MouseEvent.CLICK, listenerBGClick);
                this._sp_arrowDown.addEventListener(MouseEvent.MOUSE_DOWN, listenerArrowDownDown);
                this._sp_arrowDown.addEventListener(MouseEvent.MOUSE_OVER, listenerArrowDownOver);
                this._sp_arrowDown.addEventListener(MouseEvent.MOUSE_OUT, listenerArrowDownOut);
                this._sp_arrowUp.addEventListener(MouseEvent.MOUSE_DOWN, listenerArrowUpDown);
                this._sp_arrowUp.addEventListener(MouseEvent.MOUSE_OVER, listenerArrowUpOver);
                this._sp_arrowUp.addEventListener(MouseEvent.MOUSE_OUT, listenerArrowUpOut);
            } else {
                this.alpha = 0.3;
                this._sp_dragBar.visible = false;
                try {
                    this._sp_dragBar.stage.removeEventListener(MouseEvent.MOUSE_UP, listenerDragUp);
                    this._sp_dragBar.stage.removeEventListener(MouseEvent.MOUSE_MOVE, listenerDraging);
                } catch(e:Error) {
                };
                try {
                    this._sp_arrowUp.stage.removeEventListener(MouseEvent.MOUSE_UP, listenerArrowUp);
                    this._timerArrowUp.removeEventListener(TimerEvent.TIMER, timerArrowUp);
                } catch(e2:Error) {
                };
                try {
                    this._sp_arrowDown.stage.removeEventListener(MouseEvent.MOUSE_UP, listenerArrowDown);
                    this._timerArrowDown.removeEventListener(TimerEvent.TIMER, timerArrowDown);
                } catch(e3:Error) {
                };
                this._sp_barBGClick.removeEventListener(MouseEvent.CLICK, listenerBGClick);
                this._sp_arrowDown.removeEventListener(MouseEvent.MOUSE_DOWN, listenerArrowDownDown);
                this._sp_arrowDown.removeEventListener(MouseEvent.MOUSE_OVER, listenerArrowDownOver);
                this._sp_arrowDown.removeEventListener(MouseEvent.MOUSE_OUT, listenerArrowDownOut);
                this._sp_arrowUp.removeEventListener(MouseEvent.MOUSE_DOWN, listenerArrowUpDown);
                this._sp_arrowUp.removeEventListener(MouseEvent.MOUSE_OVER, listenerArrowUpOver);
                this._sp_arrowUp.removeEventListener(MouseEvent.MOUSE_OUT, listenerArrowUpOut);
            };
        }
        private function listenerArrowDownOver(evt:MouseEvent):void{
            this._sp_trigDown.alpha = 0.5;
        }
        private function buildTrigUp():void{
            this._sp_trigUp = new Sprite();
            this._sp_trigUp.graphics.beginFill(this._trigColor);
            this._sp_trigUp.graphics.lineStyle(undefined);
            this._sp_trigUp.graphics.moveTo((this._sp_arrowUp.width / 2), 2);
            this._sp_trigUp.graphics.lineTo(1, (this._sp_arrowUp.height - 2));
            this._sp_trigUp.graphics.lineTo((this._sp_arrowUp.width - 1), (this._sp_arrowUp.height - 2));
            this._sp_trigUp.graphics.lineTo((this._sp_arrowUp.width / 2), 2);
            this._sp_trigUp.graphics.endFill();
            this._sp_arrowUp.addChild(this._sp_trigUp);
            this._sp_arrowUp.addEventListener(MouseEvent.MOUSE_DOWN, listenerArrowUpDown);
            this._sp_arrowUp.addEventListener(MouseEvent.MOUSE_OVER, listenerArrowUpOver);
            this._sp_arrowUp.addEventListener(MouseEvent.MOUSE_OUT, listenerArrowUpOut);
        }
        private function listenerDragUp(evt:MouseEvent):void{
            this.dragUp();
        }
        private function buildDragBar():void{
            this._sp_dragBar = new Sprite();
            this._sp_dragBar.graphics.beginFill(this._barColor);
            this._sp_dragBar.graphics.lineStyle(undefined);
            this._sp_dragBar.graphics.drawRect(1, 0, (this._barWidth - 2), this._dragHeight);
            this._sp_dragBar.graphics.endFill();
            this._sp_dragBar.y = this._barWidth;
            this.addChild(this._sp_dragBar);
            this.buildDragImg();
        }
        private function listenerArrowUpDown(evt:MouseEvent):void{
            this.arrowUpDown();
        }
        private function listenerArrowDown(evt:MouseEvent):void{
            this._timerArrowDown.stop();
            this._sp_arrowDown.stage.removeEventListener(MouseEvent.MOUSE_UP, listenerArrowDown);
            this._timerArrowDown.removeEventListener(TimerEvent.TIMER, timerArrowDown);
        }
        private function listenerTargetResize(evt:Event):void{
            var per:Number;
            if (this._target.height == this._enterFrameHeight){
                return;
            };
            this._enterFrameHeight = this._target.height;
            if (this.checkVisible()){
                per = ((this._targetOY - this._target.y) / (this._target.height - this._maskHeight));
                this.setDragBarPosition(per);
            };
        }
        private function buildTrigDown():void{
            this._sp_trigDown = new Sprite();
            this._sp_trigDown.graphics.beginFill(this._trigColor);
            this._sp_trigDown.graphics.lineStyle(undefined);
            this._sp_trigDown.graphics.moveTo((this._sp_arrowDown.width / 2), (this._sp_arrowDown.height - 2));
            this._sp_trigDown.graphics.lineTo(1, 2);
            this._sp_trigDown.graphics.lineTo((this._sp_arrowDown.width - 1), 2);
            this._sp_trigDown.graphics.lineTo((this._sp_arrowDown.width / 2), (this._sp_arrowDown.height - 2));
            this._sp_trigDown.graphics.endFill();
            this._sp_arrowDown.addChild(this._sp_trigDown);
            this._sp_arrowDown.addEventListener(MouseEvent.MOUSE_DOWN, listenerArrowDownDown);
            this._sp_arrowDown.addEventListener(MouseEvent.MOUSE_OVER, listenerArrowDownOver);
            this._sp_arrowDown.addEventListener(MouseEvent.MOUSE_OUT, listenerArrowDownOut);
        }
        private function buildArrowDown():void{
            this._sp_arrowDown = new Sprite();
            this._sp_arrowDown.graphics.beginFill(this._borderColor);
            this._sp_arrowDown.graphics.lineStyle(undefined);
            this._sp_arrowDown.graphics.drawRect(0, 0, this._barWidth, this._barWidth);
            this._sp_arrowDown.graphics.endFill();
            this._sp_arrowDown.graphics.beginFill(this._barColor);
            this._sp_arrowDown.graphics.lineStyle(undefined);
            this._sp_arrowDown.graphics.drawRect(1, 1, (this._barWidth - 2), (this._barWidth - 2));
            this._sp_arrowDown.y = (this._barHeight - this._barWidth);
            this._sp_arrowDown.graphics.endFill();
            this.addChild(this._sp_arrowDown);
            this.buildTrigDown();
        }
        private function listenerArrowUpOut(evt:MouseEvent):void{
            this._sp_trigUp.alpha = 1;
        }
        private function timerArrowUp(evt:TimerEvent):void{
            this._sp_dragBar.y = this.checkDragBarPosition((this._sp_dragBar.y - this._arrowSpeed));
            this.changeTargetPosition();
        }

    }
}//package com.fairycomic.FMScrollBar 