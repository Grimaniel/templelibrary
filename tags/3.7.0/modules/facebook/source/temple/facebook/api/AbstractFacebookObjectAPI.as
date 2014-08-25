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

package temple.facebook.api
{
	import temple.core.CoreObject;
	import temple.facebook.data.vo.IFacebookFields;
	import temple.facebook.service.IFacebookCall;
	import temple.facebook.service.IFacebookService;

	/**
	 * @author Thijs Broerse
	 */
	internal class AbstractFacebookObjectAPI extends CoreObject
	{
		private var _service:IFacebookService;
		private var _method:String;
		private var _objectClass:Class;
		
		public function AbstractFacebookObjectAPI(service:IFacebookService, method:String, objectClass:Class)
		{
			_service = service;
			_method = method;
			_objectClass = objectClass;
		}

		/**
		 * @private
		 */
		protected function getItem(id:String, callback:Function, fields:IFacebookFields, params:Object, forceReload:Boolean):IFacebookCall
		{
			return _service.get(callback, null, id, _objectClass, params, fields, forceReload);
		}

		/**
		 * @private
		 */
		protected function getItems(callback:Function, id:String, offset:Number, limit:Number, fields:IFacebookFields, params:Object, forceReload:Boolean):IFacebookCall
		{
			if (!isNaN(offset))	(params ||= {}).offset = uint(offset);
			if (!isNaN(limit)) (params ||= {}).limit = uint(limit);
			
			return _service.get(callback, _method, id, _objectClass, params, fields, forceReload);
		}
		
		/**
		 * @private
		 */
		protected function getAlltems(callback:Function, id:String, fields:IFacebookFields, forceReload:Boolean, resultsPerPage:Number = NaN):IFacebookCall
		{
			if (!isNaN(resultsPerPage)) var params:Object = {offset: 0, limit: resultsPerPage};
			
			return new FacebookBatchCall(_service, callback, _method, id, _objectClass, params, fields, forceReload);
		}
		
		/**
		 * @private
		 */
		protected function getItemsById(ids:Vector.<String>, objectClass:Class, callback:Function, offset:Number, limit:Number, fields:IFacebookFields, params:Object, forceReload:Boolean):IFacebookCall
		{
			if (!isNaN(offset))	(params ||= {}).offset = uint(offset);
			if (!isNaN(limit)) (params ||= {}).limit = uint(limit);
			
			return _service.get(callback, "?ids=" + ids.join(","), null, objectClass, params, fields, forceReload);
		}

		/**
		 * @private
		 */
		protected function get service():IFacebookService
		{
			return _service;
		}
		
		/**
		 * @private
		 */
		protected function get method():String
		{
			return _method;
		}

		/**
		 * @private
		 */
		protected function get objectClass():Class
		{
			return _objectClass;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_service = null;
			_objectClass = null;
			
			super.destruct();
		}
	}
}
