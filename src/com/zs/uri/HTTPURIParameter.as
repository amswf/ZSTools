package com.zs.uri
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class HTTPURIParameter
	{
		
		/**
		 * @private
		 */
		private var _name : String;
		
		/**
		 * @private
		 */
		private var _value : String;
		
		/**
		 * @param name value of the URI parameter
		 * @param value of the URI parameter
		 */
		public function HTTPURIParameter(name : String, value : String)
		{
			if(null == name) throw new ArgumentError('Name can not be null');
			if(name.length == 0) throw new ArgumentError('Name can not be empty');
			if(null == value) throw new ArgumentError('Value can not be null');
			
			_name = encodeURIComponent(name);
			_value = encodeURIComponent(value);
		}
		
		/**
		 * Create a Parameter pair from a uniformed string, in this case 'a=1', where there is
		 * an equals sign that splits the parameter
		 * 
		 * @return HTTPUniformResourceIdentifierParameters
		 */
		public static function fromUniformedString(     parameter : String
		) : HTTPURIParameter
		{
			const split : Array = parameter.split("=");
			if (split.length != 2) throw new Error("Unable to split the parameters");
			
			return new HTTPURIParameter(split[0], split[1]);
		}
		
		public function getParameterAsString() : String
		{
			if(value.length == 0) return name;
			else return name + '=' + value;
		}
		
		/**
		 * Get the name of the parameter
		 * 
		 * @return String
		 */
		public function get name() : String { return _name; }
		
		/**
		 * Get the value of the parameter
		 * 
		 * @return String
		 */
		public function get value() : String { return _value; }         
	}
}