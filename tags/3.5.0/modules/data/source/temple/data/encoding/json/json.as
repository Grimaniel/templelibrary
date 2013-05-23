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
 
 package temple.data.encoding.json
{
	/**
	 * Parser JSON strings to Objects of converts Objects to JSON String. Uses the native JSON class if available,
	 * otherwise uses the JSON classes of the Temple.
	 * 
	 * <p>Note: this cannot be used if you want to use the 'ExplicitType' feature of the Temple which can convert JSON
	 * to typed Objects.</p> 
	 * 
	 * @see temple.data.encoding.json.JSONDecoder
	 * @see temple.data.encoding.json.JSONEncoder
	 * 
	 * @author Thijs Broerse
	 */
	public const json:IJSONParser = new Parser();
}

import temple.data.encoding.IStringifier;
import temple.data.encoding.IParser;
import temple.data.encoding.json.JSONDecoder;
import temple.data.encoding.json.JSONEncoder;

import flash.system.ApplicationDomain;

interface IJSONParser extends IParser, IStringifier
{
	/**
	 * Returns <code>true</code> if the native JSON class is available.
	 */
	function get available():Boolean;
}

class Parser implements IJSONParser
{
	private var _available:Boolean;
	
	private var _json:*;
	private var _decoder:JSONDecoder;
	private var _encoder:JSONEncoder;

	public function Parser()
	{
		_available = ApplicationDomain.currentDomain.hasDefinition("JSON");
	}

	public function get available():Boolean
	{
		return _available;
	}
	
	public function parse(text:*):Object
	{
		if (_available) return (_json ||= ApplicationDomain.currentDomain.getDefinition("JSON")).parse(text);
		return (_decoder ||= new JSONDecoder()).parse(text);
	}
	
	public function stringify(object:*):String
	{
		if (_available) return (_json ||= ApplicationDomain.currentDomain.getDefinition("JSON")).stringify(object);
		return (_encoder ||= new JSONEncoder()).stringify(object);
	}
}
