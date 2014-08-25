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

package temple.ui.buttons.behaviors 
{
	import temple.data.collections.HashMap;

	import com.greensock.TweenMax;
	import com.greensock.easing.EaseLookup;

	import flash.display.DisplayObject;

	/**
	 * The ButtonTweenBehavior uses TweenMax to tween to a state. To define a state you just add
	 * an object with properties as you would do for a 'normal' TweenMax tween. 
	 * 
	 * @includeExample ../TweenButtonExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class ButtonTweenBehavior extends AbstractButtonDesignBehavior
	{
		private static const _UP:String = "up";
		private static const _OVER:String = "over";
		private static const _DOWN:String = "down";
		private static const _SELECTED:String = "selected";
		private static const _DISABLED:String = "disabled";
		private static const _FOCUS:String = "focus";
		
		private static const _PRIORITY:Array = [_UP, _FOCUS, _OVER, _DOWN, _DISABLED, _SELECTED];
		
		private var _states:HashMap;
		private var _tween:TweenMax;
		
		public function ButtonTweenBehavior(target:DisplayObject, upDuration:Number = NaN, upVars:Object = null, overDuration:Number = NaN, overVars:Object = null, downDuration:Number = NaN, downVars:Object = null)
		{
			super(target);
			
			_states = new HashMap("ButtonTweenBehaviorStates");
			
			this.upDuration = upDuration;
			this.upVars = upVars;
			
			this.overDuration = overDuration;
			this.overVars = overVars;
			
			this.downDuration = downDuration;
			this.downVars = downVars;
		}

		public function get upVars():Object
		{
			return getVars(_UP);
		}
		
		public function set upVars(value:Object):void
		{
			setVars(_UP, value);
		}
		
		/**
		 * Total duration of the 'up' animation in seconds
		 */
		public function get upDuration():Number
		{
			return getDuration(_UP);
		}
		
		/**
		 * @private
		 */
		public function set upDuration(value:Number):void
		{
			setDuration(_UP, value);
		}
		
		public function setUpTween(duration:Number, vars:Object):void
		{
			upDuration = duration;
			upVars = vars;
		}

		public function get overVars():Object
		{
			return getVars(_OVER);
		}
		
		/**
		 * @private
		 */
		public function set overVars(value:Object):void
		{
			setVars(_OVER, value);
		}
		
		/**
		 * Total duration of the 'over' animation in seconds
		 */
		public function get overDuration():Number
		{
			return getDuration(_OVER);
		}
		
		/**
		 * @private
		 */
		public function set overDuration(value:Number):void
		{
			setDuration(_OVER, value);
		}
		
		public function setOverTween(duration:Number, vars:Object):void
		{
			overDuration = duration;
			overVars = vars;
		}
		
		public function get downVars():Object
		{
			return getVars(_DOWN);
		}
		
		/**
		 * @private
		 */
		public function set downVars(value:Object):void
		{
			setVars(_DOWN, value);
		}
		
		/**
		 * Total duration of the 'down' animation in seconds
		 */
		public function get downDuration():Number
		{
			return getDuration(_DOWN);
		}
		
		/**
		 * @private
		 */
		public function set downDuration(value:Number):void
		{
			setDuration(_DOWN, value);
		}
		
		public function setDownTween(duration:Number, vars:Object):void
		{
			downDuration = duration;
			downVars = vars;
		}
		
		public function get selectedVars():Object
		{
			return getVars(_SELECTED);
		}
		
		/**
		 * @private
		 */
		public function set selectedVars(value:Object):void
		{
			setVars(_SELECTED, value);
		}
		
		/**
		 * Total duration of the 'selected' animation in seconds
		 */
		public function get selectedDuration():Number
		{
			return getDuration(_SELECTED);
		}
		
		/**
		 * @private
		 */
		public function set selectedDuration(value:Number):void
		{
			setDuration(_SELECTED, value);
		}
		
		public function setSelectedTween(duration:Number, vars:Object):void
		{
			selectedDuration = duration;
			selectedVars = vars;
		}
		
		public function get disabledVars():Object
		{
			return getVars(_DISABLED);
		}
		
		/**
		 * @private
		 */
		public function set disabledVars(value:Object):void
		{
			setVars(_DISABLED, value);
		}
		
		/**
		 * Total duration of the 'disabled' animation in seconds
		 */
		public function get disabledDuration():Number
		{
			return getDuration(_DISABLED);
		}
		
		/**
		 * @private
		 */
		public function set disabledDuration(value:Number):void
		{
			setDuration(_DISABLED, value);
		}
		
		public function setDisabledTween(duration:Number, vars:Object):void
		{
			disabledDuration = duration;
			disabledVars = vars;
		}
		
		public function get focusVars():Object
		{
			return getVars(_FOCUS);
		}
		
		/**
		 * @private
		 */
		public function set focusVars(value:Object):void
		{
			setVars(_FOCUS, value);
		}
		
		/**
		 * Total duration of the 'disabled' animation in seconds
		 */
		public function get focusDuration():Number
		{
			return getDuration(_FOCUS);
		}
		
		/**
		 * @private
		 */
		public function set focusDuration(value:Number):void
		{
			setDuration(_FOCUS, value);
		}
		
		public function setFocusTween(duration:Number, vars:Object):void
		{
			focusDuration = duration;
			focusVars = vars;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Order of priority:
		 * 
		 * 	selected
		 * 	disabled
		 * 	down
		 * 	over
		 * 	focus
		 * 	up
		 * 	
		 */
		override public function update(status:IButtonStatus):void
		{
			super.update(status);
			
			if (!enabled) return;
			
			if (debug) logDebug("update: selected=" + selected + ", disabled=" + disabled + ", over=" + over + ", down=" + down);
			
			var vars:Object = {};
			var duration:Number;
			
			var state:String;
			var data:StateData;
			var isChanged:Boolean;
			var leni:int = _PRIORITY.length;
			for (var i:int = 0; i < leni; i++)
			{
				state = _PRIORITY[i];
				
				if (state == _UP || status[state])
				{
					data = _states[state];
					
					if (data && data.vars)
					{
						// Check for TweenLiteVars
						overwriteVars(data.vars.isGSVars ? data.vars.vars : data.vars, vars);
						duration = data.duration;
						isChanged = true;
					}
				}
			}
			if (isChanged)
			{
				if (debug) logDebug("update: duration: " + duration + ", vars: " + dump(vars));
				
				if (isNaN(duration)) duration = 0;
				if (vars['ease'] is String) vars['ease'] = EaseLookup.find(vars['ease']);
				vars.immediateRender = duration == 0;
				_tween = TweenMax.to(target, duration, vars);
			}
		}

		private function getVars(state:String):Object
		{
			return state in _states ? StateData(_states[state]).vars : null;
		}

		private function setVars(state:String, vars:Object):void
		{
			var data:StateData = _states[state] || new StateData();
			data.vars = vars;
			_states[state] = data;
			
			if (debug) logDebug(state + ": " + dump(vars));
			update(this);
		}

		private function getDuration(state:String):Number
		{
			return state in _states ? StateData(_states[state]).duration : NaN;
		}


		private function setDuration(state:String, duration:Number):void
		{
			var data:StateData = _states[state] || new StateData();
			data.duration = duration;
			_states[state] = data;
		}


		private function overwriteVars(from:Object, to:Object):void
		{
			for (var key:String in from)
			{
				to[key] = from[key];
			}
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
			
			if (_states)
			{
				for (var state : String in _states)
				{
					StateData(_states[state]).vars = null;
					delete _states[state];
				}
				_states = null;
			}
			super.destruct();
		}
	}
}

class StateData
{
	public var duration:Number;
	public var vars:Object;
}
