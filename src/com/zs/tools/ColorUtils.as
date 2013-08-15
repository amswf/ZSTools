package com.zs.tools
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	
	public class ColorUtils
	{
		public static const WHITE:uint   = 0xffffff;
		public static const SILVER:uint  = 0xc0c0c0;
		public static const GRAY:uint    = 0x808080;
		public static const BLACK:uint   = 0x000000;
		public static const RED:uint     = 0xff0000;
		public static const MAROON:uint  = 0x800000;
		public static const YELLOW:uint  = 0xffff00;
		public static const OLIVE:uint   = 0x808000;
		public static const LIME:uint    = 0x00ff00;
		public static const GREEN:uint   = 0x008000;
		public static const AQUA:uint    = 0x00ffff;
		public static const TEAL:uint    = 0x008080;
		public static const BLUE:uint    = 0x0000ff;
		public static const NAVY:uint    = 0x000080;
		public static const FUCHSIA:uint = 0xff00ff;
		public static const PURPLE:uint  = 0x800080;
		
		public function ColorUtils()
		{
			throw new Error();
		}
		/** Returns the alpha part of an ARGB color (0 - 255). */
		public static function getAlpha(color:uint):int { return (color >> 24) & 0xff; }
		
		/** Returns the red part of an (A)RGB color (0 - 255). */
		public static function getRed(color:uint):int   { return (color >> 16) & 0xff; }
		
		/** Returns the green part of an (A)RGB color (0 - 255). */
		public static function getGreen(color:uint):int { return (color >>  8) & 0xff; }
		
		/** Returns the blue part of an (A)RGB color (0 - 255). */
		public static function getBlue(color:uint):int  { return  color        & 0xff; }
		
		/** Creates an RGB color, stored in an unsigned integer. Channels are expected
		 *  in the range 0 - 255. */
		public static function rgb(red:int, green:int, blue:int):uint
		{
			return (red << 16) | (green << 8) | blue;
		}
		
		/** Creates an ARGB color, stored in an unsigned integer. Channels are expected
		 *  in the range 0 - 255. */
		public static function argb(alpha:int, red:int, green:int, blue:int):uint
		{
			return (alpha << 24) | (red << 16) | (green << 8) | blue;
		}
		/**
		 * 获取灰度颜色滤镜
		 * @param target #DisplayObject
		 * 
		 */             
		private static function getGreyFilter(target:DisplayObject):ColorMatrixFilter
		{
			var redLuminance:Number = 0.212671;
			var greenLuminance:Number = 0.715160;
			var blueLuminance:Number = 0.072169;
			
			return new ColorMatrixFilter(
				new Array(redLuminance, greenLuminance, blueLuminance,0,0,
					redLuminance, greenLuminance, blueLuminance,0,0,
					redLuminance, greenLuminance, blueLuminance,0,0,
					0,            0,              0,            1,0));
		}
	}
}