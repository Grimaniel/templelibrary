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

package temple.facebook.data.vo
{
	import temple.core.CoreObject;
	import temple.core.debug.getClassName;
	import temple.data.Trivalent;
	import temple.facebook.data.enum.FacebookFieldAlias;
	import temple.facebook.data.enum.FacebookMetadataTag;
	import temple.reflection.reflect;

	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	internal class AbstractFacebookFields extends CoreObject implements IFacebookFields
	{
		protected static function all(type:Class):Vector.<String>
		{
			var desciption:XML = reflect(type);
			
			var all:Vector.<String> = new Vector.<String>();
			var list:XMLList = desciption..variable.(@type == "Boolean" || @type == "*");
			for each (var node:XML in list)
			{
				all.push(node.@['name']);
			}
			return all;
		}
		
		private static var _aliasesAvailable:Trivalent = Trivalent.UNDEFINED;
		
		private var _desciption:XML;
		private var _limit:uint;
		private var _customFields:Vector.<String>;

		/**
		 * @param fields an optional list of fields with must be set to <code>true</code> automatically
		 */
		public function AbstractFacebookFields(fields:Vector.<String>, limit:int)
		{
			if (fields) select(fields);
			_limit = limit;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get limit():uint
		{
			return _limit;
		}

		/**
		 * @inheritDoc
		 */
		public function set limit(value:uint):void
		{
			_limit = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function select(fields:Vector.<String>):void
		{
			for (var i:int = 0, leni:int = fields.length; i < leni; i++)
			{
				if (fields[i] in this)
				{
					this[fields[i]] = true;
				}
				else
				{
					logWarn(getClassName(this) + " has no field '" + fields[i] + "'");
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function all():Vector.<String>
		{
			_desciption ||= reflect(this);
			
			var all:Vector.<String> = new Vector.<String>();
			var list:XMLList = _desciption..variable.(@type == "Boolean" || @type == "*");
			for each (var node:XML in list)
			{
				all.push(node.@['name']);
			}
			
			return all;
		}
		
		/**
		 * Returns true if the SWF is compiled with [Alias] metadata tag.
		 * This method has the [Alias] metadata tag, so we can check if this tag is available.
		 */
		[Alias]
		public function aliasesAvailable():Boolean
		{
			if (AbstractFacebookFields._aliasesAvailable == Trivalent.UNDEFINED)
			{
				_desciption ||= reflect(this);
				AbstractFacebookFields._aliasesAvailable = _desciption..metadata.(@name == FacebookMetadataTag.ALIAS.value).length() > 0 ? Trivalent.TRUE : Trivalent.FALSE;
			}
			return AbstractFacebookFields._aliasesAvailable == Trivalent.TRUE;
		}

		/**
		 * @inheritDoc
		 */
		public function getFieldsList(alias:FacebookFieldAlias):Vector.<String>
		{
			if (alias && !aliasesAvailable())
			{
				logWarn("Alias metadata is not available. Please compile your SWF with the \"-keep-as3-metadata+=Alias\" argument");
			}
			
			var fields:Vector.<String> = new Vector.<String>();
			_desciption ||= reflect(this);
			
			var list:XMLList = _desciption..variable.(@type == "Boolean" || @type == "*");
			var name:String, nameAlias:String;		
			for each (var node:XML in list)
			{
				name = node.@['name'];
				if (this[name] === true || this[name] is IFacebookFields)
				{
					if (alias) nameAlias = node.metadata.(@name == "Alias").arg.(@key == alias.value).@value;
					if (nameAlias != "not-available") fields.push(nameAlias || name);
				}

			}
			if (_customFields) fields = fields.concat(_customFields);
			
			// sort 
			fields.sort(0);
			
			return fields;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getFieldsString(alias:FacebookFieldAlias):String
		{
			var list:Vector.<String> = getFieldsList(alias);
			
			if (alias == FacebookFieldAlias.GRAPH)
			{
				var props:Vector.<String> = getFieldsList(null);
				for (var i:int = 0, leni:int = list.length; i < leni; i++)
				{
					if (props[i] in this && this[props[i]] is IFacebookFields)
					{
						var fields:IFacebookFields = IFacebookFields(this[props[i]]);
						// TODO: make this more dynamic
						if (fields is FacebookPictureFields)
						{
							if (FacebookPictureFields(fields).width) list[i] += ".width(" + FacebookPictureFields(fields).width + ")";
							if (FacebookPictureFields(fields).height) list[i] += ".height(" + FacebookPictureFields(fields).height + ")";
							if (FacebookPictureFields(fields).type) list[i] += ".type(" + FacebookPictureFields(fields).type + ")";
						}
						else
						{
							// call getFieldsList if fields object is the same as this to prevent an infinite loop
							list[i] += ".fields(" + (fields == this ? fields.getFieldsList(alias) : fields.getFieldsString(alias)) + ")";
							
							if (fields.limit) list[i] += ".limit(" + fields.limit + ")";
						}
					}
				}
			}
			return list.toString();
		}

		/**
		 * @inheritDoc
		 */
		public function getPermissions(me:Boolean = true):Vector.<String>
		{
			return null;
		}
		
		/**
		 * Sets all fields to true
		 */
		public function selectAll():void
		{
			for each (var node:XML in reflect(this)..variable.(@type == "Boolean" || @type == "*"))
			{
				this[node.@['name']] = true;
			}
		}
		
		/**
		 * @includeExample
		 */
		public function addCustomField(field:String):void
		{
			(_customFields ||= new Vector.<String>()).push(field);
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_desciption = null;
			_customFields = null;
			
			super.destruct();
		}
	}
}
