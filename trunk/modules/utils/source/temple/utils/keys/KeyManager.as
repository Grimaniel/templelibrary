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
	import temple.core.destruction.Destructor;
	import temple.core.CoreObject;
	import temple.core.debug.IDebuggable;
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;

	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	/**
	 * Utility class for checking if a key is currently pressed by the user.
	 * 
	 * @author Thijs Broerse
	 */
	public class KeyManager extends CoreObject implements IDebuggable
	{
		private static const _INSTANCE:KeyManager = new KeyManager();
		
		private var _stage:Stage;
		private var _debug:Boolean;
		private var _downKeys:Object;

		public function KeyManager()
		{
			if (_INSTANCE) throwError(new TempleError(this, "Singleton, don't call constructor directly"));
			
			this._downKeys = {};
		}
		
		/**
		 * Initialize the KeyManager. You only have to call this once. But calling this multiple times doesn't break anything.
		 */
		public static function init(stage:Stage):void
		{
			KeyManager._INSTANCE.init(stage);
		}

		/**
		 * Indicates if a key is currently down
		 */
		public static function isDown(keyCode:uint):Boolean 
		{
			if (!KeyManager._INSTANCE._stage)
			{
				Log.warn("KeyManager is not initialized yet, please call KeyManager.init(stage);", KeyManager);
				return false;
			}
			return Boolean(keyCode in KeyManager._INSTANCE._downKeys);
		}

		
		/**
		 * @private
		 */
		public static function get debug():Boolean
		{
			return KeyManager._INSTANCE.debug;
		}
		
		/**
		 * @private
		 */
		public static function set debug(value:Boolean):void
		{
			KeyManager._INSTANCE.debug = value;
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
			if (this.debug) this.logDebug("debug enabled");
		}

		private function init(stage:Stage):void
		{
			if (this._stage) return;
			if (stage == null)
			{
				this.logError("stage can not be null");
				return;
			}
			
			this._stage = stage;
			this._stage.addEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown, true, int.MAX_VALUE);
			this._stage.addEventListener(KeyboardEvent.KEY_UP, this.handleKeyUp, true, int.MAX_VALUE);
			this._stage.addEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown, false, int.MAX_VALUE);
			this._stage.addEventListener(KeyboardEvent.KEY_UP, this.handleKeyUp, false, int.MAX_VALUE);
		}
		
		private function handleKeyDown(event:KeyboardEvent):void 
		{
			if (this._debug) this.logDebug("KeyDown: " + event);
			this._downKeys[event.keyCode] = true;
		}

		private function handleKeyUp(event:KeyboardEvent):void 
		{
			if (this._debug) this.logDebug("KeyUp: " + event);
			delete this._downKeys[event.keyCode];
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			if (this._stage)
			{
				this._stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown, true);
				this._stage.removeEventListener(KeyboardEvent.KEY_UP, this.handleKeyUp, true);
				this._stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown, false);
				this._stage.removeEventListener(KeyboardEvent.KEY_UP, this.handleKeyUp, false);
				this._stage = null;
			}
			this._downKeys = Destructor.destruct(this._downKeys);
			super.destruct();
		}

		/**
		 * @private
		 */
		public static function toString():String 
		{
			return objectToString(KeyManager);
		}
	}
}