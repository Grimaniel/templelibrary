/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *	
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
	import temple.data.encoding.IDestringifier;
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
	public class JSONDecoder extends CoreObject implements IDestringifier
	{
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
			this._strict = strict;
			this._skipNulls = skipNulls;
			
			if (string)
			{
				this.destringify(string);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function destringify(value:String):*
		{
			this._tokenizer = new JSONTokenizer(value, this._strict);
			this.nextToken();
			this._value = this.parseValue();
			
			// Make sure the input stream is empty
			if (this._strict && this.nextToken() != null )
			{
				this._tokenizer.parseError("Unexpected characters left in input stream");
			}
			
			return this._value;
		}

		/**
		 * Gets the internal object that was created by parsing
		 * the JSON string passed to the constructor.
		 *
		 * @return The internal object representation of the JSON string that was passed to the constructor
		 */
		public function getValue():*
		{
			return this._value;
		}
		
		/**
		 * Let's you define how to handle a specific type of object.
		 * @param type the class that must be handled specific
		 * @param decoder the object that converts the String to the correct object.
		 * 
		 * @includeExample JSONExample.as
		 */
		public function setExplicitDecoder(type:Class, decoder:IDestringifier):void
		{
			this._explicitDecoders ||= new HashMap("expicitDecoders");
			this._explicitDecoders[getQualifiedClassName(type)] = decoder;
		}

		/**
		 * Returns the next token from the tokenzier reading the JSON string
		 */
		private function nextToken():JSONToken
		{
			return this._token = this._tokenizer.getNextToken();
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
			this.nextToken();
			
			// check to see if we have an empty array
			if (this._token.type == JSONTokenType.RIGHT_BRACKET)
			{
				// we're done reading the array, so return it
				return a;
			}
			// in non-strict mode an empty array is also a comma
			// followed by a right bracket
			else if (!this._strict && _token.type == JSONTokenType.COMMA)
			{
				// move past the comma
				this.nextToken();
				
				// check to see if we're reached the end of the array
				if (this._token.type == JSONTokenType.RIGHT_BRACKET)
				{
					return a;	
				}
				else
				{
					this._tokenizer.parseError("Leading commas are not supported.  Expecting ']' but found " + _token.value);
				}
			}
			
			// deal with elements of the array, and use an "infinite"
			// loop because we could have any amount of elements
			while (true)
			{
				// read in the value and add it to the array
				a.push(parseValue());
			
				// after the value there should be a ] or a ,
				this.nextToken();
				
				if (this._token.type == JSONTokenType.RIGHT_BRACKET)
				{
					// we're done reading the array, so return it
					return a;
				}
				else if (this._token.type == JSONTokenType.COMMA)
				{
					// move past the comma and read another value
					this.nextToken();
					
					// Allow arrays to have a comma after the last element
					// if the decoder is not in strict mode
					if (!this._strict )
					{
						// Reached ",]" as the end of the array, so return it
						if (this._token.type == JSONTokenType.RIGHT_BRACKET)
						{
							return a;
						}
					}
				}
				else
				{
					this._tokenizer.parseError("Expecting ] or , but found " + _token.value);
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
			this.nextToken();
			
			// check to see if we have an empty object
			if (this._token.type == JSONTokenType.RIGHT_BRACE)
			{
				// we're done reading the object, so return it
				return this.checkExplicitType(o);
			}
			// in non-strict mode an empty object is also a comma
			// followed by a right bracket
			else if (!this._strict && this._token.type == JSONTokenType.COMMA)
			{
				// move past the comma
				nextToken();
				
				// check to see if we're reached the end of the object
				if (this._token.type == JSONTokenType.RIGHT_BRACE)
				{
					return this.checkExplicitType(o);
				}
				else
				{
					this._tokenizer.parseError("Leading commas are not supported.  Expecting '}' but found " + _token.value);
				}
			}
			
			// deal with members of the object, and use an "infinite"
			// loop because we could have any amount of members
			while (true)
			{
				if (this._token.type == JSONTokenType.STRING)
				{
					// the string value we read is the key for the object
					key = String(this._token.value);
					
					// move past the string to see what's next
					this.nextToken();
					
					// after the string there should be a :
					if (this._token.type == JSONTokenType.COLON)
					{	
						// move past the : and read/assign a value for the key
						this.nextToken();
						o[key] = this.parseValue();	
						
						// move past the value to see what's next
						this.nextToken();
						
						// after the value there's either a } or a ,
						if (this._token.type == JSONTokenType.RIGHT_BRACE)
						{
							// we're done reading the object, so return it
							return this.checkExplicitType(o);
						}
						else if (this._token.type == JSONTokenType.COMMA)
						{
							// skip past the comma and read another member
							this.nextToken();
							
							// Allow objects to have a comma after the last member
							// if the decoder is not in strict mode
							if (!this._strict)
							{
								// Reached ",}" as the end of the object, so return it
								if (this._token.type == JSONTokenType.RIGHT_BRACE)
								{
									return this.checkExplicitType(o);
								}
							}
						}
						else
						{
							this._tokenizer.parseError("Expecting } or , but found " + this._token.value);
						}
					}
					else
					{
						this._tokenizer.parseError("Expecting : but found " + this._token.value);
					}
				}
				else
				{	
					this._tokenizer.parseError("Expecting string but found " + this._token.value);
				}
			}
			return null;
		}
		
		private function checkExplicitType(o:Object):Object
		{
			// hack narie
			if (o.hasOwnProperty('_explicitType'))
			{
				try
				{
					var classRef:Class = getClassByAlias(o['_explicitType']);
				}
				catch (error:ReferenceError)
				{
					this.logWarn(error.message);
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
							this.logError('Error parsing object ' + o['_explicitType']);
						}
					}
					else
					{
						for (var prop:String in o)
						{
							if (prop == '_explicitType') continue;
							
							// skip null values (if enabled)
							if (this._skipNulls && o[prop] == null) continue;
							
							if (obj.hasOwnProperty(prop))
							{
								try
								{
									obj[prop] = o[prop];
								}
								catch (error:TypeError)
								{
									// hack TyZ for Enumerator
									// Here we can get the following error: "TypeError: Error #1034: Type Coercion failed: cannot convert <> to <>"
									// This can happen when we try to set an Enumerator. So we need to look up the correct Enumerator based on the value.
									var typeName:String = describeType(obj).children().((name() == "variable" || name() == "accessor") && @name == prop).@type;
									if (typeName)
									{
										try
										{
											var type:Class = getDefinitionByName(typeName) as Class;
										}
										catch (error:Error)
										{
											// Can't find correct class
											this.logError(error.message);
										}
										if (type)
										{
											var decoder:IDestringifier;
											if (this._explicitDecoders)
											{
												decoder = this._explicitDecoders[getQualifiedClassName(type)];
											}
											if (decoder)
											{
												obj[prop] = decoder.destringify(o[prop]);
											}
											else
											{
												var superclassName:String = getQualifiedSuperclassName(type);
												
												// Check if this class extends the Enumerator class
												if (superclassName && superclassName != "__AS3__.vec::Vector.<*>" && getDefinitionByName(superclassName) == Enumerator)
												{
													// Get the Enumerator
													var enum:Enumerator = Enumerator.get(type, o[prop]);
													if (enum)
													{
														obj[prop] = enum;
													}
													else
													{
														// Can't find this Enumerator, so the value might be wrong, so log a warning
														this.logWarn("'" + o[prop] + "' is not a valid value for '" + prop + "'");
													}
												}
												else
												{
													this.logWarn("Don't know how to handle '" + o[prop] + "' as a value for '" + prop + "'");
												}
											}
										}
									}
									else
									{
										this.logError(error.message);
									}
								}
							}
							else
							{
								this.logWarn('Object "' + classRef + '" missing property: "' + prop + '"');
							}
						}
					}
					return obj;
				}
			}
			// end hack narie
			
			return o;
		}
		
		/**
		 * Attempt to parse a value
		 */
		private function parseValue():Object
		{
			// Catch errors when the input stream ends abruptly
			if (this._token == null)
			{
				this._tokenizer.parseError("Unexpected end of input");
			}
					
			switch (this._token.type)
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
					return this._token.value;
					
				case JSONTokenType.NAN:
					if (!this._strict)
					{
						return this._token.value;
					}
					else
					{
						this._tokenizer.parseError("Unexpected " + this._token.value);
					}

				default:
					this._tokenizer.parseError("Unexpected " + this._token.value);
					break;
			}
			
			return null;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._value = null;
			this._tokenizer = null;
			this._token = null;
			this._explicitDecoders = null;
			
			super.destruct();
		}

	}
}
