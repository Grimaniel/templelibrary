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
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	/**
	 * @author Thijs Broerse
	 */
	public final class DescriptionUtils
	{
		/**
		 * 
		 */
		public static function findVariablesWithMetadata(description:IDescription, name:String, value:String = null, key:String = null):Vector.<IVariable>
		{
			if (description == null) return throwError(new TempleArgumentError(DescriptionUtils, "description cannot be null"));
			
			var variables:Vector.<IVariable> = new Vector.<IVariable>(), metadata:IMetadata;
			
			variables: for (var i:int = 0, leni:int = description.variables.length; i < leni; i++)
			{
				metadata = description.variables[i].getMetadata(name);
				
				if (metadata)
				{
					if (!value && !key || key && metadata.args[key] == value || !value && key && key in metadata.args)
					{
						variables.push(description.variables[i]);
					}
					else if (!key && value)
					{
						for each (var v:String in metadata.args)
						{
							if (v == value)
							{
								variables.push(description.variables[i]);
								break variables;
							}
						}
					}
				}
			}
			return variables;
		}
		
		/**
		 * 
		 */
		public static function findMembersWithMetadata(description:IDescription, name:String, value:String = null, key:String = null):Vector.<IMember>
		{
			if (description == null) return throwError(new TempleArgumentError(DescriptionUtils, "description cannot be null"));
			
			var members:Vector.<IMember> = new Vector.<IMember>(), metadata:IMetadata;
			
			members: for (var i:int = 0, leni:int = description.members.length; i < leni; i++)
			{
				metadata = description.members[i].getMetadata(name);
				
				if (metadata)
				{
					if (!value && !key || key && metadata.args[key] == value || !value && key && key in metadata.args)
					{
						members.push(description.members[i]);
					}
					else if (!key && value)
					{
						for each (var v:String in metadata.args)
						{
							if (v == value)
							{
								members.push(description.members[i]);
								break members;
							}
						}
					}
				}
			}
			return members;
		}
		
		/**
		 * Gets list of meta data of full inheritance chain
		 */
		public static function getMetaDataOfExtendClasses(description:IDescription, name:String, key:String = null):Vector.<IMetadata>
		{
			var metaData:Vector.<IMetadata> = new Vector.<IMetadata>();
			
			var currentData:IMetadata = description.getMetadata(name);
			if (key != null)
			{
				if (currentData && key in currentData.args) metaData.push(currentData);
			}
			else
			{
				if (currentData) metaData.push(currentData);
			}
			
			var extendsClass:IDescription;
			for (var i:uint = 0, leni:uint = description.extendsClass.length; i < leni; i++)
			{
				extendsClass = Descriptor.get(description.extendsClass[i]);
				var data:IMetadata = extendsClass.getMetadata(name);
				if (key != null)
				{
					if (data && key in data.args) metaData.push(data);
				}
				else
				{
					if (data) metaData.push(data);
				}
			}
			return metaData;
		}
		
		/**
		 * Merges args of full inheritance chain to one object
		 */
		public static function getMergedMetaDataArgsOfExtendClasses(description:IDescription, name:String):Object
		{
			var args:Object = {};
			var metadata:Vector.<IMetadata> = getMetaDataOfExtendClasses(description, name);
			for (var i:uint = 0, leni:uint = metadata.length; i < leni; i++)
			{
				var classArgs:Object = metadata[i].args;
				
				for(var key:String in classArgs)
				{
					args[key] = classArgs[key]; // merge/overwrite if already exist
				}
			}
			return args;
		}
		
		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(DescriptionUtils);
		}
	}
}
