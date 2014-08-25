/*
include "../includes/License.as.inc";
 */

package temple.core.debug 
{
	import temple.core.utils.ObjectType;
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Creates a nice readable string of an object. If the object is an Array or Vector, each item will be converted to 
	 * a String with this method, using the same props value.
	 * 
	 * @param object the object that must be converted to a String
	 * @param props a list of properties of the object that must be added to the String.
	 * @param notEmpty a Boolean which indicates if null or NaN values must be ignored. 
	 * 
	 * @author Thijs Broerse
	 */
	public function objectToString(object:*, props:Vector.<String> = null, notEmpty:Boolean = false):String
	{
		var string:String = getClassName(object);
		
		if (object is Array || getQualifiedClassName(object).indexOf("__AS3__.vec::Vector.") === 0 /* Vector */)
		{
			string += " (";
			for (var i:int = 0, leni:int = Math.min(object.length, Constants.MAX_LIST_LENGTH); i < leni; i++)
			{
				if (i) string += ", ";
				string += objectToString(object[i], props, notEmpty);
			}
			if (object.length > Constants.MAX_LIST_LENGTH) string += ", ...";
			
			string += ")";
		}
		else
		{
			if (object is Class) string = "class " + string;
			
			if (props && props.length)
			{
				string += " (";
				var sep:String = "", value:*;
				
				for each(var name:String in props)
				{
					if (name in object)
					{
						value = object[name];
						if(!notEmpty || typeof(value) == ObjectType.NUMBER && !isNaN(value) || value !== null)
						{
							string += sep + name + "=";
							
							if (value is String && value !== null || value is Namespace)
							{
								// remove new lines
								var s:String = String(value).split("\r").join(" ").split("\n").join(" ");
								// limit length
								if (s.length > Constants.MAX_STRING_LENGTH) s = s.substr(0, Constants.MAX_STRING_LENGTH) + "[...]";
								string += "\"" + s + "\"";
							}
							else if (value is Date)
							{
								string += "\"" + value + "\"";
							}
							else if ((value is int || value is uint) && name.toLowerCase().indexOf("color") != -1)
							{
								value = int(value).toString(16).toUpperCase();
								while (value.length < 6) value = "0" + value;
								string += "0x" + value;
							}
							else
							{
								string += value;
							}
							sep = " ";
						}
					}
				}
				string += ")";
			}
		}
		return "[" + string + "]";
	}
}

final class Constants
{
	internal static const MAX_STRING_LENGTH:uint = 80;
	internal static const MAX_LIST_LENGTH:uint = 6;
}
