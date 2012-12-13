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

package temple.net 
{
	import temple.common.interfaces.IDataResult;
	import temple.common.interfaces.IPendingCall;
	import temple.core.events.CoreEventDispatcher;
	import temple.utils.FrameDelay;

	import flash.events.Event;


	/**
	 * @author Arjan van Wijk
	 */
	public class CachedCall extends CoreEventDispatcher implements IPendingCall 
	{
		private var _frameDelay:FrameDelay;
		private var _isLoading:Boolean;
		private var _isLoaded:Boolean;
		private var _result:IDataResult;

		public function CachedCall()
		{
			this.toStringProps.push("result");
		}

		public function execute(result:IDataResult, callback:Function, frameDelay:int = 1):CachedCall 
		{
			this._result = result;
			
			// do framedelay for async
			if (frameDelay > 0)
			{
				this._frameDelay = new FrameDelay(function ():void
				{
					_isLoading = false;
					_isLoaded = true;
					callback(result);
					dispatchEvent(new Event(Event.COMPLETE));
				}, frameDelay);
				
				this._isLoading = true;
			}
			else
			{
				this._isLoading = false;
				this._isLoaded = true;
				
				callback(result);
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function cancel():Boolean
		{
			if (this._isLoaded || !this._frameDelay) return false;
			
			this._frameDelay.destruct();
			dispatchEvent(new Event(Event.CANCEL));
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get result():IDataResult
		{
			return this._result;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoading():Boolean
		{
			return this._isLoading;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoaded():Boolean
		{
			return this._isLoaded;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			if (this._frameDelay)
			{
				this._frameDelay.destruct();
				this._frameDelay = null;
			}
			super.destruct();
		}
	}
}
