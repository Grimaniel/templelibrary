/*
 *	Temple Library for ActionScript 3.0
 *	Copyright © MediaMonks B.V.
 *	All rights reserved.
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	1. Redistributions of source code must retain the above copyright
 *	   notice, this list of conditions and the following disclaimer.
 *	2. Redistributions in binary form must reproduce the above copyright
 *	   notice, this list of conditions and the following disclaimer in the
 *	   documentation and/or other materials provided with the distribution.
 *	3. All advertising materials mentioning features or use of this software
 *	   must display the following acknowledgement:
 *	   This product includes software developed by MediaMonks B.V.
 *	4. Neither the name of MediaMonks B.V. nor the
 *	   names of its contributors may be used to endorse or promote products
 *	   derived from this software without specific prior written permission.
 *	
 *	THIS SOFTWARE IS PROVIDED BY MEDIAMONKS B.V. ''AS IS'' AND ANY
 *	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *	DISCLAIMED. IN NO EVENT SHALL MEDIAMONKS B.V. BE LIABLE FOR ANY
 *	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
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
