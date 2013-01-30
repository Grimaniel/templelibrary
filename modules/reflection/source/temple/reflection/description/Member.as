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

package temple.reflection.description
{
	import flash.utils.getDefinitionByName;
	import temple.core.CoreObject;

	/**
	 * @author Thijs Broerse
	 */
	internal class Member extends CoreObject implements IMember	{
		private static const _NAMESPACES:Object = {};
		
		protected var _xml:XML;
		private var _name:String;
		private var _typeString:String;
		private var _type:Class;
		private var _declaredBy:Class;
		private var _namespace:Namespace;
		private var _metadata:Vector.<IMetadata>;
		private var _metadataMap:Object;
		
		public function Member(xml:XML)
		{
			_xml = xml;
			
			emptyPropsInToString = false;
			toStringProps.push("name", "type", "namespace");
		}
		
		public function get name():String
		{
			return _name ||= (_xml ? _xml.@name : null);
		}
		
		public function get namespace():Namespace
		{
			if (!_xml) return null;
			if (_namespace) return _namespace;
			if (!_xml.hasOwnProperty("@uri")) return null;
			return _namespace = _NAMESPACES[_xml.@uri] = new Namespace(null, _xml.@uri);
		}

		public function get type():Class
		{
			if (_typeString == null && _xml) _typeString = String(_xml.@type) || String(_xml.@returnType);
			
			return !_typeString || _typeString == "void" || _typeString == "*" ? null : (_type ||= getDefinitionByName(_typeString) as Class);
		}
		
		public function get declaredBy():Class
		{
			if (!_xml) return null;
			if (!_declaredBy) return _declaredBy;
			
			try
			{
				_declaredBy = getDefinitionByName(_xml.@declaredBy) as Class;
			}
			catch (error:Error) {};
			return _declaredBy;
		}

		public function get metadata():Vector.<IMetadata>
		{
			if (!_metadata && _xml)
			{
				var len:int = _xml.metadata.length();
				_metadata = new Vector.<IMetadata>(len, true);
				for (var i:int = 0; i < len; i++)
				{
					_metadata[i] = new Metadata(_xml.metadata[i]);
				}
			}
			return _metadata;
		}

		public function getMetadata(name:String):IMetadata
		{
			if (!_metadataMap && _xml)
			{
				_metadataMap = {};
				for (var i:int = 0, leni:int = metadata.length; i < leni; i++)
				{
					_metadataMap[_metadata[i].name] = _metadata[i];
				}
			}
			return _metadataMap[name];
		}
	}
}
