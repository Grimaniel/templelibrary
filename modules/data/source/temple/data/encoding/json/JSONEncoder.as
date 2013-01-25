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

/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
Please read this Source Code License Agreement carefully before using
the source code.
	
Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or
object code form without any attribution requirements.
	
The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.
	
You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's
fees that arise or result from your use or distribution of the source
code.
	
THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package temple.data.encoding.json 
{
	import temple.common.enum.Enumerator;
	import temple.core.CoreObject;
	import temple.data.collections.HashMap;
	import temple.data.encoding.IStringifier;
	import temple.utils.types.StringUtils;

	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	/**
	 * Class that converts objects to JSON strings.
	 * 
	 * @includeExample Person.as
	 * @includeExample Gender.as
	 * @includeExample JSONExample.as
	 * 
	 * 
	 * @includeExample ../../index/Person.as
	 * @includeExample ../../index/JSONIndexExample.as
	 * 
	 * @author Adobe (modifief by Thijs Broerse and Arjan van Wijk)
	 */
	public class JSONEncoder extends CoreObject implements IStringifier
	{
		/** The string that is going to represent the object we're encoding */
		private var _jsonString:String;
		private var _useExplicitType:Boolean;
		private var _skipTransientVars:Boolean;
		private var _skipReadOnlyVars:Boolean;
		private var _explicitEncoders:HashMap;

		/**
		 * Creates a new JSONEncoder.
		 *
		 * @param o The object to encode as a JSON string
		 * @param useExplicitType a Boolean which indicates if the '_explicitType' property (if defined with
		 * <code>registerClassAlias()</code>) should be added to the object.
		 * @param skipTransientVars a Boolean which indicates if properties with the <code>[Transient]</code> metadata
		 * tag should be ignored.
		 * @param skipReadOnlyVars a Boolean which indicates if read-only properties should be ignored.
		 */
		public function JSONEncoder(value:* = null, useExplicitType:Boolean = false, skipTransientVars:Boolean = true, skipReadOnlyVars:Boolean = true) 
		{
			_useExplicitType = useExplicitType;
			_skipTransientVars = skipTransientVars;
			_skipReadOnlyVars = skipReadOnlyVars;
			if (value) _jsonString = stringify(value);
		}

		/**
		 * Gets the JSON string from the encoder.
		 *
		 * @return The JSON string representation of the object that was passed to the constructor
		 */
		public function getString():String 
		{
			return _jsonString;
		}

		/**
		 * Converts a value to it's JSON string equivalent.
		 *
		 * @param value The value to convert.  Could be any type (object, number, array, etc)
		 */
		public function stringify(value:*):String 
		{
			var className:String = getQualifiedClassName(value);
			
			// check if there is an explicit encoder defined for this type
			if (_explicitEncoders && _explicitEncoders[className])
			{
				return IStringifier(_explicitEncoders[className]).stringify(value);
			}
			// determine what value is and convert it based on it's type
			else if (value is String) 
			{
				// escape the string so it's formatted correctly
				return escapeString(value as String);
			}
			else if (value is Number) 
			{
				// only encode numbers that finate
				return isFinite(value as Number) ? value.toString() : "null";
			}
			else if (value is Boolean) 
			{
				// convert boolean to string easily
				return value ? "true" : "false";
			}
			else if (value is Array) 
			{
				// call the helper method to convert an array
				return arrayToString(value as Array);
			}
			else if (getQualifiedClassName(value).indexOf("__AS3__.vec::Vector.") === 0) // Vector 
			{
				// call the helper method to convert an array
				return vectorToString(value);
			}
			else if (value is Enumerator) 
			{
				// return the value
				return escapeString((value as Enumerator).value);
			}
			else if (value is Object && value != null) 
			{
				// call the helper method to convert an object
				return objectToString(value);
			}
			return "null";
		}

		/**
		 * Let's you define how to handle a specific type of object.
		 * @param type the class that must be handled specific.
		 * @param decoder the object that converts the object to a JSON String.
		 * 
		 * @includeExample JSONExample.as
		 */
		public function setExplicitEncoder(type:Class, encoder:IStringifier):void
		{
			_explicitEncoders ||= new HashMap("expicitEncoders");
			_explicitEncoders[getQualifiedClassName(type)] = encoder;
		}
		
		/**
		 * A Boolean which indicates if the '_explicitType' property (if defined with <code>registerClassAlias()</code>)
		 * should be added to the object.
		 */
		public function get useExplicitType():Boolean
		{
			return _useExplicitType;
		}

		/**
		 * @private
		 */
		public function set useExplicitType(value:Boolean):void
		{
			_useExplicitType = value;
		}

		/**
		 * A Boolean which indicates if properties with the <code>[Transient]</code> metadata tag should be ignored.
		 */
		public function get skipTransientVars():Boolean
		{
			return _skipTransientVars;
		}

		/**
		 * @private
		 */
		public function set skipTransientVars(value:Boolean):void
		{
			_skipTransientVars = value;
		}

		/**
		 * A Boolean which indicates if read-only properties should be ignored.
		 */
		public function get skipReadOnlyVars():Boolean
		{
			return _skipReadOnlyVars;
		}

		/**
		 * @private
		 */
		public function set skipReadOnlyVars(value:Boolean):void
		{
			_skipReadOnlyVars = value;
		}

		/**
		 * Escapes a string accoding to the JSON specification.
		 *
		 * @param str The string to be escaped
		 * @return The string with escaped special characters according to the JSON specification
		 */
		private function escapeString(str:String):String 
		{
			// create a string to store the string's jsonstring value
			var s:String = "";
			// current character in the string we're processing
			var ch:String;
			// store the length in a local variable to reduce lookups
			var len:Number = str.length;
			
			// loop over all of the characters in the string
			for ( var i:int = 0;i < len;i++ ) 
			{
			
				// examine the character to determine if we have to escape it
				ch = str.charAt(i);
				switch ( ch ) 
				{
				
					case '"':	
						// quotation mark
						s += "\\\"";
						break;
						
					//case '/':	// solidus
					//	s += "\\/";
					//	break;
						
					case '\\':	
						// reverse solidus
						s += "\\\\";
						break;
						
					case '\b':	
						// bell
						s += "\\b";
						break;
						
					case '\f':	
						// form feed
						s += "\\f";
						break;
						
					case '\n':	
						// newline
						s += "\\n";
						break;
						
					case '\r':	
						// carriage return
						s += "\\r";
						break;
						
					case '\t':	
						// horizontal tab
						s += "\\t";
						break;
						
					default:	
						// everything else
						s += StringUtils.escapeToUnicodeChar(ch);
				}	// end switch
			}	
			// end for loop

			return "\"" + s + "\"";
		}

		/**
		 * Converts an array to it's JSON string equivalent
		 *
		 * @param a The array to convert
		 * @return The JSON string representation of <code>a</code>
		 */
		private function arrayToString(a:Array):String 
		{
			// create a string to store the array's jsonstring value
			var s:String = "";
			
			// loop over the elements in the array and add their converted
			// values to the string
			for (var i:int = 0, len:int = a.length;i < len;i++ )
			{
				// when the length is 0 we're adding the first element so
				// no comma is necessary
				if ( s.length > 0 ) 
				{
					// we've already added an element, so add the comma separator
					s += ",";
				}
				
				// convert the value to a string
				s += stringify(a[i]);	
			}
			
			// KNOWN ISSUE:  In ActionScript, Arrays can also be associative
			// objects and you can put anything in them, ie:
			//		myArray["foo"] = "bar";
			//
			// These properties aren't picked up in the for loop above because
			// the properties don't correspond to indexes.  However, we're
			// sort of out luck because the JSON specification doesn't allow
			// these types of array properties.
			//
			// So, if the array was also used as an associative object, there
			// may be some values in the array that don't get properly encoded.
			//
			// A possible solution is to instead encode the Array as an Object
			// but then it won't get decoded correctly (and won't be an
			// Array instance)
						
			// close the array and return it's string value
			return "[" + s + "]";
		}
		
		/**
		 * Converts an Vector to it's JSON string equivalent
		 *
		 * @param a The vector to convert
		 * @return The JSON string representation of <code>v</code>
		 */
		private function vectorToString(v:*):String 
		{
			// create a string to store the array's jsonstring value
			var s:String = "";
			
			// loop over the elements in the array and add their converted
			// values to the string
			for (var i:int = 0, len:int = v.length;i < len;i++ ) 
			{
				// when the length is 0 we're adding the first element so
				// no comma is necessary
				if ( s.length > 0 ) 
				{
					// we've already added an element, so add the comma separator
					s += ",";
				}
				
				// convert the value to a string
				s += stringify(v[i]);	
			}
			
			// close the vector and return it's string value
			return "[" + s + "]";
		}

		/**
		 * Converts an object to it's JSON string equivalent
		 *
		 * @param o The object to convert
		 * @return The JSON string representation of <code>o</code>
		 */
		private function objectToString( o:Object ):String
		{
			// create a string to store the object's jsonstring value
			var s:String = "";
			var value:Object;
			
			// determine if o is a class instance or a plain object
			var classInfo:XML = describeType(o);
			if (classInfo.@name.toString() == "Object")
			{
				// loop over the keys in the object and add their converted
				// values to the string
				for (var key:String in o)
				{
					// the value of o[key] in the loop below - store this 
					// as a variable so we don't have to keep looking up o[key]
					// when testing for valid values to convert
					// assign value to a variable for quick lookup
					value = o[key];
					
					// don't add function's to the JSON string
					if (value is Function)
					{
						// skip this key and try another
						continue;
					}
					
					// when the length is 0 we're adding the first item so
					// no comma is necessary
					if (s.length > 0) 
					{
						// we've already added an item, so add the comma separator
						s += ",";
					}
					
					s += escapeString(key) + ":" + stringify(value);
				}
			}
			else 
			// o is a class instance
			{
				// Loop over all of the variables and accessors in the class and 
				// serialize them along with their values.
				for each (var v:XML in 
					classInfo..accessor.(!hasOwnProperty("@uri") && (!_skipReadOnlyVars || @access != "readonly"))	+
					classInfo..variable.(!hasOwnProperty("@uri")))
				{
					value = o[v.@name];

					// check for Transient metadata 
					if (_skipTransientVars)
					{
						var transient:XMLList = v.metadata.(@name == "Transient");
						
						if (transient.length() > 0)
						{
							var whenNull:Boolean = transient[0].arg.(@key == "whenNull").@value == "true" || transient[0].arg.(@value == "whenNull").@key == "";
							if (whenNull && value == null || !whenNull)
							{
								// skip it
								continue;
							}
						}
					}

					
					// When the length is 0 we're adding the first item so
					// no comma is necessary
					if (s.length > 0)
					{
						// We've already added an item, so add the comma separator
						s += ",";
					}
					
					s += escapeString(v.@name.toString()) + ":" + stringify(o[v.@name]);
				}
				
				// hack narie
				if (_useExplicitType && classInfo.@alias.toString() != "") s += ', "_explicitType":"' + classInfo.@alias + '"';
			}
			
			return "{" + s + "}";
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_jsonString = null;
			_explicitEncoders = null;
			
			super.destruct();
		}
	}
}
