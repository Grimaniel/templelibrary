/*
include "../includes/License.as.inc";
 */

package temple.core.debug 
{
	import temple.core.utils.ObjectType;
	
	/**
	 * Creates a nice readable string of an object.
	 * @param object the object that must be converted to a String
	 * @param props a list of properties of the object that must be added to the String.
	 * @param notEmpty a Boolean which indicates if null or NaN values must be ignored. 
	 * 
	 * @author Thijs Broerse
	 */
	public function objectToString(object:*, props:Vector.<String> = null, notEmpty:Boolean = false):String
	{
		const _MAX_VALUE_LENGTH:uint = 80;
		
		var string:String = getClassName(object);
		
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
							if (s.length > _MAX_VALUE_LENGTH) s = s.substr(0, _MAX_VALUE_LENGTH) + "[...]";
							string += "\"" + s + "\"";
						}
						else if (value is Date)
						{
							string += "\"" + value + "\"";
						}
						else
						{
							string += value;
						}
						sep = " ";
					}
				}
				else
				{
					string += "\"" + name + "\"";
					sep = " ";
				}
			}
			string += ")";
		}
		return "[" + string + "]";
	}
}
