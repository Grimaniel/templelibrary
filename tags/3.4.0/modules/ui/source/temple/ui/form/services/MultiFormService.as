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
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.core.events.CoreEventDispatcher;
	import temple.ui.form.result.IFormResult;
	import temple.utils.types.EventUtils;

	import flash.events.IEventDispatcher;

	/**
	 * An <code>IFormService</code> which allows you to combine multiple form services to one.
	 * 
	 * @see temple.ui.form.services.IFormService
	 * @see temple.ui.form.Form
	 * 
	 * @author Thijs Broerse
	 */
	public class MultiFormService extends CoreEventDispatcher implements IFormService
	{
		private var _services:Vector.<IFormService>;
		private var _currentServiceId:int;
		private var _submitData:Object;
		
		public function MultiFormService(services:Vector.<IFormService> = null)
		{
			_services = services ? services.concat() : new Vector.<IFormService>();
			
		}
		
		/**
		 * Add an IFormService to the MultiFormService
		 */
		public function addFormService(service:IFormService):void
		{
			_services.push(service);
		}

		/**
		 * @inheritDoc
		 */
		public function submit(data:Object):IFormResult
		{
			if (!_services.length)
			{
				throwError(new TempleError(this, "MultiFormService doesn't contain any services"));
			}
			_currentServiceId = -1;
			_submitData = data;
			
			return next(_submitData);
		}

		private function next(data:Object):IFormResult
		{
			var service:IFormService = IFormService(_services[++_currentServiceId]);
			
			var result:IFormResult = service.submit(data);
			
			if (result)
			{
				if (!result.success)
				{
					// We have an error stop submitting and return result
					return result;
				}
				else if (result.data)
				{
					// TODO: what to do with data?
				}
				// more services left?
				if (_currentServiceId < _services.length - 1)
				{
					return next(data);
				}
				else
				{
					return result;
				}
			}
			else
			{
				EventUtils.addAll(FormServiceEvent, service, handleFormServiceEvent);
			}
			return null;
		}

		private function handleFormServiceEvent(event:FormServiceEvent):void
		{
			EventUtils.removeAll(FormServiceEvent, IEventDispatcher(event.target), handleFormServiceEvent);
			
			// If we have more services left and submit was successful, continue. Otherwise submit result.
			if (_currentServiceId < _services.length - 1
			&& (event.type == FormServiceEvent.SUCCESS || event.type == FormServiceEvent.RESULT && event.result.success))
			{
				var result:IFormResult = next(_submitData);
				if (result)
				{
					dispatchEvent(new FormServiceEvent(FormServiceEvent.RESULT, result));
				}
			}
			else
			{
				dispatchEvent(event);
			}
		}

		override public function destruct():void
		{
			if (_services)
			{
				_services.length = 0;
				_services = null;
			}
			_submitData = null;
			super.destruct();
		}

	}
}
