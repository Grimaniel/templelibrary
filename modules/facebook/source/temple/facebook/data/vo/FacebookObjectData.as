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
	import temple.data.index.AbstractIndexable;
	import temple.facebook.data.FacebookParser;
	import temple.facebook.data.facebook;
	import temple.facebook.service.IFacebookCall;
	import temple.facebook.service.IFacebookService;

	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookObjectData extends AbstractIndexable implements IFacebookObjectData
	{
		/**
		 * Used by Indexer
		 * @see temple.data.index.Indexer#INDEX_CLASS
		 */
		public static function get indexClass():Class
		{
			return IFacebookObjectData;
		}
		
		// Register this class as implementation of IFacebookUserData
		FacebookParser.facebook::CLASS_MAP[IFacebookObjectData] = FacebookObjectData;

		private var _service:IFacebookService;
		private var _type:String;
		private var _connections:Vector.<String>;
		private var _profile:IFacebookProfileData;
		private var _hasProfile:Boolean;
		private var _name:String;
		
		public function FacebookObjectData(service:IFacebookService, type:String = null, connections:Vector.<String> = null, hasProfile:Boolean = false)
		{
			super(null, IFacebookObjectData);
			
			_service = service;
			_type = type;
			_connections = connections;
			_hasProfile = hasProfile;
			toStringProps.length = 0;
			toStringProps.push("name", "id", "type");
		}
		
		/**
		 * @private
		 */
		[Transient]
		override public final function get indexClass():Class
		{
			return super.indexClass;
		}

		/**
		 * @inheritDoc
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			_name = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get type():String
		{
			return _type;
		}

		/**
		 * @inheritDoc
		 */
		public function set type(value:String):void
		{
			if (_type && _type != value)
			{
				logError("Types don't match '" + _type + "' != '" + value + "'");
			}
			
			_type = value;;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get connections():Vector.<String>
		{
			return _connections;
		}

		/**
		 * @inheritDoc
		 */
		public function get fields():IFacebookFields
		{
			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function get profile():IFacebookProfileData
		{
			return _profile ||= _service.getProfile(id, _hasProfile);
		}

		/**
		 * @inheritDoc
		 */
		public function get(connection:String, callback:Function = null, objectClass:Class = null, params:Object = null, fields:IFacebookFields = null, forceReload:Boolean = false):IFacebookCall
		{
			if (!_connections || _connections.indexOf(connection) == -1)
			{
				logWarn(this + " doesn't have a '" + connection + "' connection");
			}
			return _service.get(callback, connection, id, objectClass, params, fields, forceReload);
		}

		/**
		 * @inheritDoc
		 */
		public function getService():IFacebookService
		{
			return _service;
		}
		
		/**
		 * @private
		 */
		protected function get service():IFacebookService
		{
			return _service;
		}
	}
}
