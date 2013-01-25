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

package temple.utils
{
	import temple.common.interfaces.IHasValue;
	import temple.core.CoreObject;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
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
		private var _eventType:String;
		
		public function ValueBinder(source:IHasValue, target:Object, property:String, propertyProxy:IPropertyProxy = null, eventType:String = Event.CHANGE)
		{
			if (!source) throwError(new TempleArgumentError(this, "source cannot be null"));
			if (!target) throwError(new TempleArgumentError(this, "target cannot be null"));
			if (!property) throwError(new TempleArgumentError(this, "property cannot be null"));
			
			_source = source;
			_target = target;
			_property = property;
			_propertyProxy = propertyProxy;
			_eventType = eventType;
			
			if (_source is IEventDispatcher) IEventDispatcher(_source).addEventListener(_eventType, handleChange);
			update();
		}

		public function get propertyProxy():IPropertyProxy
		{
			return _propertyProxy;
		}

		public function set propertyProxy(value:IPropertyProxy):void
		{
			_propertyProxy = value;
		}
		
		public function get source():IHasValue
		{
			return _source;
		}
		
		public function get target():Object
		{
			return _target;
		}
		
		public function get eventType():String
		{
			return _eventType;
		}
		
		public function update():void
		{
			if (_propertyProxy)
			{
				_propertyProxy.setValue(_target, _property, _source.value);
			}
			else
			{
				_target[_property] = _source.value;
			}
		}

		private function handleChange(event:Event):void
		{
			update();
		}

		override public function destruct():void
		{
			if (_source && _source is IEventDispatcher) IEventDispatcher(_source).removeEventListener(_eventType, handleChange);
			_source = null;
			_target = null;
			_propertyProxy = null;
			_property = null;
			
			super.destruct();
		}
	}
}
