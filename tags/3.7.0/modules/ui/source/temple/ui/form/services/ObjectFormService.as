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

package temple.ui.form.services 
{
	import temple.utils.PropertyApplier;
	import temple.common.interfaces.IObjectParsable;
	import temple.core.events.CoreEventDispatcher;
	import temple.ui.form.result.FormResult;
	import temple.ui.form.result.IFormResult;
	import temple.utils.types.ObjectUtils;

	/**
	 * @eventType temple.ui.form.services.FormServiceEvent.RESULT
	 */
	[Event(name = "FormServiceEvent.result", type = "temple.ui.form.services.FormServiceEvent")]
	
	/**
	 * A FormObjectService stores the submit data in an object. The object must be set in the FormObjectService.
	 * If the object implements IObjectParsable, the submitted data will be parsed to the object with the 'parseObject' method.
	 * Otherwise the properties of the submitted data will be applied on the object.
	 * 
	 * @see temple.common.interfaces.IObjectParsable
	 * 
	 * @includeExample FormExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class ObjectFormService extends CoreEventDispatcher implements IFormService 
	{
		private var _debug:Boolean;
		private var _object:Object;

		/**
		 * Creates a new FormObjectService
		 * The FormObjectService stores the form data in an object
		 * @param object the object to store the data in, if the object implements IObjectParsable, the parseObject method is used to store 
		 */
		public function ObjectFormService(object:Object = null)
		{
			_object = object;
		}
		
		/**
		 * @inheritDoc
		 */
		public function submit(data:Object):IFormResult
		{
			if (debug) logDebug("submit: " + dump(data));

			var success:Boolean;
			
			if (_object == null)
			{
				logError("submit: object is not set yet");
			}
			else if (_object is IObjectParsable)
			{
				success = IObjectParsable(_object).parseObject(data);
			}
			else
			{
				success = true;
				
				var isDynamic:Boolean = ObjectUtils.isDynamic(_object);

				for (var key:String in data)
				{
					if (key in _object || isDynamic)
					{
						_object[key] = data[key];
					}
					else if (!PropertyApplier.setProperty(_object, key, data[key]))
					{
						logError("submit: object has no property '" + key + "'");
						success = false;
					}
				}
			}
			if (debug) logDebug("object: " + dump(_object));
			
			var result:IFormResult = new FormResult(success);
			dispatchEvent(new FormServiceEvent(FormServiceEvent.RESULT, result));
			
			return result;
		}
		
		/**
		 * The object that store the form data after submission
		 * If the object implement IObjectParsable, the parseObject method is used to store
		 */
		public function get object():Object
		{
			return _object;
		}
		
		/**
		 * @private
		 */
		public function set object(value:Object):void
		{
			_object = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_debug = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_object = null;
			super.destruct();
		}
	}
}
