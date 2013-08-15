package com.zs.effects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	
	public class MosaicEffect extends EventDispatcher
	{
		private var _pixelSize:Number = 1;
		private var _scaleMatrix:Matrix;
		private var _bitmapProcess:BitmapData;
		private var _bitmap:Bitmap;
		private var _source:DisplayObject;
		
		private var _outMod:Number = 0;
		private var _inMod:Number = 0;
		
		private var _pixelCutoff:int; // The max size of a pixel.
		
		public static const PIXELATION_SLOWEST:Number = .04;
		public static const PIXELATION_SLOW:Number = .07;
		public static const PIXELATION_MEDIUM:Number = .15;
		public static const PIXELATION_FAST:Number = .25;
		public static const PIXELATION_FASTEST:Number = .35;
		
		public static const FADE_OUT:String = "FADE_OUT";
		public static const FADE_IN:String = "FADE_IN";
		
		public function MosaicEffect(_source:DisplayObject)
		{
			this._source = _source;
			_pixelCutoff = _source.width > _source.height?_source.height/2:_source.width/2;
			_bitmap = new Bitmap(_bitmapProcess);
			_source.parent.addChild(_bitmap);
		}
		
		public function hide(_tempo:Number):void
		{
			_outMod = 1 + _tempo;
			_source.visible = false;
			_source.addEventListener(Event.ENTER_FRAME, pixelateOut);
		}
		
		public function show(_tempo:Number):void
		{
			_inMod = 1 - _tempo;
			_source.visible = false;
			_source.addEventListener(Event.ENTER_FRAME, pixelateIn);
		}
		
		private function pixelateIn(e:Event):void {
			_bitmapProcess = new BitmapData(_source.width/_pixelSize, _source.height/_pixelSize, true, 0);
			_scaleMatrix = new Matrix();
			_scaleMatrix.scale(1/_pixelSize, 1/_pixelSize);
			_bitmapProcess.draw(_source, _scaleMatrix);
			_bitmap.bitmapData = _bitmapProcess;
			_bitmap.width = _source.width;
			_bitmap.height = _source.height;
			_pixelSize *= _inMod;
			if (_pixelSize <= 1.1) {
				_source.removeEventListener(Event.ENTER_FRAME, pixelateIn);
				dispatchEvent(new Event(FADE_IN,true));
			}
		}
		
		private function pixelateOut(e:Event):void {
			_bitmapProcess = new BitmapData(_source.width/_pixelSize, _source.height/_pixelSize, true, 0);
			_scaleMatrix = new Matrix();
			_scaleMatrix.scale(1/_pixelSize, 1/_pixelSize);
			_bitmapProcess.draw(_source, _scaleMatrix);
			_bitmap.bitmapData = _bitmapProcess;
			_bitmap.width = _source.width;
			_bitmap.height = _source.height;
			_pixelSize *= _outMod;
			if (_pixelSize >= _pixelCutoff) {
				_source.removeEventListener(Event.ENTER_FRAME, pixelateOut);
				dispatchEvent(new Event(FADE_OUT,true));
			}
		}
	}
}