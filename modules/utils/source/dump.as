package
{
	import flash.utils.Dictionary;
	
	/**
	 * Recursively dumps the object and all his properties.
	 * 
	 * @param object object to dump
	 * @param depth indicates the recursive factor
	 * @param duplicates indicates if duplicate objects should be dumped again
	 * @param constants indicates if constants will be included (<code>true</code>) or not (<code>false</code>)
	 * @param methods indicates if methods will be included (<code>true</code>) or not (<code>false</code>)
	 * @param dates indicates if a <code>Date</code> will be fully dumped (including all properties) (true) or only as a simple String (false)
	 * @param skipEmpty is set to <code>true</code> properties with a value of <code>null</code> or <code>NaN</code> will be skipped
	 * 
	 * @return the object tree as String
	 * 
	 * @example
	 * <listing version="3.0">
	 * 
	 *  trace(dump(myObject));
	 * 
	 * </listing>
	 * 
	 * @author Thijs Broerse
	 */
	public function dump(object:Object, depth:uint = 3, duplicates:Boolean = true, constants:Boolean = false, namespaces:Boolean = false, methods:Boolean = false, dates:Boolean = false, skipEmpty:Boolean = false):String
	{
		return Functions.dump(object, depth, duplicates ? null : new Dictionary(true), constants, namespaces, methods, dates, skipEmpty, false, "");
	}
}
import temple.utils.types.ObjectUtils;
import temple.common.enum.Enumerator;
import temple.core.debug.getClassName;
import temple.core.utils.ObjectType;

import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;

class Functions
{
	private static const WRITEONLY:Object = {};
	
	internal static function dump(object:Object, depth:uint, objects:Dictionary, constants:Boolean, namespaces:Boolean, methods:Boolean, dates:Boolean, skipEmpty:Boolean, isInited:Boolean, tabs:String):String
	{
		var output:String = "";
		var openChar:String;

		// every time this function is called we'll add another tab to the indention in the output window
		tabs += "\t";

		if (depth < 0 )
		{
			output += tabs + "\n(...)";
			return output;
		}

		if (!isInited)
		{
			isInited = true;
			
			// Array or Vector
			if (object is Array || Functions.isVector(object))
			{
				output += getClassName(object) + " (" + object.length + (object.fixed ? ", fixed" : "") + ")";
				if (object.length) openChar = "[";
			}
			else
			{
				output += ObjectUtils.convertToString(object) + " (" + getClassName(object) + ")";

				if (object is String)
				{
					output += " (" + (object as String).length + ")";
					return output;
				}
				else if (object is uint || object is int)
				{
					output += " (0x" + int(object).toString(16).toUpperCase() + ")";
					return output;
				}
				else if (!ObjectUtils.isPrimitive(object))
				{
					openChar = "\u007B";

					if (ObjectUtils.isDynamic(object))
					{
						output += " (dynamic)";
					}
				}
			}

			if (openChar) output += "\n" + openChar;
		}

		var variables:Array = [];
		var key:*;
		var leni:int;
		var i:int;

		if (object is Array || Functions.isVector(object) || object is XMLList)
		{
			for (key in object)
			{
				variables.push(new ObjectVariableData(key));
			}
		}
		else
		{
			// variables, getters, constants and methods
			var description:XML = describeType(object);
			
			var list:XMLList  = description.variable;
			list += description.accessor;
			if (constants) list += description.constant;
			if (methods) list += description.method;
			
			for each (var node:XML in list)
			{
				if (namespaces || !("@uri" in node))
				{
					variables.push(new ObjectVariableData(node.@name, node.@type, node, node.@uri, node.@access));
				}
			}
			
			// dynamic values
			for (key in object)
			{
				variables.push(new ObjectVariableData(key));
			}
			// sort variables alphabaticly
			variables = variables.sortOn('name', Array.CASEINSENSITIVE);
		}

		var variable:*;

		// an object for temporary storing the key. Needed to prefend duplicates
		var keys:Object = {};
		
		// an object for temporary storing namespaces
		var spaces:Object = {};

		leni = variables.length;
		for (i = 0; i < leni; i++)
		{
			var vardata:ObjectVariableData = variables[i] as ObjectVariableData;

			if (vardata.name == null  || !namespaces && keys[vardata.name] === true) continue;

			keys[vardata.name] = true;

			var type:String = null;

			if (vardata.access != "writeonly")
			{
				try
				{
					if (vardata.uri)
					{
						var ns:Namespace = spaces[vardata.uri] ||= new Namespace(null, vardata.uri);
						variable = object.ns::[vardata.name];
					}
					else
					{
						variable = object[vardata.name];
					}
				}
				catch (e:Error)
				{
					variable = e.message;
				}
				type = typeof(variable);
			}
			else
			{
				variable = WRITEONLY;
			}
			
			if (skipEmpty && (variable === null || variable != variable || variable == Functions.WRITEONLY)) continue;
			
			output += "\n" + tabs + (vardata.uri ? "[" + vardata.uri + "]::" : "") + vardata.name;
			
			if (variable != Functions.WRITEONLY)
			{
				// determine what's inside...
				switch (type)
				{
					case ObjectType.STRING:
					{
						output += ": \"" + variable + "\"";
						break;
					}
					case ObjectType.OBJECT:
					{
						// check to see if the variable is an Array or Vector.
						if (variable is Array || Functions.isVector(variable))
						{
							if ((objects == null || !objects[variable]) && ObjectUtils.hasValues(variable) && depth)
							{
								if (objects) objects[variable] = true;
	
								output += ": " + getClassName(variable) + "(" + variable.length + (variable.fixed ? ", fixed" : "") + ")";
								if (variable.length) output += "\n" + tabs + "[";
								output += Functions.dump(variable, depth - 1, objects, constants, namespaces, methods, dates, skipEmpty, isInited, tabs);
								if (variable.length) output += "\n" + tabs + "]";
							}
							else
							{
								output += ": " + getClassName(variable) + "(" + variable.length + (variable.fixed ? ", fixed" : "") + ")" + (objects && objects[variable] ? " (duplicate)" : "");;
							}
						}
						else if (variable is ByteArray)
						{
							output += ": " + uint(ByteArray(variable).bytesAvailable / 1024) + "KB " + (['AMF0',,, 'AMF3'][(ByteArray(variable).objectEncoding)]) + " position:" + ByteArray(variable).position + " (ByteArray)";
						}
						else if (variable is Enumerator)
						{
							output += ": " + variable + " (" + getClassName(vardata.type ? variable || vardata.type : getQualifiedClassName(variable)) + ") (" + getClassName(Enumerator) + ")";
						}
						else
						{
							// object, make exception for Date
							if ((objects == null || !objects[variable]) && (variable && depth && (dates || !(variable is Date))))
							{
								if (objects) objects[variable] = true;
	
								// recursive call
								output += ": " + variable;
								if (ObjectUtils.hasValues(variable))
								{
									if (ObjectUtils.isDynamic(variable))
									{
										output += " (dynamic)";
									}
	
									output += "\n" + tabs + "\u007B";
									output += Functions.dump(variable, depth - 1, objects, constants, namespaces, methods, dates, skipEmpty, isInited, tabs);
									output += "\n" + tabs + "}";
								}
							}
							else
							{
								output += ": " + ObjectUtils.convertToString(variable) + (objects && objects[variable] ? " (duplicate)" : "");
							}
						}
						break;
					}
					case ObjectType.FUNCTION:
					{
						output += "(";
	
						if (vardata.xml && vardata.xml.parameter && vardata.xml.parameter is XMLList)
						{
							var lenj:int = (vardata.xml.parameter as XMLList).length();
							var optional:Boolean = false;
							for (var j:int = 0; j < lenj; j++)
							{
								if (j) output += ", ";
								if (!optional && vardata.xml.parameter[j].@optional == "true")
								{
									optional = true;
									output += "(";
								}
								output += "arg" + vardata.xml.parameter[j].@index + ":" + getClassName(String(vardata.xml.parameter[j].@type));
							}
							if (optional) output += ")";
						}
						output += ")" + (vardata.xml ? ":" + getClassName(String(vardata.xml.@returnType)) : "");
						break;
					}
					default:
					{
						vardata.type ||= getClassName(variable);
	
						// variable is not an object nor string, just trace it out normally
						output += ": " + variable;
	
						// add value as hex for uints
						if (vardata.type == "uint" || vardata.type == "int") output += " (0x" + uint(variable).toString(16).toUpperCase() + ")";
	
						break;
					}
				}
			}
			output += " (";
			var varType:String = getClassName(vardata.type);
			var valueType:String = variable !== null && variable != WRITEONLY ? getClassName(variable is String ? String : variable) : null;
			if (vardata.type)
			{
				output += varType;
				if (valueType != varType && valueType && varType != "Number" && varType != "uint") output += " -> " + valueType;
			}
			else
			{
				output += varType;
			}
			output += ")";
			
			if (vardata.access && vardata.access != "readwrite") output += " (" + vardata.access + ")"; 
		}

		// here we need to displaying the closing '}' or ']', so we bring
		// the indent back a tab, and set the outerchar to be it's matching
		// closing char, then display it in the output window
		tabs = tabs.substr(0, tabs.length - 1);

		if (openChar) output += "\n" + tabs + ((openChar == "[") ? "]" : "}");

		return output;
	}
	
	private static function isVector(object:Object):Boolean
	{
		 return getQualifiedClassName(object).indexOf("__AS3__.vec::Vector.") === 0;
	}
}

final class ObjectVariableData
{
	public var name:*;
	public var type:String;
	public var xml:XML;
	public var uri:String;
	public var access:String;

	public function ObjectVariableData(name:*, type:String = null, xml:XML = null, uri:String = null, access:String = null) 
	{
		this.name = name;
		this.type = type;
		this.xml = xml;
		this.uri = uri;
		this.access = access;
	}
}