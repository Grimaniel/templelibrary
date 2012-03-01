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

package temple.data.xml 
{
	import temple.core.CoreObject;

	/**
	 * Internal class used by the XMLManager to store information about a loaded XML.
	 * 
	 * @author Thijs Broerse
	 */
	internal final class XMLObjectData extends CoreObject
	{
		public static var OBJECT:int = 1;
		public static var LIST:int = 2;

		private var _type:int;
		private var _objectClass:Class;
		private var _node:String;
		private var _callback:Function;
		private var _object:Object;
		private var _list:Array;
		private var _cache:Boolean;

		public function XMLObjectData(type:int, objectClass:Class, node:String, cache:Boolean, callback:Function = null) 
		{
			this._type = type;
			this._objectClass = objectClass;
			this._node = node;
			this._cache = cache;
			this._callback = callback;
			this.toStringProps.push('objectClass');
		}
		
		public function get type():int
		{
			return this._type;
		}
		
		public function get objectClass():Class
		{
			return this._objectClass;
		}
		
		public function get node():String
		{
			return this._node;
		}
		
		internal function get callback():Function
		{
			return this._callback;
		}
		
		internal function set callback(value:Function):void
		{
			this._callback = value;
		}

		public function get object():Object
		{
			return this._object;
		}
		
		internal function setObject(value:Object):void
		{
			this._object = value;
		}
		
		public function get list():Array
		{
			return this._list;
		}
		
		internal function setList(value:Array):void
		{
			this._list = value;
		}
		
		public function get cache():Boolean
		{
			return this._cache;
		}

		override public function destruct():void
		{
			this._objectClass = null;
			this._node = null;
			this._callback = null;
			this._object = null;
			this._list = null;
			
			super.destruct();
		}
	}
}
