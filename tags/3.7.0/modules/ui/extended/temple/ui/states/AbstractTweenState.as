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

package temple.ui.states 
{
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;

	import com.greensock.TweenMax;

	/**
	 * This class uses TweenLite to show and hide the object. This class is used as base for several states.
	 * 
	 * @includeExample StatesExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class AbstractTweenState extends AbstractState implements IState 
	{
		private var _showDuration:Number;
		private var _hideDuration:Number;
		private var _showVars:Object;
		private var _hideVars:Object;
		private var _tween:TweenMax;

		public function AbstractTweenState(showVars:Object, hideVars:Object, showDuration:Number = .5, hideDuration:Number = .5)
		{
			_showVars = showVars;
			_hideVars = hideVars;
			this.showDuration = showDuration;
			this.hideDuration = hideDuration;
			
			hide(true);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function show(instant:Boolean = false, onComplete:Function = null):void
		{
			tween(true, instant ? 0 : _showDuration, _showVars, onComplete);
		}

		/**
		 * @inheritDoc
		 */
		override public function hide(instant:Boolean = false, onComplete:Function = null):void
		{
			tween(false, instant ? 0 : _hideDuration, _hideVars, onComplete);
		}
		
		/**
		 * Object which contains the variables which are applied on the object when the object must be shown
		 */
		public function get showVars():Object
		{
			return _showVars;
		}

		/**
		 * Object which contains the variables which are applied on the object when the object must be hidden
		 */
		public function get hideVars():Object
		{
			return _hideVars;
		}
		
		/**
		 * Duration in seconds of the fade-in animation
		 */
		public final function get showDuration():Number
		{
			return _showDuration;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Show duration", type="Number", defaultValue="0.5")]
		public final function set showDuration(value:Number):void
		{
			if (isNaN(value)) throwError(new TempleArgumentError(this, "showDuration cannot be NaN"));
			
			_showDuration = value;
		}
		
		/**
		 * Duration in seconds of the fade-in animation
		 */
		public final function get hideDuration():Number
		{
			return _hideDuration;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Hide duration", type="Number", defaultValue="0.5")]
		public final function set hideDuration(value:Number):void
		{
			if (isNaN(value)) throwError(new TempleArgumentError(this, "hideDuration cannot be NaN"));
			
			_hideDuration = value;
		}
		
		private function tween(show:Boolean, duration:Number, vars:Object, onComplete:Function):void
		{
			if (vars == null)
			{
				throwError(new TempleArgumentError(this, "Vars cannot be null"));
				return;
			}
			if (enabled == false || _shown == show && duration > 0) return;
			_shown = show;
			vars.immediateRender = duration == 0;
			if (onComplete != null) vars.onComplete = onComplete;
			if (_tween) _tween.kill();
			_tween = TweenMax.to(this, duration, vars);
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_tween)
			{
				_tween.kill();
				_tween = null;
			}
			_showVars = null;
			_hideVars = null;
			
			super.destruct();
		}
	}
}
