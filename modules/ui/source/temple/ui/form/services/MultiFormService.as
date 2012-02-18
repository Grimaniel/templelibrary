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
			this._services = services ? services.concat() : new Vector.<IFormService>();
			
		}
		
		/**
		 * Add an IFormService to the MultiFormService
		 */
		public function addFormService(service:IFormService):void
		{
			this._services.push(service);
		}

		/**
		 * @inheritDoc
		 */
		public function submit(data:Object):IFormResult
		{
			if (!this._services.length)
			{
				throwError(new TempleError(this, "MultiFormService doesn't contain any services"));
			}
			this._currentServiceId = -1;
			this._submitData = data;
			
			return this.next(this._submitData);
		}

		private function next(data:Object):IFormResult
		{
			var service:IFormService = IFormService(this._services[++this._currentServiceId]);
			
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
				if (this._currentServiceId < this._services.length - 1)
				{
					return this.next(data);
				}
				else
				{
					return result;
				}
			}
			else
			{
				EventUtils.addAll(FormServiceEvent, service, this.handleFormServiceEvent);
			}
			return null;
		}

		private function handleFormServiceEvent(event:FormServiceEvent):void
		{
			EventUtils.removeAll(FormServiceEvent, IEventDispatcher(event.target), this.handleFormServiceEvent);
			
			// If we have more services left and submit was successful, continue. Otherwise submit result.
			if (this._currentServiceId < this._services.length - 1
			&& (event.type == FormServiceEvent.SUCCESS || event.type == FormServiceEvent.RESULT && event.result.success))
			{
				var result:IFormResult = this.next(this._submitData);
				if (result)
				{
					this.dispatchEvent(new FormServiceEvent(FormServiceEvent.RESULT, result));
				}
			}
			else
			{
				this.dispatchEvent(event);
			}
		}

		override public function destruct():void
		{
			if (this._services)
			{
				this._services.length = 0;
				this._services = null;
			}
			this._submitData = null;
			super.destruct();
		}

	}
}
