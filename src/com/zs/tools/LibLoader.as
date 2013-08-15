package com.zs.tools
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.media.Sound;
	
	public class LibLoader extends Loader
	{
		public function LibLoader()
		{
			
		}
		
		public function getSprite( className:String ): Sprite
		{
			var Asset:Class = getAsset( className );
			
			if ( Asset ) return Sprite( new Asset() );
			return null;
		}
		/**
		 * retrieves an instance of the specified MovieClip
		 * 
		 * @param               className               name of the class that extends Sprite
		 * @return                                              an instance of that class, or null if not found
		 */
		public function getMovieClip( className:String ): MovieClip
		{
			var Asset:Class = getAsset( className );
			
			if ( Asset ) return MovieClip( new Asset() );
			return null;
		}
		/**
		 * retrieves an instance of the specified Sound
		 * 
		 * @param               className               name of the class that extends Sound
		 * @return                                              an instance of that sound, or null if not found
		 */
		public function getSound( className:String ): Sound
		{
			var Asset:Class = getAsset( className );
			
			if ( Asset ) return Sound( new Asset() );
			return null;
		}
		// === P R I V A T E   M E T H O D S ===
		/**
		 * finds the requested class in the SWF and returns it uninstantiated as a Class object
		 *
		 * @param               className               the name of the requested class
		 * @return                                              the requested class as a Class object
		 */
		private function getAsset( className:String ): Class
		{
			try
			{
				var Asset:Class = this.loaderInfo.applicationDomain.getDefinition( className ) as Class;
			} 
			catch ( error:ReferenceError )
			{
				return null;
			}
			
			return Asset;
		}
	}
}