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
			this._object = object;
		}
		
		/**
		 * @inheritDoc
		 */
		public function submit(data:Object):IFormResult
		{
			if (this.debug) this.logDebug("submit: " + ObjectUtils.traceObject(data, 2, false));

			var success:Boolean;
			
			if (this._object == null)
			{
				this.logError("submit: object is not set yet");
			}
			else if (this._object is IObjectParsable)
			{
				success = IObjectParsable(this._object).parseObject(data);
			}
			else
			{
				success = true;
				
				var isDynamic:Boolean = ObjectUtils.isDynamic(this._object);

				for (var key:String in data)
				{
					if (this._object.hasOwnProperty(key) || isDynamic)
					{
						this._object[key] = data[key];
					}
					else
					{
						this.logError("submit: object has no property '" + key + "'");
						success = false;
					}
				}
			}
			if (this.debug) this.logDebug("object: " + ObjectUtils.traceObject(this._object, 1, false));
			
			var result:IFormResult = new FormResult(success);
			this.dispatchEvent(new FormServiceEvent(FormServiceEvent.RESULT, result));
			
			return result;
		}
		
		/**
		 * The object that store the form data after submission
		 * If the object implement IObjectParsable, the parseObject method is used to store
		 */
		public function get object():Object
		{
			return this._object;
		}
		
		/**
		 * @private
		 */
		public function set object(value:Object):void
		{
			this._object = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			this._debug = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._object = null;
			super.destruct();
		}
	}
}
