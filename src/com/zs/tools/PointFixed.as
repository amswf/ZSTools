/**
 *四点定位 ,通过四点来定位图片，图形
 */
package com.zs.tools
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	public class PointFixed extends Sprite
	{
		private var loader:Loader;
		private var skew:Skew;
		private var targetPoint:DragPoint;
		private var frame:Sprite = new Sprite();
		private var point1:DragPoint = new DragPoint();
		private var point2:DragPoint = new DragPoint();
		private var point3:DragPoint = new DragPoint();
		private var point4:DragPoint = new DragPoint();
		
		public function PointFixed()
		{
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN,showDragPoint);
			this.addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			this.addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN,onHideDragPoint);
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onHideDragPoint);
		}
		
		private function onHideDragPoint(event:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onHideDragPoint);
			point1.visible = false;
			point2.visible = false;
			point3.visible = false;
			point4.visible = false;
			frame.graphics.clear();
		}
		
		private function showDragPoint(event:MouseEvent):void
		{
			point1.visible = true;
			point2.visible = true;
			point3.visible = true;
			point4.visible = true;
			drawFrame();
		}
		
		private function onDragPic(event:MouseEvent):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_UP,onStopDrag);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStartDragImage);
			onStartDragImage(null);
		}
		
		protected function onStartDragImage(event:MouseEvent):void
		{
			this.startDrag(false,new Rectangle(this.mouseX,this.mouseY,this.stage.stageWidth,this.stage.stageHeight));
		}
		
		private function onStopDrag(event:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStartDragImage);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,onStopDrag);
			this.stopDrag();
		}
		
		private function drawFrame():void
		{
			frame.graphics.clear();
			frame.graphics.lineStyle(1,0);
			frame.graphics.moveTo(point1.x,point1.y);
			frame.graphics.lineTo(point2.x,point2.y);
			frame.graphics.lineTo(point3.x,point3.y);
			frame.graphics.lineTo(point4.x,point4.y);
			frame.graphics.lineTo(point1.x,point1.y);
			frame.graphics.endFill();
		}
		
		public function set imageUrl(url:String):void
		{
			loader = new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
		}
		
		private function onComplete(event:Event):void
		{
			skew = new Skew(this,Bitmap(loader.content).bitmapData,10,10);
			skew.imageContainer.addEventListener(MouseEvent.MOUSE_DOWN,onDragPic);
			
			this.addChild(frame);
			point1.visible = false;
			this.addChild(point1);
			
			point2.x = Bitmap(loader.content).width;
			point2.y = 0;
			point2.visible = false;
			this.addChild(point2);
			
			point3.x = Bitmap(loader.content).width;
			point3.y = Bitmap(loader.content).height;
			point3.visible = false;
			this.addChild(point3);
			
			point4.x = 0;
			point4.y = Bitmap(loader.content).height;
			point4.visible = false;
			this.addChild(point4);
			
			addEvent();
		}
		
		private function addEvent():void
		{
			point1.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			point2.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			point3.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			point4.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			targetPoint = DragPoint(event.target);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			targetPoint = null;
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			targetPoint.x = this.mouseX;
			targetPoint.y = this.mouseY;
			skew.setTransform(point1.x,point1.y,point2.x,point2.y,point3.x,point3.y,point4.x,point4.y);
			drawFrame();
			event.updateAfterEvent();
		}
	}
}
import flash.display.Sprite;

internal class DragPoint extends Sprite
{
	public function DragPoint()
	{
		this.graphics.clear();
		this.graphics.lineStyle(2,0xffffff);
		this.graphics.beginFill(0x000000);
		this.graphics.drawRect(-3,-3,6,6);
		this.graphics.endFill();
		this.buttonMode = true;
	}
}

import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.utils.getDefinitionByName; 
internal class Skew 
{
	
	//切割成多个三角形
	private var _container : DisplayObjectContainer;
	private var _sp : Sprite;
	private var _w : Number;
	private var _h : Number;
	private var _sMat : Matrix;
	private var _tMat : Matrix;
	private var _xMin:Number, _xMax:Number, _yMin:Number, _yMax : Number;
	private var _hP : Number;
	private var _vP : Number;
	private var _hsLen : Number;
	private var _vsLen : Number;
	private var _dotList : Array;
	private var _pieceList : Array;
	private var _imageBitmap : BitmapData;
	
	/* Constructor
	*
	* @param mc MovieClip :   图片容器
	* @param imageLink String : 图片库连接名
	* @param vP Number : 横向切割刀数
	* @param hP Number : 纵向切割刀数
	*/
	public function Skew(container:DisplayObjectContainer,image:BitmapData,vP:Number,hP:Number) {
		_container = container;
		_imageBitmap = BitmapData(image);
		_vP = vP > 20 || vP < 0 ? 2 : vP;
		_hP = hP > 20 || hP < 0 ? 2 : hP;
		_w = _imageBitmap.width;
		_h = _imageBitmap.height;
		init();
	}
	
	public function get imageContainer():Sprite
	{
		return _sp;
	}
	
	private function init() : void {
		_sp = new Sprite;
		_container.addChild(_sp);
		_dotList = [];
		_pieceList = [];
		var ix : Number;
		var iy : Number;
		var w2 : Number = _w / 2;
		var h2 : Number = _h / 2;
		_xMin = _yMin = 0;
		_xMax = _w;
		_yMax = _h;
		_hsLen = _w / (_hP + 1);
		//纵向每块的高
		_vsLen = _h / (_vP + 1);
		//横向每块的宽（根据精度来分割三角形）
		var x : Number, y : Number;
		for (ix = 0;ix < _vP + 2; ix++) {
			//分割的顶点集合
			for (iy = 0;iy < _hP + 2; iy++) {
				x = ix * _hsLen;
				y = iy * _vsLen;
				_dotList.push({x:x, y:y, sx:x, sy:y});
			}
		}
		for (ix = 0;ix < _vP + 1; ix++) {
			//分割成的三角形的顶点集合
			for (iy = 0;iy < _hP + 1; iy++) {
				_pieceList.push([_dotList[iy + ix * (_hP + 2)], _dotList[iy + ix * (_hP + 2) + 1], _dotList[iy + (ix + 1) * (_hP + 2)]]);
				_pieceList.push([_dotList[iy + (ix + 1) * (_hP + 2) + 1], _dotList[iy + (ix + 1) * (_hP + 2)], _dotList[iy + ix * (_hP + 2) + 1]]);
			}
		}
		render();
		//渲染
	}
	/* setTransform
	*
	* @param x0,y0 矩形左上控制点
	* @param x1,y1 矩形右上控制点
	* @param x2,y2 矩形右下控制点
	* @param x3,y4 矩形左下控制点
	*
	*/
	public function setTransform(x0 : Number, y0 : Number, x1 : Number, y1 : Number, x2 : Number, y2 : Number, x3 : Number, y3 : Number) : void {
		var w : Number = _w;
		var h : Number = _h;
		var dx30 : Number = x3 - x0;
		var dy30 : Number = y3 - y0;
		var dx21 : Number = x2 - x1;
		var dy21 : Number = y2 - y1;
		var l : Number = _dotList.length;
		while (--l > -1) {
			var point : Object = _dotList[l];
			var gx:Number = (point.x - _xMin) / w;
			var gy:Number = (point.y - _yMin) / h;
			var bx:Number = x0 + gy * (dx30);
			var by:Number = y0 + gy * (dy30);
			point.sx = bx + gx * ((x1 + gy * (dx21)) - bx);
			point.sy = by + gx * ((y1 + gy * (dy21)) - by);
		}
		render();
	}
	
	private function render() : void {
		var t : Number;
		var p0:Object, p1:Object, p2:Object;
		var c : Sprite = _sp;
		var a : Array;
		c.graphics.clear();
		_sMat = new Matrix();
		_tMat = new Matrix();
		var l : Number = _pieceList.length;
		while (--l > -1) {
			a = _pieceList[l];
			p0 = a[0];
			p1 = a[1];
			p2 = a[2];
			var x0 : Number = p0.sx;
			var y0 : Number = p0.sy;
			var x1 : Number = p1.sx;
			var y1 : Number = p1.sy;
			var x2 : Number = p2.sx;
			var y2 : Number = p2.sy;
			var u0 : Number = p0.x;
			var v0 : Number = p0.y;
			var u1 : Number = p1.x;
			var v1 : Number = p1.y;
			var u2 : Number = p2.x;
			var v2 : Number = p2.y;
			_tMat.tx = u0;
			_tMat.ty = v0;
			_tMat.a = (u1 - u0) / _w;
			_tMat.b = (v1 - v0) / _w;
			_tMat.c = (u2 - u0) / _h;
			_tMat.d = (v2 - v0) / _h;
			_sMat.a = (x1 - x0) / _w;
			_sMat.b = (y1 - y0) / _w;
			_sMat.c = (x2 - x0) / _h;
			_sMat.d = (y2 - y0) / _h;
			_sMat.tx = x0;
			_sMat.ty = y0;
			_tMat.invert();
			_tMat.concat(_sMat);
			c.graphics.beginBitmapFill(_imageBitmap, _tMat, false, false);
			c.graphics.moveTo(x0, y0);
			c.graphics.lineTo(x1, y1);
			c.graphics.lineTo(x2, y2);
			c.graphics.endFill();
		}
	}
}