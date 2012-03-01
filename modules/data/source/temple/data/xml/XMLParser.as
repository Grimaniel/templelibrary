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
package temple.data.xml
{
	import temple.common.interfaces.IXMLParsable;
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;

	/**
	 * Class for parsing XML data into DataValueObject classes.
	 * 
	 * <p>The class provides static functions for calling IXMLParsable.parseXML() on newly created objects of a
	 * specified type, either for single data blocks or for an array of similar data.
	 * The Parser removes the tedious for-loop from the location where the XML data is loaded, and moves the 
	 * parsing of the XML data to the location where it's used for the first time: the DataValueObject class.
	 * Your application can use this data, that contains typed variables, without ever caring about the 
	 * original source of the data.
	 * When the XML structure is changed, only the parsing function in the DataValueObject class has to be 
	 * changed, thereby facilitating maintenance and development.</p>
	 * 
	 * <p>Consider an XML file with the following content:</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * &lt;?xml version="1.0" encoding="UTF-8"?>
	 * &lt;settings&gt;
	 * 	&lt;urls&gt;
	 * 		&lt;url name="addressform" url="../xml/address.xml" /&gt;
	 * 		&lt;url name="entries" url="../xml/entries.xml" /&gt;
	 * 	&lt;/urls&gt;
	 * &lt;/settings&gt;
	 * </listing>
	 * 
	 * <p>Once the XML has been loaded, it can be converted into an Array of URLData objects with the following code:</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * var urls:Array = Parser.parseList(xml.urls.url, URLData, false);
	 * </listing>
	 * <p>After calling this function, the variable urls contains a list of objects of type URLData, filled 
	 * with the content of the XML file.</p>
	 * 
	 * <p>Notes to this code:</p>
	 * 
	 * <p>The first parameter to parseList is a (can be a) repeating node where each node contains similar data to be 
	 * parsed into. Conversion of nodes to an Array is not necessary. If the &lt;urls&gt;-node in the aforementioned XML 
	 * file would contain only one &lt;url&gt;-node, the parser still returns an Array, with one object of type URLData.
	 * Since the last parameter to the call to parseList is false, an error in the xml data will result in urls being null. 
	 * The parsing class determines if the data is valid or not, by returning true or false from parseObject().</p>
	 * 
	 * @see temple.common.interfaces.IXMLParsable#parseXML(xml)
	 * 
	 * @author Thijs Broerse
	 */
	public final class XMLParser
	{
		/**
		 * Parse an XMLList into an array of the specified class instance by calling its parseXML function
		 * @param list XMLList to parse
		 * @param objectClass classname to be instanced; class must implement IXMLParsable
		 * @param ignoreError if true, the return value of parseXML is always added to the array, and the array itself is
		 * returned. Otherwise, an error in parsing will return null.
		 * @param debug if true information is logged if the parsing failed
		 * @return Array of new objects of the specified type, cast to IXMLParsable, or null if parsing returned false.
		 *	
		 * @see temple.common.interfaces.IXMLParsable#parseXML(xml)
		 */
		public static function parseList(list:XMLList, objectClass:Class, ignoreError:Boolean = false, debug:Boolean = true):Array
		{
			var a:Array = new Array();

			var len:Number = list.length();
			for (var i:Number = 0;i < len; i++)
			{
				var ipa:IXMLParsable = XMLParser.parseXML(list[i], objectClass, ignoreError, debug);
				if ((ipa == null) && !ignoreError)
				{
					return null;
				}
				else
				{
					a.push(ipa);
				}
			}

			return a;
		}

		/**
		 * Parse XML into the specified class instance by calling its parseXML function
		 * @param xml XML document or node
		 * @param objectClass classname to be instanced; class must implement IXMLParsable
		 * @param ignoreError if true, the return value of IXMLParsable is ignored, and the newly created object is always returned
		 * @param debug if true information is logged if the parsing failed
		 * @return a new object of the specified type, cast to IXMLParsable, or null if parsing returned false.
		 *	
		 * @see temple.common.interfaces.IXMLParsable#parseXML(xml)
		 */
		public static function parseXML(xml:XML, objectClass:Class, ignoreError:Boolean = false, debug:Boolean = false):IXMLParsable
		{
			if (!xml) throwError(new TempleArgumentError(XMLParser, "xml can not be null"));

			var parsable:IXMLParsable = new objectClass() as IXMLParsable;

			if (parsable == null)
			{
				throwError(new TempleArgumentError(XMLParser, "Class '" + objectClass + "' does not implement IXMLParsable"));
			}
			else if (parsable.parseXML(xml) || ignoreError)
			{
				return parsable;
			}
			if (debug) Log.error("Error parsing xml: " + xml + " to " + parsable, XMLParser);

			return null;
		}

		/**
		 * Parse XML into the specified class instances by calling its parseXML function and set as properties on a collection object (hash-map or typed object).
		 * @param xml XML document or node
		 * @param objectClass classname to be instanced; class must implement IXMLParsable
		 * @param target object on which to set the properties, defaults to new generic Object
		 * @param nameAttribute optionally specify which attribute sets the property name (defaults to node-name)
		 * @param ignoreError if true, the return value of IXMLParsable is ignored, and the newly created object is always returned
		 * @param debug if true information is logged if the parsing failed
		 * @return the object on which the properties are set with the newly parsed instances
		 *	
		 * @see temple.common.interfaces.IXMLParsable#parseXML(xml)
		 */
		public static function parseListToProps(list:XMLList, objectClass:Class, target:Object = null, nameAttribute:String = null, ignoreError:Boolean = false, debug:Boolean = false):Object
		{
			target ||= {};

			var collide:Array = [];

			for each (var node:XML in list)
			{
				var name:String = nameAttribute ? String(node.@[nameAttribute]) : String(node.name());
				if (!ignoreError && collide.indexOf(name) > -1)
				{
					throwError(new TempleArgumentError(XMLParser, "name collision on property " + name));
				}
				else
				{
					var ipa:IXMLParsable = XMLParser.parseXML(node, objectClass, ignoreError, debug);
					if (ipa != null)
					{
						target[name] = ipa;
						collide.push(name);
					}
				}
			}
			return target;
		}

		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(XMLParser);
		}
	}
}
