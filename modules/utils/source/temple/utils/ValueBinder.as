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

package temple.utils
{
	import temple.common.interfaces.IHasValue;
	import temple.core.CoreObject;
	import temple.utils.propertyproxy.IPropertyProxy;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * Automatically checks when the value of an object is changed and sets this new value to a property of an other object.
	 * 
	 * @author Thijs Broerse
	 */
	public class ValueBinder extends CoreObject
	{
		private var _source:IHasValue;
		private var _target:Object;
		private var _property:String;
		private var _propertyProxy:IPropertyProxy;
		
		public function ValueBinder(source:IHasValue, target:Object, property:String, propertyProxy:IPropertyProxy = null, eventType:String = Event.CHANGE)
		{
			this._source = source;
			this._target = target;
			this._property = property;
			this._propertyProxy = propertyProxy;
			
			if (this._source is IEventDispatcher)
			{
				IEventDispatcher(this._source).addEventListener(eventType, this.handleChange);
			}
			this.update();
		}

		public function get propertyProxy():IPropertyProxy
		{
			return this._propertyProxy;
		}

		public function set propertyProxy(value:IPropertyProxy):void
		{
			this._propertyProxy = value;
		}
		
		public function update():void
		{
			if (this._propertyProxy)
			{
				this._propertyProxy.setValue(this._target, this._property, this._source.value);
			}
			else
			{
				this._target[this._property] = this._source.value;
			}
		}

		private function handleChange(event:Event):void
		{
			this.update();
		}
	}
}
