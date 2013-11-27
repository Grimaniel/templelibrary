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
Copyright (c) 2008, Adobe Systems Incorporated
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are
met:

 * Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer.
  
 * Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the 
documentation and/or other materials provided with the distribution.
  
 * Neither the name of Adobe Systems Incorporated nor the names of its 
contributors may be used to endorse or promote products derived from 
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package temple.data.encoding.json
{
	import temple.common.enum.Enumerator;
	import temple.common.interfaces.IObjectParsable;
	import temple.core.CoreObject;
	import temple.data.collections.HashMap;
	import temple.data.encoding.IParser;
	import temple.data.index.Indexer;

	import flash.net.getClassByAlias;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	/**
	 * Class that converts JSON strings to objects.
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
	public class JSONDecoder extends CoreObject implements IParser
	{
		private static const _EXPLICIT_TYPE:String = "_explicitType";
		
		/** 
		 * Flag indicating if the parser should be strict about the format
		 * of the JSON string it is attempting to decode.
		 */
		private var _strict:Boolean;

		/** The value that will get parsed from the JSON string */
		private var _value:*;

		/** The tokenizer designated to read the JSON string */
		private var _tokenizer:JSONTokenizer;

		/** The current token from the tokenizer */
		private var _token:JSONToken;
		private var _skipNulls:Boolean;
		
		private var _explicitDecoders:HashMap;

		/**
		 * Constructs a new JSONDecoder to parse a JSON string into a native object.
		 *
		 * @param s The JSON string to be converted into a native object
		 * @param strict Flag indicating if the JSON string needs to strictly match the JSON standard or not.
		 */
		public function JSONDecoder(string:String = null, strict:Boolean = true, skipNulls:Boolean = true)
		{	
			_strict = strict;
			_skipNulls = skipNulls;
			
			if (string) parse(string);
		}
		
		/**
		 * @inheritDoc
		 */
		public function parse(value:*):Object
		{
			_tokenizer = new JSONTokenizer(value, _strict);
			nextToken();
			_value = parseValue();
			
			// Make sure the input stream is empty
			if (_strict && nextToken() != null )
			{
				_tokenizer.parseError("Unexpected characters left in input stream");
			}
			
			return _value;
		}

		/**
		 * Gets the internal object that was created by parsing
		 * the JSON string passed to the constructor.
		 *
		 * @return The internal object representation of the JSON string that was passed to the constructor
		 */
		public function getValue():*
		{
			return _value;
		}
		
		/**
		 * Let's you define how to handle a specific type of object.
		 * @param type the class that must be handled specific
		 * @param decoder the object that converts the String to the correct object.
		 * 
		 * @includeExample JSONExample.as
		 */
		public function setExplicitDecoder(type:Class, decoder:IParser):void
		{
			_explicitDecoders ||= new HashMap("expicitDecoders");
			_explicitDecoders[getQualifiedClassName(type)] = decoder;
		}

		/**
		 * Returns the next token from the tokenzier reading the JSON string
		 */
		private function nextToken():JSONToken
		{
			return _token = _tokenizer.getNextToken();
		}

		/**
		 * Attempt to parse an array.
		 */
		private function parseArray():Array
		{
			// create an array internally that we're going to attempt
			// to parse from the tokenizer
			var a:Array = new Array();
			
			// grab the next token from the tokenizer to move
			// past the opening [
			nextToken();
			
			// check to see if we have an empty array
			if (_token.type == JSONTokenType.RIGHT_BRACKET)
			{
				// we're done reading the array, so return it
				return a;
			}
			// in non-strict mode an empty array is also a comma
			// followed by a right bracket
			else if (!_strict && _token.type == JSONTokenType.COMMA)
			{
				// move past the comma
				nextToken();
				
				// check to see if we're reached the end of the array
				if (_token.type == JSONTokenType.RIGHT_BRACKET)
				{
					return a;	
				}
				else
				{
					_tokenizer.parseError("Leading commas are not supported.  Expecting ']' but found " + _token.value);
				}
			}
			
			// deal with elements of the array, and use an "infinite"
			// loop because we could have any amount of elements
			while (true)
			{
				// read in the value and add it to the array
				a.push(parseValue());
			
				// after the value there should be a ] or a ,
				nextToken();
				
				if (_token.type == JSONTokenType.RIGHT_BRACKET)
				{
					// we're done reading the array, so return it
					return a;
				}
				else if (_token.type == JSONTokenType.COMMA)
				{
					// move past the comma and read another value
					nextToken();
					
					// Allow arrays to have a comma after the last element
					// if the decoder is not in strict mode
					if (!_strict )
					{
						// Reached ",]" as the end of the array, so return it
						if (_token.type == JSONTokenType.RIGHT_BRACKET)
						{
							return a;
						}
					}
				}
				else
				{
					_tokenizer.parseError("Expecting ] or , but found " + _token.value);
				}
			}
			return null;
		}

		/**
		 * Attempt to parse an object.
		 */
		private function parseObject():Object
		{
			// create the object internally that we're going to
			// attempt to parse from the tokenizer
			var o:Object = new Object();
						
			// store the string part of an object member so
			// that we can assign it a value in the object
			var key:String;
			
			// grab the next token from the tokenizer
			nextToken();
			
			// check to see if we have an empty object
			if (_token.type == JSONTokenType.RIGHT_BRACE)
			{
				// we're done reading the object, so return it
				return checkExplicitType(o);
			}
			// in non-strict mode an empty object is also a comma
			// followed by a right bracket
			else if (!_strict && _token.type == JSONTokenType.COMMA)
			{
				// move past the comma
				nextToken();
				
				// check to see if we're reached the end of the object
				if (_token.type == JSONTokenType.RIGHT_BRACE)
				{
					return checkExplicitType(o);
				}
				else
				{
					_tokenizer.parseError("Leading commas are not supported.  Expecting '}' but found " + _token.value);
				}
			}
			
			// deal with members of the object, and use an "infinite"
			// loop because we could have any amount of members
			while (true)
			{
				if (_token.type == JSONTokenType.STRING)
				{
					// the string value we read is the key for the object
					key = String(_token.value);
					
					// move past the string to see what's next
					nextToken();
					
					// after the string there should be a :
					if (_token.type == JSONTokenType.COLON)
					{	
						// move past the : and read/assign a value for the key
						nextToken();
						o[key] = parseValue();	
						
						// move past the value to see what's next
						nextToken();
						
						// after the value there's either a } or a ,
						if (_token.type == JSONTokenType.RIGHT_BRACE)
						{
							// we're done reading the object, so return it
							return checkExplicitType(o);
						}
						else if (_token.type == JSONTokenType.COMMA)
						{
							// skip past the comma and read another member
							nextToken();
							
							// Allow objects to have a comma after the last member
							// if the decoder is not in strict mode
							if (!_strict)
							{
								// Reached ",}" as the end of the object, so return it
								if (_token.type == JSONTokenType.RIGHT_BRACE)
								{
									return checkExplicitType(o);
								}
							}
						}
						else
						{
							_tokenizer.parseError("Expecting } or , but found " + _token.value);
						}
					}
					else
					{
						_tokenizer.parseError("Expecting : but found " + _token.value);
					}
				}
				else
				{	
					_tokenizer.parseError("Expecting string but found " + _token.value);
				}
			}
			return null;
		}
		
		private function checkExplicitType(o:Object):Object
		{
			if (_EXPLICIT_TYPE in o)
			{
				try
				{
					var classRef:Class = getClassByAlias(o[_EXPLICIT_TYPE]);
				}
				catch (error:ReferenceError)
				{
					logWarn(error.message);
				}
				if (classRef)
				{
					var obj:Object;
					
					// IIndexable check
					if (o.id)
					{
						// Get object from Indexer. If this is not an IIndexable object, we won't get an object.
						obj = Indexer.get(Indexer.INDEX_CLASS in classRef && classRef[Indexer.INDEX_CLASS] is Class ? classRef[Indexer.INDEX_CLASS] : classRef, o.id);
					}
					
					obj ||= new (classRef)();
					
					if (obj is IObjectParsable)
					{
						if (!IObjectParsable(obj).parseObject(o))
						{
							logError('Error parsing object ' + o[_EXPLICIT_TYPE]);
						}
					}
					else
					{
						applyProperties(obj, o);
					}
					return obj;
				}
			}
			return o;
		}

		private function applyProperties(object:Object, properties:Object):void
		{
			for (var prop:String in properties)
			{
				if (prop == _EXPLICIT_TYPE) continue;
				
				// skip null values (if enabled)
				if (_skipNulls && properties[prop] == null) continue;
				
				if (prop in object)
				{
					try
					{
						object[prop] = properties[prop];
					}
					catch (error:TypeError)
					{
						// hack TyZ for Enumerator
						// Here we can get the following error: "TypeError: Error #1034: Type Coercion failed: cannot convert <> to <>"
						// This can happen when we try to set an Enumerator. So we need to look up the correct Enumerator based on the value.
						var description:XML = describeType(object);
						var typeName:String = description.variable.(@name == prop).@type || description.accessor.(@name == prop).@type;
						
						
						if (typeName)
						{
							try
							{
								var type:Class = getDefinitionByName(typeName) as Class;
							}
							catch (error:Error)
							{
								// Can't find correct class
								logError(error.message);
							}
							if (type)
							{
								var decoder:IParser;
								if (_explicitDecoders)
								{
									decoder = _explicitDecoders[getQualifiedClassName(type)];
								}
								if (decoder)
								{
									object[prop] = decoder.parse(properties[prop]);
								}
								else
								{
									var superclassName:String = getQualifiedSuperclassName(type);
									
									// Check if this class extends the Enumerator class
									if (superclassName && superclassName != "__AS3__.vec::Vector.<*>" && getDefinitionByName(superclassName) == Enumerator)
									{
										// Get the Enumerator
										var enum:Enumerator = Enumerator.get(type, properties[prop]);
										if (enum)
										{
											object[prop] = enum;
										}
										else
										{
											// Can't find this Enumerator, so the value might be wrong, so log a warning
											logWarn("'" + properties[prop] + "' is not a valid value for '" + prop + "'");
										}
									}
									else
									{
										// try to create this class
										try
										{
											object[prop] = new type();
										}
										catch (error:Error)
										{
											logWarn("Don't know how to handle '" + properties[prop] + "' as a value for '" + prop + "'");
										}
										if (object[prop]) applyProperties(object[prop], properties[prop]);
									}
								}
							}
						}
						else
						{
							logError(error.message);
						}
					}
				}
				else
				{
					logWarn("Object '" + object + "' missing property: '" + prop + "'");
				}
			}
		}

		
		/**
		 * Attempt to parse a value
		 */
		private function parseValue():Object
		{
			// Catch errors when the input stream ends abruptly
			if (_token == null)
			{
				_tokenizer.parseError("Unexpected end of input");
			}
					
			switch (_token.type)
			{
				case JSONTokenType.LEFT_BRACE:
					return parseObject();
					
				case JSONTokenType.LEFT_BRACKET:
					return parseArray();
					
				case JSONTokenType.STRING:
				case JSONTokenType.NUMBER:
				case JSONTokenType.TRUE:
				case JSONTokenType.FALSE:
				case JSONTokenType.NULL:
					return _token.value;
					
				case JSONTokenType.NAN:
					if (!_strict)
					{
						return _token.value;
					}
					else
					{
						_tokenizer.parseError("Unexpected " + _token.value);
					}

				default:
					_tokenizer.parseError("Unexpected " + _token.value);
					break;
			}
			
			return null;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_value = null;
			_tokenizer = null;
			_token = null;
			_explicitDecoders = null;
			
			super.destruct();
		}

	}
}
