/**
 *      使用范例：
 *              var actions:Vector.<String> = new Vector.<String>();
 *                      actions.push('go_forword');
 *                      actions.push('go_left');
 *                      actions.push('go_right');
 *                      actions.push('go_back');
 *                      movie = new SheetMovie(new PNG1(),4,4,actions);
 *                      this.addChild(movie);
 *                      movie.go('go_forword');
 */
package com.zs.tools
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class SheetMovie extends Bitmap
	{
		private var _srcBitmap:Bitmap;//原型图 
		private var _actions:Vector.<String>;//动作序列
		private var _vLine:int;//横行图像个数 
		private var _actionWidth:int;
		private var _hLine:int;//竖行图像个数 
		private var _actionHeight:int;
		private var actionLine:int=0;//动作所对应的图片行数
		private var currentAction:int=0;//当前action，最大值不能大于_hLine
		
		public function SheetMovie(srcBitmap:Bitmap=null,vL:int=0,hL:int=0,actions:Vector.<String>=null)
		{
			sheet = srcBitmap;
			vLine = vL;
			hLine = hL;
			_actions = actions;
			super(null, "auto", false);
		}
		/**
		 * 设置原型图 
		 * @param value
		 * 
		 */             
		public function set sheet(value:Bitmap):void
		{
			_srcBitmap = value;
		}
		/**
		 * 横行图像个数 
		 * @param value
		 * 
		 */             
		public function set vLine(value:int):void
		{
			_vLine = value;
			_actionWidth = _srcBitmap.width / value;
			if(_actionWidth != 0 && _actionHeight != 0)
				this.bitmapData = new BitmapData(_actionWidth,_actionHeight);
		}
		/**
		 * 竖行图像个数 
		 * @param value
		 * 
		 */             
		public function set hLine(value:int):void
		{
			_hLine = value;
			_actionHeight = _srcBitmap.height / value;
			if(_actionWidth != 0 && _actionHeight != 0)
				this.bitmapData = new BitmapData(_actionWidth,_actionHeight);
		}
		/**
		 * 动作序列，每一横行的所有序列代表一个动作 
		 * 行数个数对应action动作个数
		 * @param value
		 * 
		 */             
		public function set actions(value:Vector.<String>):void
		{
			_actions = value;
		}
		
		public function go(action:String):void
		{
			actionLine = _actions.indexOf(action);
			this.addEventListener(Event.ENTER_FRAME,onAction);
		}
		
		private function onAction(e:Event):void
		{
			if(currentAction >= _vLine)
				currentAction = 0;
			this.bitmapData.lock();
			(this.stage)this.stage.frameRate = 8;
			var srcBitmap:* = _srcBitmap.bitmapData.getVector(new Rectangle(_actionWidth*currentAction,actionLine*_actionHeight,_actionWidth,_actionHeight));
			this.bitmapData.setVector(new Rectangle(0,0,_actionWidth,_actionHeight),srcBitmap);
			this.bitmapData.unlock();
			currentAction ++;
		}
		
		public function stop():void
		{
			this.removeEventListener(Event.ENTER_FRAME,onAction);
		}
	}
}