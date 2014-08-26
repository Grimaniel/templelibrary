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

package temple.utils.eventbinding
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import temple.core.behaviors.AbstractBehavior;

	/**
	 * Binds an event to a function.
	 * 
	 * @author Thijs Broerse
	 */
	public class EventBinder extends AbstractBehavior
	{
		private var _type:String;
		private var _callback:Function;
		private var _params:Array;
		private var _useCapture:Boolean;
		private var _once:Boolean;

		public function EventBinder(target:IEventDispatcher, type:String, callback:Function, params:Array = null, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false, once:Boolean = false)
		{
			super(target);

			_type = type;
			_callback = callback;
			_params = params;
			_useCapture = useCapture;
			_once = once;
			target.addEventListener(_type, handleEvent, _useCapture, priority, useWeakReference);
			
			toStringProps.push("type");
		}

		public function get eventDispatcher():IEventDispatcher
		{
			return target as IEventDispatcher;
		}

		public function get type():String
		{
			return _type;
		}

		public function get callback():Function
		{
			return _callback;
		}

		public function get params():Array
		{
			return _params;
		}
		
		/**
		 * Indicates if the <code>EventBinder</code> should be destructed after the first event
		 */
		public function get once():Boolean
		{
			return _once;
		}

		/**
		 * @inheritDoc
		 */
		public function set once(value:Boolean):void
		{
			_once = value;
		}
		
		private function handleEvent(event:Event):void
		{
			_callback.apply(null, _params);
			if (_once) destruct();
		}

		override public function destruct():void
		{
			if (target) IEventDispatcher(target).removeEventListener(_type, handleEvent, _useCapture);
			
			_callback = null;
			_type = null;
			_params = null;
			
			super.destruct();
		}
	}
}
