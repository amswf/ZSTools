/**
 *粒子效果类 
 */
package com.zs.tools 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	/**
	 * ...
	 * @author zhengs
	 */
	public class PixelAnimation extends Bitmap 
	{
		private var src:BitmapData;
		private var centerY:Number;
		private var centerX:Number;
		private var cArr:Array = [];//像素色值管理
		private var pArr:Array = [];//粒子管理器
		private var statusArr:Array = [];
		private var count:Number = 0;//粒子数
		private var ctf:ColorTransform = new ColorTransform(0.9, 0.9, 0.9, 0.9);
		private var i2:int = 0;
		private var j2:int = 0;
		
		public function PixelAnimation(value:BitmapData,_width:Number=500,_height:Number=300) 
		{
			this.src = value;
			var bmd:BitmapData = new BitmapData(_width, _height, true, 0);
			centerX = (bmd.width - value.width) / 2;
			centerY = (bmd.height - value.height) / 2;
			bmd.copyPixels(value, value.rect, new Point(centerX, centerY), null, new Point(), true);
			this.bitmapData = bmd;
			for (var i:int = 0; i < value.height;i++ )
			{
				cArr[i] = [];
				pArr[i] = [];
				statusArr[i] = [];
				for (var j:int = 0; j < value.width;j++ )
				{
					cArr[i].push(value.getPixel32(j, i)); 
					pArr[i].push(new Particle2D(centerX + j, centerY + i, 0, 0, 1 + Math.random() * 5));
					statusArr[i].push(false);
					count++;
				}
			}
		}
		/**
		 * 打散图片 
		 * 
		 */             
		public function spread():void
		{
			for (var i:int = 0; i < src.height;i++ )
			{
				for (var j:int = 0; j < src.width;j++ )
				{
					var particle:Particle2D = pArr[i][j] as Particle2D;
					var disX:Number = particle.x - mouseX;
					var disY:Number = particle.y - mouseY;
					var dis:Number = Math.sqrt(disX * disX + disY * disY);
					var angle:Number = Math.atan2(disY, disX);
					var _loc_11:Number = (10 + Math.random() * 90) * 20 / (20 + dis);
					particle.vx = particle.vx + _loc_11 * Math.cos(angle) / particle.mass;
					particle.vy = particle.vy + _loc_11 * Math.sin(angle) / particle.mass;
				}
			}
			removeEventListener(Event.ENTER_FRAME, onRecoverFrame);
			addEventListener(Event.ENTER_FRAME, onSpreadFrame);
		}
		
		private function onSpreadFrame(event:Event):void
		{
			this.bitmapData.lock();
			this.bitmapData.colorTransform(this.bitmapData.rect, ctf);
			for (var i:int = 0; i < src.height;i++ )
			{
				for (var j:int = 0; j < src.width;j++ )
				{
					var particle:Particle2D = pArr[i][j] as Particle2D;
					if (particle.y > -1)
					{
						particle.vx = particle.vx * 0.98;
						particle.vy = particle.vy - 1 / particle.mass;
						particle.update();
					}
					this.bitmapData.setPixel32(particle.x, particle.y, cArr[i][j]);
				}
			}
			this.bitmapData.unlock();
		}
		/**
		 *重新组合图片 
		 * 
		 */             
		public function recover():void
		{
			j2 = 0;
			i2 = 0;
			
			for (var i:int = 0; i < src.height;i++ )
			{
				for (var j:int = 0; j < src.width;j++ )
				{
					statusArr[i][j] = false;
				}
			}
			
			removeEventListener(Event.ENTER_FRAME, onSpreadFrame);
			addEventListener(Event.ENTER_FRAME, onRecoverFrame);
		}
		
		private function onRecoverFrame(event:Event):void
		{
			this.bitmapData.lock();
			this.bitmapData.colorTransform(this.bitmapData.rect, ctf);
			if (i2 < src.height)
				i2 = i2 + 2;
			
			for (var i:int = 0; i < src.height;i++)
			{
				for (var j:int = 0; j < src.width;j++ )
				{
					var particle:Particle2D = pArr[i][j] as Particle2D;
					if (!statusArr[i][j])
					{
						var _loc_4:Number = centerX + j;
						var _loc_5:Number = centerY + i;
						if (i < i2)
						{
							particle.vx = (_loc_4 - particle.x) / (particle.mass * 4);
							particle.vy = (_loc_5 - particle.y) / (particle.mass * 3);
						}
						particle.update();
						if (Math.abs(particle.x - _loc_4) < 1 && Math.abs(particle.y - _loc_5) < 1)
						{
							particle.x = _loc_4;
							particle.y = _loc_5;
							statusArr[i][j] = true;
						}
					}
					this.bitmapData.setPixel32(particle.x, particle.y, cArr[i][j]);
				}
			}
			this.bitmapData.unlock();
		}
	}
}

class Particle2D
{
	public var vx:Number;
	public var vy:Number;
	public var mass:Number;
	public var x:Number;
	public var y:Number;
	
	public function Particle2D(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 1)
	{
		x = param1;
		y = param2;
		vx = param3;
		vy = param4;
		mass = param5;
	}
	
	public function update():void
	{
		x = x + vx;
		y = y + vy;
	}
}