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

package temple.utils.keys 
{
	import temple.common.interfaces.IEnableable;
	import temple.core.CoreObject;
	import temple.core.debug.IDebuggable;
	import temple.core.destruction.Destructor;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.utils.ClosureArgs;
	import temple.utils.types.FunctionUtils;
	import temple.utils.types.ObjectUtils;

	import flash.display.Stage;
	import flash.events.KeyboardEvent;


	/**
	 * Class for directly coupling Keyboard events to actions, without having to bother about event filtering.
	 * 
	 * @example
	 * <listing version="3.0">
	 * keyMapper = new KeyMapper(this.stage);
	 * keyMapper.map(Keyboard.ENTER, this.submit);
	 * keyMapper.map(Keyboard.ESCAPE, this.cancel);
	 * </listing>
	 * 
	 * <p>It is also possible to map key combinations with the Shift, Alt and/or Control key.</p>
	 * 
	 * <listing version="3.0">
	 * keyMapper = new KeyMapper(this.stage);
	 * keyMapper.map(KeyCode.D | KeyMapper.CONTROL, Destructor.destruct, this);
	 * keyMapper.map(KeyCode.R | KeyMapper.CONTROL, Memory.logRegistry);
	 * </listing>
	 * 
	 * Make sure to clean up when you're done:
	 * <listing version="3.0">
	 * keyMapper.destruct();
	 * </listing>
	 * 
	 * @includeExample KeyMapperExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class KeyMapper extends CoreObject implements IEnableable, IDebuggable
	{
		/**
		 * Added when the shift-key is down while pressing a key
		 */
		public static const SHIFT:uint = 2<<10;
		
		/**
		 * Added when the control-key is down while pressing a key
		 */
		public static const CONTROL:uint = 2<<11;
		
		/**
		 * Added when the alt-key is down while pressing a key
		 */
		public static const ALT:uint = 2<<12;
		
		private var _map:Object;
		private var _stage:Stage;
		private var _keyboardEvent:String;
		private var _enabled:Boolean = true;
		private var _debug:Boolean;

		/**
		 * Creates a new KeyMapper instance
		 * @param stage a reference to the stage. Needed for handling KeyBoardEvents
		 * @param keyboardEvent pass KeyboardEvent.KEY_DOWN (default) if you want to listen for KEY_DOWN events,
		 * otherwise pass KeyboardEvent.KEY_UP if you want to listen for KEY_UP events.
		 */
		public function KeyMapper(stage:Stage, keyboardEvent:String = KeyboardEvent.KEY_DOWN) 
		{
			if (!stage) throwError(new TempleArgumentError(this, "stage can not be null"));
			
			if (keyboardEvent != KeyboardEvent.KEY_UP && keyboardEvent != KeyboardEvent.KEY_DOWN)
			{
				throwError(new TempleArgumentError(this, "invalid value for keyboardEvent '" + keyboardEvent + "'"));
			}
			this._map = {};
			this._stage = stage;
			this._keyboardEvent = keyboardEvent;
			this._stage.addEventListener(this._keyboardEvent, this.handleKeyEvent);
		}

		/**
		 * Map a key to a function
		 * @param key keyCode of the key to map
		 * @param method the method to be called when the key is pressed
		 * @param arguments the argument to be passed to the method when called
		 */
		public function map(key:uint, method:Function, arguments:Array = null):void 
		{
			if (this._map[key]) throwError(new TempleError(this, "You already mapped key '" + String.fromCharCode(key) + "' (" + key + ")"));
			
			if (arguments && arguments.length)
			{
				this._map[key] = new ClosureArgs(method, arguments);
			}
			else
			{
				this._map[key] = method;
			}
		}
		
		/**
		 * Removes the function of a key
		 */
		public function unmap(key:uint):void 
		{
			delete this._map[key];
		}
		
		/**
		 * temporary enable/disable the mapper
		 */
		public function get enabled():Boolean
		{
			return this._enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set enabled(value:Boolean):void
		{
			this._enabled = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function enable():void
		{
			this.enabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function disable():void
		{
			this.enabled = false;
		}

		/**
		 * Returns information about the key mapping.
		 * Note: only works in the debug player
		 */
		public function getInfo():String 
		{
			var info:String = "";
			var shift:uint;
			var control:uint;
			var alt:uint;
			var keyCode:uint;
			for (var key:String in this._map)
			{
				keyCode =  uint(key);
				keyCode -= shift = keyCode & KeyMapper.SHIFT;
				keyCode -= control = keyCode & KeyMapper.CONTROL;
				keyCode -= alt = keyCode & KeyMapper.ALT;
				
				info += String.fromCharCode(keyCode);
				
				info += shift || control || alt ? " +" : "\t";
				info += shift ? "S" : "";
				info += control ? "C" : "";
				info += alt ? "A" : "";
				info += "\t";
				
				if (this._map[key] is ClosureArgs)
				{
					info += FunctionUtils.functionToString(ClosureArgs(this._map[key]).method).substr(0, -2);
					info += "(";
					var arguments:Array = ClosureArgs(this._map[key]).arguments;
					var leni:int = arguments.length;
					for (var i:int = 0; i < leni; i++)
					{
						if (i) info += ", ";
						info += ObjectUtils.convertToString(arguments[i]);
					}
					info += ")";
				}
				else
				{
					info += FunctionUtils.functionToString(this._map[key]);
				}
				info += "\n";
			}
			return info;
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

		private function handleKeyEvent(event:KeyboardEvent):void 
		{
			if (!this._enabled)
			{
				if (this.debug) this.logDebug("KeyMapper disabled " + event);
				return;
			}
			
			var keyCode:uint = event.keyCode;
			if (event.shiftKey) keyCode |= KeyMapper.SHIFT;
			if (event.altKey) keyCode |= KeyMapper.ALT;
			if (event.ctrlKey) keyCode |= KeyMapper.CONTROL;
			
			if (this._map && this._map[keyCode])
			{
				if (this.debug) this.logDebug("handleKeyEvent: " + event);
				
				if (this._map[keyCode] is ClosureArgs)
				{
					ClosureArgs(this._map[keyCode]).execute();
				}
				else
				{
					this._map[keyCode]();
				}
			}
			else
			{
				if (this.debug) this.logDebug("handleKeyEvent: unhandled key " + event);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			if (this._stage)
			{
				this._stage.removeEventListener(this._keyboardEvent, this.handleKeyEvent);
				this._stage = null;
				this._keyboardEvent = null;
			}
			
			this._map = Destructor.destruct(this._map);
			
			super.destruct();
		}
	}
}
