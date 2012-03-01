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
			this._showVars = showVars;
			this._hideVars = hideVars;
			this.showDuration = showDuration;
			this.hideDuration = hideDuration;
			
			this.hide(true);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function show(instant:Boolean = false):void
		{
			this.tween(true, instant ? 0 : this._showDuration, this._showVars);
		}

		/**
		 * @inheritDoc
		 */
		override public function hide(instant:Boolean = false):void
		{
			this.tween(false, instant ? 0 : this._hideDuration, this._hideVars);
		}
		
		/**
		 * Duration in seconds of the fade-in animation
		 */
		public final function get showDuration():Number
		{
			return this._showDuration;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Show duration", type="Number", defaultValue="0.5")]
		public final function set showDuration(value:Number):void
		{
			if (isNaN(value)) throwError(new TempleArgumentError(this, "showDuration cannot be NaN"));
			
			this._showDuration = value;
		}
		
		/**
		 * Duration in seconds of the fade-in animation
		 */
		public final function get hideDuration():Number
		{
			return this._hideDuration;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Hide duration", type="Number", defaultValue="0.5")]
		public final function set hideDuration(value:Number):void
		{
			if (isNaN(value)) throwError(new TempleArgumentError(this, "hideDuration cannot be NaN"));
			
			this._hideDuration = value;
		}
		
		private function tween(show:Boolean, duration:Number, vars:Object):void
		{
			if (vars == null)
			{
				throwError(new TempleArgumentError(this, "Vars cannot be null"));
				return;
			}
			if (this.enabled == false || this._shown == show && duration > 0) return;
			this._shown = show;
			vars.immediateRender = duration == 0;
			if (this._tween) this._tween.kill();
			this._tween = TweenMax.to(this, duration, vars);
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._tween)
			{
				this._tween.kill();
				this._tween = null;
			}
			this._showVars = null;
			this._hideVars = null;
			
			super.destruct();
		}

	}
}
