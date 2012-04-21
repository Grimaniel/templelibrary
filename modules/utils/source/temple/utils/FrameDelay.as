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
	import temple.common.interfaces.IPauseable;
	import temple.core.CoreObject;
	import temple.core.debug.IDebuggable;
	import temple.utils.types.FunctionUtils;

	import flash.events.Event;


	/**
	 * Delay a function call with one or more frames. Use this when initializing a SWF or a bunch of DisplayObjects, to enable the player to do its thing.	Usually a single frame delay will do the job, since the next enterFrame will come when all other jobs are finished.
	 * To execute function 'init' after 1 frame, use:
	 * 
	 * @example
	 * <listing version="3.0">
	 * new FrameDelay(init);
	 * </listing>
	 * 
	 * To execute function 'init' after 10 frames, use:
	 * <listing version="3.0">
	 * new FrameDelay(init, 10);
	 * </listing>
	 * 
	 * To call function 'setProps' with parameters, executed after 1 frame:
	 * <listing version="3.0">
	 * new FrameDelay(setProps, 1, [shape, 'alpha', 0]);
	 * </listing>
	 * 
	 * <listing version="3.0">
	 * private function setProps (shape:Shape, property:String, value:Number):void
	 * {
	 * 		shape[property] = value;
	 * }
	 * </listing>
	 * 
	 * @author ASAPLibrary, Thijs Broerse
	 */
	public final class FrameDelay extends CoreObject implements IPauseable, IDebuggable
	{
		/**
		 * Make frame-delayed callback: (eg: a closure to .resume() of a paused FrameDelay)
		 */
		public static function closure(callback:Function, frameCount:int = 1, params:Array = null):Function
		{
			var fd:FrameDelay = new FrameDelay(callback, frameCount, params);
			fd.pause();
			return fd.resume;
		}
		
		private var _isDone:Boolean = false;
		private var _currentFrame:int;
		private var _callback:Function;
		private var _params:Array;
		private var _paused:Boolean;
		private var _debug:Boolean;
		private var _callbackString:String;

		/**
		 * Creates a new FrameDelay. Starts the delay immediately.
		 * @param callback the callback function to be called when done waiting
		 * @param frameCount the number of frames to wait; when left out, or set to 1 or 0, one frame is waited
		 * @param params list of parameters to pass to the callback function
		 * @param debug if set to true, debug information will be logged.
		 */
		public function FrameDelay(callback:Function, frameCount:int = 1, params:Array = null, debug:Boolean = false) 
		{
			this.toStringProps.push('callback');
			
			this._currentFrame = frameCount;
			this._callback = callback;
			this._params = params;
			this._isDone = frameCount <= 1;
			FramePulse.addEnterFrameListener(this.handleEnterFrame);
			
			this.debug = debug;
		}

		/**
		 * Returns the callback as a String, useful for debug purposes.
		 */
		public function get callback():String
		{
			return this._callbackString ||= FunctionUtils.functionToString(this._callback);
		}
		
		/**
		 * @inheritDoc
		 */
		public function pause():void
		{
			if (this.debug) this.logDebug("pause: ");
			
			FramePulse.removeEnterFrameListener(this.handleEnterFrame);
			this._paused = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function resume():void
		{
			if (this.debug) this.logDebug("resume: ");
			
			if (!this.isDestructed && this._paused)
			{
				FramePulse.addEnterFrameListener(handleEnterFrame);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get paused():Boolean
		{
			return this._paused;
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
		 * Handle the Event.ENTER_FRAME event.
		 * Checks if still waiting - when true: calls callback function.
		 * @param event not used
		 */
		private function handleEnterFrame(event:Event):void 
		{
			if (this._isDone) 
			{
				FramePulse.removeEnterFrameListener(this.handleEnterFrame);
				if (this._callback != null)
				{
					if (this.debug) this.logDebug("Done, execute callback: ");
					
					this._callback.apply(null, this._params);
				}
				this.destruct();
			}
			else 
			{
				this._currentFrame--;
				this._isDone = (this._currentFrame <= 1);
				
				if (this.debug) this.logDebug("handleEnterFrame: wait for " + this._currentFrame + " frames...");
			}
		}
		
		/**
		 * Release reference to creating object.
		 * Use this to remove a FrameDelay object that is still running when the creating object will be removed.
		 */
		override public function destruct():void 
		{
			if (this.debug) this.logDebug("destruct: ");
			
			FramePulse.removeEnterFrameListener(this.handleEnterFrame);
			
			this._callback = null;
			this._params = null;
			
			super.destruct();
		}
	}
}