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
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.core.CoreObject;
	import temple.reflection.Reflection;

	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 * @author Thijs Broerse
	 */
	public class Description extends CoreObject implements IDescription	{
		private var _xml:XML;
		private var _name:String;
		private var _type:Class;
		private var _extendsClass:Vector.<Class>;
		private var _interfaces:Vector.<Class>;
		private var _constructor:Method;
		private var _variables:Vector.<IVariable>;
		private var _variablesMap:Dictionary;
		private var _properties:Vector.<IProperty>;
		private var _propertiesMap:Dictionary;
		private var _fields:Vector.<IField>;
		private var _methods:Vector.<IMethod>;
		private var _methodsMap:Dictionary;
		private var _members:Vector.<IMember>;
		private var _metadata:Vector.<IMetadata>;
		private var _metadataMap:Object;
		
		public function Description(object:*, domain:ApplicationDomain = null)
		{
			if (object == null)
			{
				throwError(new TempleArgumentError(this, "object can not be null"));
			}
			else
			{
				_xml = Reflection.get(object, domain);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get name():String
		{
			return _name ||= _xml.@name;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get type():Class
		{
			return (_type ||= getDefinitionByName(name) as Class);
		}

		/**
		 * @inheritDoc
		 */
		public function get extendsClass():Vector.<Class>
		{
			if (!_extendsClass)
			{
				var len:int = _xml..extendsClass.length();
				_extendsClass = new Vector.<Class>(len, true);
				for (var i:int = 0; i < len; i++)
				{
					_extendsClass[i] = getDefinitionByName(_xml..extendsClass[i].@type) as Class;
				}
			}
			return _extendsClass;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get interfaces():Vector.<Class>
		{
			if (!_interfaces)
			{
				var len:int = _xml..implementsInterface.length();
				_interfaces = new Vector.<Class>(len, true);
				for (var i:int = 0; i < len; i++)
				{
					_interfaces[i] = getDefinitionByName(_xml..implementsInterface[i].@type) as Class;
				}
			}
			return _interfaces;
		}

		/**
		 * @inheritDoc
		 */
		public function get constructor():IMethod
		{
			return _constructor ||= new Method(_xml..constructor[0]);
		}

		/**
		 * @inheritDoc
		 */
		public function get variables():Vector.<IVariable>
		{
			if (!_variables)
			{
				var len:int = _xml..variable.length();
				_variables = new Vector.<IVariable>(len, true);
				for (var i:int = 0; i < len; i++)
				{
					_variables[i] = new Variable(_xml..variable[i]);
				}
			}
			return _variables;
		}

		/**
		 * @inheritDoc
		 */
		public function getVariable(name:String, namespace:Namespace = null):IVariable
		{
			return getFromMap(_variablesMap ||= createMap(Vector.<IMember>(variables)), name, namespace) as IVariable;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get properties():Vector.<IProperty>
		{
			if (!_properties)
			{
				var len:int = _xml..accessor.length();
				_properties = new Vector.<IProperty>(len, true);
				for (var i:int = 0; i < len; i++)
				{
					_properties[i] = new Property(_xml..accessor[i]);
				}
			}
			return _properties;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getProperty(name:String, namespace:Namespace = null):IProperty
		{
			return getFromMap(_propertiesMap ||= createMap(Vector.<IMember>(properties)), name, namespace) as IProperty;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get fields():Vector.<IField>
		{
			if (!_fields)
			{
				_fields = Vector.<IField>(properties).concat(Vector.<IField>(variables));
				_fields.fixed = true;
			}
			return _fields;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getField(name:String, namespace:Namespace = null):IField
		{
			return getVariable(name, namespace) || getProperty(name, namespace);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get methods():Vector.<IMethod>
		{
			if (!_methods)
			{
				var len:int = _xml..method.length();
				_methods = new Vector.<IMethod>(len, true);
				for (var i:int = 0; i < len; i++)
				{
					_methods[i] = new Method(_xml..method[i]);
				}
			}
			return _methods;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getMethod(name:String, namespace:Namespace = null):IMethod
		{
			return getFromMap(_methodsMap ||= createMap(Vector.<IMember>(methods)), name, namespace) as IMethod;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get members():Vector.<IMember>
		{
			if (!_members)
			{
				_members = Vector.<IMember>(properties).concat(Vector.<IMember>(variables)).concat(Vector.<IMember>(methods));
				_members.fixed = true;
			}
			return _members;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getMember(name:String, namespace:Namespace = null):IMember
		{
			return getVariable(name, namespace) || getProperty(name, namespace) || getMethod(name, namespace);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get metadata():Vector.<IMetadata>
		{
			if (!_metadata)
			{
				var metadata:XMLList = "factory" in _xml ? _xml.factory.metadata : _xml.metadata;;
				
				var len:int = metadata.length();
				_metadata = new Vector.<IMetadata>(len, true);
				
				for (var i:int = 0; i < len; i++)
				{
					_metadata[i] = new Metadata(metadata[i]);
				}
			}
			return _metadata;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getMetadata(name:String):IMetadata
		{
			if (!_metadataMap)
			{
				_metadataMap = {};
				for (var i:int = 0, leni:int = metadata.length; i < leni; i++)
				{
					_metadataMap[_metadata[i].name] = _metadata[i];
				}
			}
			return _metadataMap[name];
		}

		private function createMap(members:Vector.<IMember>):Dictionary
		{
			var member:IMember, map:Dictionary = new Dictionary();
			for (var i:int = 0, leni:int = members.length; i < leni; i++)
			{
				member = members[i];
				if (member.namespace)
				{
					(map[member.namespace] ||= {})[member.name] = member;
				}
				else
				{
					map[member.name] = member;
				}
			}
			return map;
		}

		private function getFromMap(map:Dictionary, name:String, namespace:Namespace):IMember
		{
			if (namespace && namespace in map)
			{
				return map[namespace][name];
			}
			else if (!namespace)
			{
				return map[name];
			}
			return null;
		}
	}
}
