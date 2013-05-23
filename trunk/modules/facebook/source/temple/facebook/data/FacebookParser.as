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

package temple.facebook.data
{
	import temple.core.CoreObject;
	import temple.data.Trivalent;
	import temple.data.index.Indexer;
	import temple.facebook.data.enum.FacebookFieldAlias;
	import temple.facebook.data.enum.FacebookMetadataTag;
	import temple.facebook.data.vo.IFacebookFields;
	import temple.facebook.data.vo.IFacebookObjectData;
	import temple.facebook.service.IFacebookService;
	import temple.reflection.description.DescriptionUtils;
	import temple.reflection.description.Descriptor;
	import temple.reflection.description.IDescription;
	import temple.reflection.description.IMetadata;
	import temple.reflection.description.IMethod;
	import temple.reflection.description.IVariable;
	import temple.utils.types.VectorUtils;

	import flash.utils.Dictionary;

	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	public final class FacebookParser extends CoreObject implements IFacebookParser
	{
		/**
		 * Map for defining Interfaces with there implementating classes
		 */
		facebook static const CLASS_MAP:Dictionary = new Dictionary(true);
		
		private var _service:IFacebookService;
		private var _aliasMap:Dictionary;

		/**
		 * @private
		 */
		public function FacebookParser(service:IFacebookService)
		{
			_service = service;
		}
		
		/**
		 * @private
		 */
		public function parse(data:Object, objectClass:Class, alias:FacebookFieldAlias = null):Object
		{
			alias ||= FacebookFieldAlias.GRAPH;
			
			return data is Array ? parseList(data as Array, objectClass, alias, _service.debug) : parseObject(data, objectClass, alias, _service.debug);
		}

		private function parseObject(data:Object, objectClass:Class, alias:FacebookFieldAlias, debug:Boolean):Object
		{
			if (data == null) return null;
			
			var object:Object;
			var key:String;

			// lookup the correct class
			if (objectClass in facebook::CLASS_MAP) objectClass = facebook::CLASS_MAP[objectClass];
			
			if (Indexer.INDEX_CLASS in objectClass)
			{
				// Class in Indexable, check of we already have the object in cache
				key = "id";
				
				if (data is String || data is int) data = {id: data};
				
				if (!(key in data))
				{
					// key is not found, check if there is an alias
					if (alias == FacebookFieldAlias.FQL && "FIELDS" in objectClass && objectClass.FIELDS is IFacebookFields)
					{
						key = Descriptor.get(objectClass.FIELDS).getVariable("id").getMetadata(FacebookMetadataTag.ALIAS.value).args[alias.value];
					}
					if (!(key in data))
					{
						logError("data doesn't have a key field\n" + dump(data));
					}
				}
				
				object = Indexer.get(objectClass[Indexer.INDEX_CLASS], data[key]);
				
				if (object && !(object is objectClass))
				{
					logError(object + " is not of type " + objectClass);
				}
			}
			
			var description:IDescription = Descriptor.get(objectClass);
				
			if (!object)
			{
				var constructor:IMethod = description.constructor;
				if (constructor.length > 0 && constructor.parameters[0].type == IFacebookService)
				{
					object ||= new objectClass(_service);
				}
				else if (constructor.length == 0 || constructor.parameters[0].optional)
				{
					object ||= new objectClass();
				}
				else
				{
					logError("unable to construct " + objectClass);
					return null;
				}
			}
			for (key in data)
			{
				parseProperty(object, description, null, key, key, data, alias, objectClass, debug);
			}
			return object;
		}
		
		private function parseList(data:Array, objectClass:Class, alias:FacebookFieldAlias, debug:Boolean):Array
		{
			var list:Array = [];
			for (var i:int = 0, leni:int = data.length; i < leni; i++)
			{
				list.push(parseObject(data[i], objectClass, alias, debug));
			}
			return list;
		}

		private function parseProperty(object:Object, objectDescription:IDescription, fieldsDescription:IDescription, key:String, property:String, data:Object, alias:FacebookFieldAlias, objectClass:Class, debug:Boolean):void
		{
			objectDescription ||= Descriptor.get(object);
			
			// Check if the object has this property in the facebook namespace
			var variable:IVariable = objectDescription.getVariable(property, facebook);
			if (variable)
			{
				var a:Array;

				// found property, convert to correct type
				switch (variable.type)
				{
					case String:
					case int:
					case uint:
					case Boolean:
					case Number:
					case Object:
					case Array:
						object.facebook::[property] = data[key];
						break;
						
					case Trivalent:
						object.facebook::[property] = Trivalent.get(data[key]);
						break;
						
					case Date:
						if (int(data[key]) == data[key])
						{
							object.facebook::[property] = new Date(1000 * data[key]);
						}
						else if (String(data[key]).indexOf("/") != -1)
						{
							a = String(data[key]).split("/");
							object.facebook::[property] = new Date(a[2], a[0] - 1, a[1]);
						}
						else if (String(data[key]).indexOf("-") != -1)
						{
							a = String(data[key]).split("-");
							object.facebook::[property] = new Date(a[0], a[1] - 1, a[2] || 1);
						}
						else if (debug)
						{
							logError("Don't know how to parse " + data[key] + " to a Date");
						}
						break;
						
					default:
						if (variable.type in FacebookParser.facebook::CLASS_MAP)
						{
							// facebook object, parse again
							object.facebook::[property] = parseObject(data[key], FacebookParser.facebook::CLASS_MAP[variable.type], alias, debug);
							break;
						}
						if (String(variable.type).indexOf("[class Vector.<") == 0)
						{
							// vectors
							var baseType:Class = VectorUtils.getBaseType(variable.type);

							if (baseType in FacebookParser.facebook::CLASS_MAP)
							{
								if (data[key] is Array)
								{
									object.facebook::[property] = variable.type(parseList(data[key], FacebookParser.facebook::CLASS_MAP[baseType], alias, debug));
									break;
								}
								else if ("data" in data[key] && data[key].data is Array)
								{
									object.facebook::[property] = variable.type(parseList(data[key].data, FacebookParser.facebook::CLASS_MAP[baseType], alias, debug));
									break;
								}
								else if ("count" in data[key] && data[key].count == 0)
								{
									// ignore
									break;
								}
								else
								{
									for each (var item : * in data[key])
									{
										if (item is Array)
										{
											a ||= [];
											a.push.apply(null, parseList(item as Array, FacebookParser.facebook::CLASS_MAP[baseType], alias, debug));
										}
									}
									if (a) object.facebook::[property] = variable.type(a);
									break;
								}
							}
						}
						if (debug) logError("Don't know how to parse " + key + " to " + variable.type);
						break;
				}
			}
			else if (property in object && objectDescription.getProperty(property).isWritable)
			{
				if (object[property] != data[key]) object[property] = data[key];
			}
			else
			{
				// property not found
				// Check if there is an alias for this property
				if (key == property && "FIELDS" in objectClass && objectClass.FIELDS is IFacebookFields)
				{
					// look up variable with this alias and store result in cachemap
					fieldsDescription ||= Descriptor.get(objectClass.FIELDS);
					var variables:Vector.<IVariable> = ((((_aliasMap ||= new Dictionary())[fieldsDescription] ||= {})[FacebookMetadataTag.ALIAS.value] ||= {})[alias.value] ||= {})[key] ||= DescriptionUtils.findVariablesWithMetadata(fieldsDescription, FacebookMetadataTag.ALIAS.value, key, alias.value);

					if (variables && variables.length)
					{
						// variable found, check if this variable exist or if we need the Graph alias for this variable
						variable = variables[0];
						
						if (variable.name in object && objectDescription.getProperty(variable.name).isWritable)
						{
							if (object[variable.name] != data[key]) object[variable.name] = data[key];
							return;
						}
						else
						{
							variable = objectDescription.getVariable(variables[0].name, facebook);
							
							if (variable)
							{
								// found, now parse again
								parseProperty(object, objectDescription, fieldsDescription, key, variable.name, data, alias, objectClass, debug);
								return;
							}
							else
							{
								// check Graph alias
								variable = variables[0];
								var metadata:IMetadata = variable ? variable.getMetadata(FacebookMetadataTag.ALIAS.value) : null;
								if (metadata && FacebookFieldAlias.GRAPH.value in metadata.args)
								{
									// found, now parse again
									parseProperty(object, objectDescription, fieldsDescription, key, metadata.args[FacebookFieldAlias.GRAPH.value], data, alias, objectClass, debug);
									return;
								}
							}
						}
					}
				}
				
				if (key == "data")
				{
					for (key in data.data)
					{
						parseProperty(object, objectDescription, fieldsDescription, key, key, data.data, alias, objectClass, debug);
					}
					return;
				}
				if (key == String(int(key)))
				{
					data = data[key];
					for (key in data)
					{
						parseProperty(object, objectDescription, fieldsDescription, key, key, data, alias, objectClass, debug);
					}
					return;
				}
				else if (debug && key == "metadata" && object is IFacebookObjectData)
				{
					// Introspection enabled, check data
					if ("connections" in data.metadata)
					{
						for (var connection : String in data.metadata.connections)
						{
							if (!IFacebookObjectData(object).connections || IFacebookObjectData(object).connections.indexOf(connection) == -1)
							{
								logWarn("Connection '" + connection + "' not available on " + object);
							}
						}
					}
					if ("fields" in data.metadata)
					{
						for each (var field : Object in data.metadata.fields)
						{
							if (!(field.name in object) && !objectDescription.getVariable(field.name, facebook))
							{
								logWarn(object + " doesn't have a property for '" + field.name + "', " + field.description);
							}
						}
					}
					return;
				}
				
				if (debug)
				{
					logWarn(object + " doesn't have a property for '" + key + "' (" + data[key] + ")");
				}
			}
		}
	}
}
